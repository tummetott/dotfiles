return {
    'tummetott/follow.nvim',
    enabled = true,
    lazy = true,
    opts = {
        highlight = {
            hlgroup = 'FollowReferenceHighlight',
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
                if not require('follow').follow({
                    jump = true,
                    highlight = true,
                }) then
                    vim.api.nvim_feedkeys(vim.keycode('<C-]>'), 'n', false)
                end
            end,
            desc = 'Goto file reference or jump to definition',
        },
    },
    highlights = {
        FollowReferenceHighlight = { bg = 'darkest_grey' },
    },
}
