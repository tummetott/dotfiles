-- Neat UI improvements for 'vim.ui.select' and 'vim.ui.input'
return {
    'stevearc/dressing.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        input = {
            win_options = {
                -- No opaque floating window
                winblend = 0,
            },
            -- go through input history with standard vim commands
            mappings = {
                i = {
                    ['<C-p>'] = 'HistoryPrev',
                    ['<C-n>'] = 'HistoryNext',
                },
            },
        },
        select = {
            -- Dressing uses telescope as default select. Whenever telescope is not
            -- found, it falls back to a buildin floating window
            builtin = {
                win_options = {
                    -- No opaque floating window
                    winblend = 0,
                },
            },
        },
    }
}
