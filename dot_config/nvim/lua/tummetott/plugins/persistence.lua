return {
    'folke/persistence.nvim',
    enabled = true,
    event = 'BufReadPre',
    config = true,
    init = function()
        require('which-key').add {
            { "<leader>s", group = "Session" },
        }
    end,
    keys = {
        {
            '<leader>sc',
            function()
                require'persistence'.load()
            end,
            desc = 'Load current directory session',
        },
        {
            '<leader>sl',
            function()
                require'persistence'.load({ last = true })
            end,
            desc = 'Load last session',
        },
        {
            '<leader>sq',
            function()
                require'persistence'.stop()
            end,
            desc = 'Stop session recording',
        }
    }
}
