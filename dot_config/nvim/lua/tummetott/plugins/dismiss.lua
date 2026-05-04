return {
    'tummetott/dismiss.nvim',
    enabled = true,
    lazy = true,
    ---@type dismiss.ConfigOptions
    opts = {
        prefer_focused = false,
        fallback_to_current = true,
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
            condition = function()
                -- Match cmdwin (search / cmd history)
                return vim.fn.getcmdwintype() ~= ""
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
