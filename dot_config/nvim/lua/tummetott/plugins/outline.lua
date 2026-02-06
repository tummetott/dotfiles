return {
    'hedyhli/outline.nvim',
    enabled = true,
    dependencies = 'onsails/lspkind-nvim',
    opts = {
        auto_close = true,
        symbols = {
            icon_source = 'lspkind',
            icons = {
                String = { icon = '', hl = '@string' },
                Array = { icon = '', hl = '@constant' },
            },
            icon_fetcher = not vim.g.nerdfonts
                and function(_) return '' end or nil,
        },
        symbol_folding = {
            markers = vim.g.nerdfonts and { '', '' } or { '>', 'v' },
        },
    },
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
        {
            '<leader>o',
            '<cmd>Outline!<cr>',
            desc = 'Toggle Outline',
        }
    }
}
