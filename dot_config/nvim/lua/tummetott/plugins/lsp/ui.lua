---@diagnostic disable: duplicate-set-field

-- Define diagnostic icons
local signs = {
    Error = vim.g.nerdfonts and '' or 'E',
    Warn = vim.g.nerdfonts and '' or 'W',
    Hint = vim.g.nerdfonts and '' or 'H',
    Info = vim.g.nerdfonts and '' or 'I',
}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

-- Set global options for all diagnostics
vim.diagnostic.config {
    signs = true,
    virtual_text = false,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
}

-- Global UI overwrites for all LSP popup windows (hover, diagnostics,
-- signature help)
local open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = 'rounded'
    -- Triggering vim.lsp.buf.signature_help() twice in an autocmd for automatic
    -- signature help opening can unintentionally focus the float. To avoid
    -- inadvertently shifting focus to the float while typing in insert mode,
    -- the automatic focusing is disabled disabled.
    if opts.focus_id == 'textDocument/signatureHelp' then
        opts.focus_id = nil
    end
    -- Make windows not focusable
    -- opts.focusable = opts.focusable or false
    local bufnr, winnr = open_floating_preview(contents, syntax, opts, ...)
    return bufnr, winnr
end
