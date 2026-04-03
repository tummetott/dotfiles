return {
    'tummetott/pathnav.nvim',
    enabled = true,
    lazy = true,
    opts = {
        highlight = {
            hlgroup = 'PathnavLocation',
            clear_events = {
                'CursorMoved',
            },
        },
        target = {
            exclude = {
                current_win = true,
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
        },
    },
    keys = {
        {
            '<c-]>',
            function()
                if not require('pathnav').open({
                    jump = true,
                    highlight = true,
                }) then
                    vim.api.nvim_feedkeys(vim.keycode('<C-]>'), 'n', false)
                end
            end,
            desc = 'Open filepath or jump to definition',
        },
    },
    highlights = {
        PathnavLocation = { bg = 'darkest_grey' },
    },
}
