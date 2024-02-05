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
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    -- Rounded border
    opts.border = vim.g.nerdfonts and 'rounded' or 'single'
    -- Make windows not focusable
    -- opts.focusable = opts.focusable or false
    local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
    -- Don't highlight possible errors in LSP floats
    -- vim.api.nvim_set_option_value('winhl', 'Error:None', {
    --     scope = 'local',
    --     win = winnr,
    -- })
    return bufnr, winnr
end
