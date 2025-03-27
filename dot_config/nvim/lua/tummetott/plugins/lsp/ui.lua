-- Set global options for all diagnostics
vim.diagnostic.config {
    virtual_text = false,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    signs = vim.g.nerdfonts and {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    } or true,
}
