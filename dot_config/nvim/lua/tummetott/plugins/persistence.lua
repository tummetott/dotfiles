return {
    'folke/persistence.nvim',
    enabled = true,
    event = 'BufReadPre',
    config = true,
    init = function()
        require('which-key').add {
            { '<leader>p', group = 'Persist' },
        }
    end,
    keys = {
        {
            '<leader>pc',
            function()
                require'persistence'.load()
            end,
            desc = 'Load current session',
        },
        {
            '<leader>pl',
            function()
                require'persistence'.load({ last = true })
            end,
            desc = 'Load last session',
        },
        {
            '<leader>pq',
            function()
                require'persistence'.stop()
            end,
            desc = 'Stop session recording',
        },
        {
            '<leader>ps',
            function()
                require("persistence").select()
            end,
            desc = 'Load selected session',
        }
    }
}
