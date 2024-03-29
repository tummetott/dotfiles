-- Define diagnostic icons
if vim.g.nerdfonts then
    local signs = {
        Error = '',
        Warn = '',
        Hint = '',
        Info = '',
    }
    for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
    end
end

-- Set global options for all diagnostics
vim.diagnostic.config {
    signs = true,
    virtual_text = false,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = true,
        border = 'rounded',
    },
}

-- Overwrite default signature help and hover handlers to display floating
-- windows with rounded borders.
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        focusable = true,
        border = 'rounded'
    }
)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        focusable = true,
        border = 'rounded'
    }
)
