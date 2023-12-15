return {
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    opts = {
        indent = {
            char = '│',
        },
        scope = {
            enabled = false,
            show_start = false,
            show_end = false,
        },
    },
    event = 'LazyFile',
    keys = {
        {
            'yoe',
            '<cmd>IBLToggle<CR>',
            desc = 'Toggle indentation guides',
        },
        {
            '[oe',
            '<cmd>IBLEnable<CR>',
            desc = 'Enable indentation guides',
        },
        {
            ']oe',
            '<cmd>IBLDisable<CR>',
            desc = 'Disable indentation guides',
        },
        {
            'yop',
            '<cmd>IBLToggleScope<cr>',
            desc = 'Toggle scope guides'
        },
        {
            '[op',
            '<cmd>IBLEnableScope<cr>',
            desc = 'Enable scope guides',
        },
        {
            ']op',
            '<cmd>IBLDisableScope<cr>',
            desc = 'Disable scope guides',
        },
    },
}
