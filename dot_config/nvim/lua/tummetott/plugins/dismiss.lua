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
                'snacks_layout_box',
                'man',
                'DiffviewFiles',
                'DiffviewFileHistory',
                'qf',
                'sidekick_terminal',
                'Outline',
                'nvim-undotree',
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
            desc = 'Dismiss Window',
        },
        {
            'g<c-q>',
            function()
                require('dismiss').pick()
            end,
            mode = { 'n' },
            desc = 'Pick Window to Close',
        },
    },
}
