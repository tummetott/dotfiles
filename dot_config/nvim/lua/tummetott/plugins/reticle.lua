local utils = require 'tummetott.utils'

return {
    'tummetott/reticle.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        on_startup = {
            cursorline = true,
        },
        follow = {
            cursorline = true,
            cursorcolumn = true,
        },
        disable_in_insert = true,
        disable_in_diff = true,
        always_highlight_number = true,
        on_focus = {
            cursorline = { 'help' },
        },
        ignore = {
            cursorline = {
                'FTerm',
                'NvimSeparator',
                'NvimTree',
                'TelescopePrompt',
                'trouble',
                'snacks_dashboard',
                'DiffviewFileHistory',
                'DiffviewFiles',
            },
        },
    },
    keys = {
        {
            '<leader><space>c',
            function()
                local reticle = require 'reticle'
                reticle.toggle_cursorline()
                utils.echo_toggle('Cursorline', reticle.has_cursorline())
            end,
            desc = 'Cursorline',
        },
        {
            '<leader><space>u',
            function()
                local reticle = require 'reticle'
                reticle.toggle_cursorcolumn()
                utils.echo_toggle('Cursorcolumn', reticle.has_cursorcolumn())
            end,
            desc = 'Cursorcolumn',
        },
    }
}
