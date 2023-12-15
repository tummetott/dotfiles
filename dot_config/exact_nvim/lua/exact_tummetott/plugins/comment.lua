return {
    'numToStr/Comment.nvim',
    enabled = true,
    config = true,
    keys = {
        {
            'gc',
            mode = { 'n', 'x' },
            desc = 'Comment toggle linewise',
        },
        {
            'gb',
            mode = { 'n', 'x' },
            desc = 'Comment toggle blockwise',
        },
        {
            -- Toggle line comment with CTRL-/ in insert and normal mode
            '<c-/>',
            function() require('Comment.api').toggle.linewise.current() end,
            desc = 'Comment toggle current line',
            mode = { 'n', 'i' },
        },
        {
            -- Comment the current selection
            '<c-/>',
            'gc',
            desc = 'Comment toggle current selection',
            remap = true,
            mode = 'x',
        },
    },
}
