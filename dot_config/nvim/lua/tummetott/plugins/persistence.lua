return {
    'folke/persistence.nvim',
    enabled = true,
    event = 'BufReadPre',
    config = true,
    init = function()
        require('which-key').add {
            {
                '<leader>p',
                group = 'Persist',
                icon = vim.g.nerdfonts and '󰆓' or nil,
            },
        }
    end,
    keys = {
        {
            '<leader>pc',
            function()
                require'persistence'.load()
            end,
            desc = 'Load Current Session',
        },
        {
            '<leader>pl',
            function()
                require'persistence'.load({ last = true })
            end,
            desc = 'Load Last Session',
        },
        {
            '<leader>pq',
            function()
                require'persistence'.stop()
            end,
            desc = 'Stop Session Recording',
        },
        {
            '<leader>ps',
            function()
                require("persistence").select()
            end,
            desc = 'Load Selected Session',
        }
    }
}
