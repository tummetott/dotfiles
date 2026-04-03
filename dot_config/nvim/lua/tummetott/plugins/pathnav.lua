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
                filetypes = {},
                buftypes = {
                    'help',
                    'nofile',
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
            '<c-]>',
            function()
                if not require('pathnav').open() then
                    vim.api.nvim_feedkeys(vim.keycode('<C-]>'), 'n', false)
                end
            end,
            desc = 'Open filepath or jump to definition',
        },
    },
    highlights = {
        PathnavReferenceText = { bg = 'darkest_grey' },
    },
}
