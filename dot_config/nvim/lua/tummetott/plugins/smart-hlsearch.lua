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
            desc = 'Search Forward',
        },
        {
            '?',
            function()
                require('smart-hlsearch').activate()
                return '?'
            end,
            mode = 'n',
            expr = true,
            desc = 'Search Backward',
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
            desc = 'Next Search Match'
        },
        {
            'N',
            function()
                require('smart-hlsearch').activate()
                return ('nN'):sub(vim.v.searchforward + 1, vim.v.searchforward + 1) .. 'zv'
            end,
            mode = 'n',
            expr = true,
            desc = 'Previous Search Match'
        },
        {
            'n',
            function()
                require('smart-hlsearch').activate()
                return ('Nn'):sub(vim.v.searchforward + 1, vim.v.searchforward + 1)
            end,
            mode = { 'x', 'o' },
            expr = true,
            desc = 'Next Search Result',
        },
        {
            'N',
            function()
                require('smart-hlsearch').activate()
                return ('nN'):sub(vim.v.searchforward + 1, vim.v.searchforward + 1)
            end,
            mode = { 'x', 'o' },
            expr = true,
            desc = 'Prev Search Result',
        },
        {
            '*',
            function()
                require('smart-hlsearch').activate()
                return '*'
            end,
            mode = 'n',
            expr = true,
            desc = 'Search Word Under Cursor Forward',
        },
        {
            '#',
            function()
                require('smart-hlsearch').activate()
                return '#'
            end,
            mode = 'n',
            expr = true,
            desc = 'Search Word Under Cursor Backward',
        },
        {
            'g*',
            function()
                require('smart-hlsearch').activate()
                return 'g*'
            end,
            mode = 'n',
            expr = true,
            desc = 'Search Partial Word Under Cursor Forward',
        },
        {
            'g#',
            function()
                require('smart-hlsearch').activate()
                return 'g#'
            end,
            mode = 'n',
            expr = true,
            desc = 'Search Partial Word Under Cursor Backward',
        },
    }
}
