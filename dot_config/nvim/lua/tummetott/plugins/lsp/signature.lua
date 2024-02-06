local M = {}

local trigger_storage = {}
local method = 'textDocument/signatureHelp'
local group = vim.api.nvim_create_augroup('LspSignature', { clear = false })

-- TODO: An improved approach involves requesting signature help from all
-- language servers using buf_request_all(), then aggregating their responses.
-- The handler must process these responses into markdown and display them in a
-- single floating window.
local handler = function(_, result, ctx, config)
    config = config or {}
    if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
        -- Ignore result since buffer changed. This happens for slow language servers.
        return
    end
    if not (result and result.signatures and result.signatures[1]) then
        -- No signature help available
        return
    end
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local triggers =
        vim.tbl_get(client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters')
    local ft = vim.bo[ctx.bufnr].filetype
    local lines, hl = vim.lsp.util.convert_signature_help_to_markdown_lines(result, ft, triggers)
    if not lines or vim.tbl_isempty(lines) then
        -- No signature help available
        return
    end
    local fbuf, fwin = vim.lsp.util.open_floating_preview(lines, 'markdown', config)
    if hl then
        -- Highlight the second line if the signature is wrapped in a Markdown code block.
        local line = vim.startswith(lines[1], '```') and 1 or 0
        vim.api.nvim_buf_add_highlight(fbuf, -1, 'LspSignatureActiveParameter', line, unpack(hl))
    end
    return fbuf, fwin
end

local open_signature_help = function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, method, params, handler)
end

-- Add the signature help trigger chars to a per-buffer table
local add_triggers = function(client, buffer)
    local cap = client.server_capabilities
    if cap.signatureHelpProvider and cap.signatureHelpProvider.triggerCharacters then
        local new_triggers = cap.signatureHelpProvider.triggerCharacters
        local triggers = trigger_storage[buffer]
        if triggers then
            for _, v in ipairs(new_triggers) do
                if not vim.tbl_contains(triggers, v) then
                    table.insert(triggers, v)
                end
            end
        else
            trigger_storage[buffer] = new_triggers
        end
    end
end

-- Test if the current char is a trigger char. On success, open the signature
-- help floating window.
-- PERF: An impoved approch involves utilizing treesitter to verify if the
-- current cursor is located within a function signature node.
local on_text_change = function(buffer)
    local triggers = trigger_storage[buffer]
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.')
    local cur_char = line:sub(col - 1, col - 1)
    local prev_char = line:sub(col - 2, col - 2)
    for _, trigger_char in ipairs(triggers) do
        if cur_char == trigger_char then
            open_signature_help()
            return
        elseif cur_char == ' ' and prev_char == trigger_char then
            open_signature_help()
            return
        end
    end
end

M.setup = function(client, bufnr)
    local buffer = tostring(bufnr)
    add_triggers(client, buffer)
    -- Return if the current buffer doesn't have any triggers
    if not trigger_storage[buffer] then return end
    -- Clear the autocmds for the current buffer
    vim.api.nvim_clear_autocmds({
        group = group,
        buffer = bufnr,
    })
    -- Create a new autocmd for the current buffer
    vim.api.nvim_create_autocmd('TextChangedI', {
        group = group,
        buffer = bufnr,
        callback = function()
            on_text_change(buffer)
        end,
    })
end

-- TODO: Add triggers when a new langauge server attaches, and delete triggers
-- when an language server is detached.
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
