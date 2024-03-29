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
                'alpha',
                'FTerm',
                'NvimSeparator',
                'NvimTree',
                'TelescopePrompt',
                'trouble',
            },
        },
    },
}
