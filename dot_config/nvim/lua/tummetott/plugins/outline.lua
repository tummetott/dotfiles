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
        },
    },
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
        {
            '<leader>x',
            '<cmd>Outline!<cr>',
            desc = 'Toggle Outline',
        }
    }
}
