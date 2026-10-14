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
                'trouble',
                'snacks_dashboard',
                'DiffviewFileHistory',
                'DiffviewFiles',
                'snacks_picker_input',
                'snacks_picker_list',
            },
        },
    },
    config = function(_, opts)
        local reticle = require 'reticle'
        reticle.setup(opts)

        Snacks.toggle.new({
            name = 'cursorline',
            get = reticle.has_cursorline,
            set = reticle.set_cursorline,
        }):map('<c-,>c')
    end,
}
