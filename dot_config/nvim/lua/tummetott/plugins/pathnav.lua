return {
    'tummetott/pathnav.nvim',
    enabled = true,
    lazy = true,
    ---@type pathnav.ConfigOptions
    opts = {
        highlight = {
            hlgroup = 'PathnavReferenceText',
            clear_events = { 'CursorMoved' },
        },
        target_window = {
            exclude = {
                current = false,
                filetypes = {
                    'trouble',
                },
                buftypes = {
                    'help',
                    'prompt',
                    'quickfix',
                    'terminal',
                },
                condition = nil,
            },
            prefer = {
                matching_file = true,
                last_target = false,
            },
            split = {
                direction = 'right',
                force = false,
            },
        },
    },
    keys = {
        {
            'gf',
            function()
                require('pathnav').open()
            end,
            desc = 'Jump to file under cursor',
        },
    },
    highlights = {
        PathnavReferenceText = { bg = 'darkest_grey' },
    },
}
