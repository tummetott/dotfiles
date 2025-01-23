return {
    'danymat/neogen',
    enabled = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    init = function()
        require('which-key').add {
            { '<leader>a', group = 'Annotation' },
        }
    end,
    opts = {
        snippet_engine = 'luasnip',
    },
    cmd = 'Neogen',
    keys = {
        {
            '<leader>af',
            function()
                require('neogen').generate({ type = 'func' })
            end,
            desc = 'Function annotaton',
        },
        {
            '<leader>ac',
            function()
                require('neogen').generate({ type = 'class' })
            end,
            desc = 'Class annotaton',
        },
        {
            '<leader>at',
            function()
                require('neogen').generate({ type = 'type' })
            end,
            desc = 'Type annotaton',
        },
        {
            '<leader>ai',
            function()
                require('neogen').generate({ type = 'file' })
            end,
            desc = 'File annotaton',
        },
    }
}
