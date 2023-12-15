return {
    'tummetott/reticle.nvim',
    enabled = true,
    dev = true,
    event = 'VeryLazy',
    opts = {
        always_highlight_number = true,
        on_startup = {
            cursorline = true,
        },
        on_focus = {
            cursorline = { 'help' },
        },
        ignore = {
            cursorline = {
                'TelescopePrompt',
                'NvimTree',
                'Trouble',
                'NvimSeparator',
                'alpha',
                'FTerm',
            },
        },
    },
}
