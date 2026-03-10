return {
    'tummetott/dismiss.nvim',
    enabled = true,
    lazy = true,
    opts = {
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
        labels = {
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
    },
}
