local M = {}

-- Override the default signature help handler to make it silent
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { silent = true }
)

local trigger_store = {}

-- Open the signature help if the current character is a trigger character
local open_signature = function(buffer)
    local triggers = trigger_store[buffer]
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.')
    local cur_char = line:sub(col - 1, col - 1)
    local prev_char = line:sub(col - 2, col - 2)
    for _, trigger_char in ipairs(triggers) do
        if cur_char == trigger_char then
            vim.lsp.buf.signature_help()
            return
        elseif cur_char == ' ' and prev_char == trigger_char then
            vim.lsp.buf.signature_help()
            return
        end
    end
end

-- Add the signature help trigger characters to a per-buffer table
local add_triggers = function(client, buffer)
    local cap = client.server_capabilities
    if cap.signatureHelpProvider and cap.signatureHelpProvider.triggerCharacters then
        local new_triggers = cap.signatureHelpProvider.triggerCharacters
        local triggers = trigger_store[buffer]
        if triggers then
            for _, v in ipairs(new_triggers) do
                if not vim.tbl_contains(triggers, v) then
                    table.insert(triggers, v)
                end
            end
        else
            trigger_store[buffer] = new_triggers
        end
    end
end

M.setup = function(client, bufnr)
    local buffer = tostring(bufnr)
    add_triggers(client, buffer)
    -- Return if the current buffer doesn't have any triggers
    if not trigger_store[buffer] then return end
    -- Clear the autocmds for the current buffer
    local group = vim.api.nvim_create_augroup('LspSignature', { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    -- Create a new autocmd for the current buffer
    vim.api.nvim_create_autocmd('TextChangedI', {
        group = group,
        buffer = bufnr,
        callback = function()
            open_signature(buffer)
        end,
    })
end

-- M.reload_triggers = function()
--     vim.schedule(function()
--         vim.api.nvim_clear_autocmds({ group = 'LspSignature' })
--         trigger_store = {}
--         for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--             local clients = vim.lsp.get_active_clients { buffer = bufnr }
--             for _, client in ipairs(clients) do
--                 print('reload: ' .. client.name)
--                 M.setup(client, bufnr)
--             end
--         end
--     end)
-- end

return M
