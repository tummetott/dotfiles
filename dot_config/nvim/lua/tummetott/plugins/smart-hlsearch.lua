return {
    'tummetott/smart-hlsearch.nvim',
    enabled = true,
    opts = {
        hide_in_visual_mode = true,
        clear_after_cmdline_search = true,
    },
    keys = {
        {
            '/',
            function()
                require('smart-hlsearch').activate()
                return '/'
            end,
            mode = 'n',
            expr = true,
        },
        {
            '?',
            function()
                require('smart-hlsearch').activate()
                return '?'
            end,
            mode = 'n',
            expr = true,
        },
        -- Make `n` always move to the next match and `N` to the previous one,
        -- independent of whether the search was started with `/` or `?`.
        {
            'n',
            function()
                require('smart-hlsearch').activate()
                return ('Nn'):sub(vim.v.searchforward + 1, vim.v.searchforward + 1) .. 'zv'
            end,
            mode = 'n',
            expr = true,
        },
        {
            'N',
            function()
                require('smart-hlsearch').activate()
                return ('nN'):sub(vim.v.searchforward + 1, vim.v.searchforward + 1) .. 'zv'
            end,
            mode = 'n',
            expr = true,
        },
        {
            '*',
            function()
                require('smart-hlsearch').activate()
                return '*'
            end,
            mode = 'n',
            expr = true,
        },
        {
            '#',
            function()
                require('smart-hlsearch').activate()
                return '#'
            end,
            mode = 'n',
            expr = true,
        },
        {
            'g*',
            function()
                require('smart-hlsearch').activate()
                return 'g*'
            end,
            mode = 'n',
            expr = true,
        },
        {
            'g#',
            function()
                require('smart-hlsearch').activate()
                return 'g#'
            end,
            mode = 'n',
            expr = true,
        },
    }
}
