return {
    'tummetott/dismiss.nvim',
    enabled = true,
    lazy = true,
    ---@type dismiss.ConfigOptions
    opts = {
        prefer_focused = true,
        fallback_to_current = false,
        match = {
            filetypes = {
                'trouble',
                'help',
                'NvimTree',
                'man',
                'DiffviewFiles',
                'DiffviewFileHistory',
                'qf',
                'sidekick_terminal',
                'Outline',
            },
            condition = function(win)
                -- Match cmdwin (search / cmd history)
                return vim.fn.win_gettype(win) == "command"
            end
        },
        picker = {
            hlgroup = 'DismissLabel',
        },
    },
    keys = {
        {
            '<c-q>',
            function()
                require('dismiss').dismiss()
            end,
            mode = { 'n', 't' },
            desc = 'Dismiss window',
        },
        {
            'g<c-q>',
            function()
                require('dismiss').pick()
            end,
            mode = { 'n' },
            desc = 'Pick window to close',
        },
    },
}
