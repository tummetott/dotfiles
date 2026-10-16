return {
    'karb94/neoscroll.nvim',
    enabled = false,
    opts = {
        mappings = {
            '<C-u>',
            '<C-d>',
            '<C-b>',
            '<C-f>',
            'zt',
            'zz',
            'zb',
        },
        -- When true, turn of syntax highlighting while scrolling
        performance_mode = false,
        easing = 'sine',
    },
    keys = {
        {
            '<C-f>',
            mode = { 'n', 'x' },
            desc = 'Scroll Page Down',
        },
        {
            '<C-b>',
            mode = { 'n', 'x' },
            desc = 'Scroll Page Up',
        },
        {
            '<C-d>',
            mode = { 'n', 'x' },
            desc = 'Scroll Half Page Down',
        },
        {
            '<C-u>',
            mode = { 'n', 'x' },
            desc = 'Scroll Half Page Up',
        },
        {
            'zt',
            desc = 'Top This Line',
        },
        {
            'zz',
            desc = 'Center This Line',
        },
        {
            'zb',
            desc = 'Bottom This Line',
        },
    },
}
