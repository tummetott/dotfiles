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
            desc = 'Scroll page down',
        },
        {
            '<C-b>',
            mode = { 'n', 'x' },
            desc = 'Scroll page up',
        },
        {
            '<C-d>',
            mode = { 'n', 'x' },
            desc = 'Scroll half page down',
        },
        {
            '<C-u>',
            mode = { 'n', 'x' },
            desc = 'Scroll half page up',
        },
        {
            'zt',
            desc = 'Top this line',
        },
        {
            'zz',
            desc = 'Center this line',
        },
        {
            'zb',
            desc = 'Bottom this line',
        },
    },
}
