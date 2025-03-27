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

-- Overwrite all LSP floating windows to display rounded borders.
local original_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return original_open_floating_preview(contents, syntax, opts, ...)
end
