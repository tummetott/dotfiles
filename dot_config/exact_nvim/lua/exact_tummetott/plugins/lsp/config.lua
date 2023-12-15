local M = {}

local on_attach = function(client, bufnr)
    -- Setup my LSP keymaps
    require('tummetott.plugins.lsp.keymaps').register(client, bufnr)
    -- Show signature help automatically
    require('tummetott.plugins.lsp.signature').setup(client, bufnr)
    -- Autocmd to reset document highlights as soon as the cursor holds
    local group = vim.api.nvim_create_augroup('ClearDocumentHighlights', {})
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = vim.lsp.buf.clear_references,
        group = group,
        buffer = bufnr,
    })
end

M.get_config = function(server_name)
    local server_settings = require('tummetott.plugins.lsp.server-settings')
    local conf = server_settings[server_name] or {}
    conf.on_attach = on_attach
    local loaded, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if loaded then
        conf.capabilities = cmp_nvim_lsp.default_capabilities()
    end
    return conf
end

return M
