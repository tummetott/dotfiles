return {
    'folke/persistence.nvim',
    enabled = true,
    event = 'BufReadPre',
    config = true,
    init = function()
        require('tummetott.utils').which_key_register {
            ['<leader>s'] = { name = 'Session' }
        }
    end,
    keys = {
        {
            '<leader>sc',
            function()
                require'persistence'.load()
            end,
            desc = 'load current directory session',
        },
        {
            '<leader>sl',
            function()
                require'persistence'.load({ last = true })
            end,
            desc = 'load last session',
        },
        {
            '<leader>sq',
            function()
                require'persistence'.stop()
            end,
            desc = 'stop session recording',
        }
    }
}
