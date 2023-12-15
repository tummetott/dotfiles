return {
    'danymat/neogen',
    enabled = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    init = function()
        require('tummetott.utils').which_key_register {
            ['<leader>a'] = { name = 'Annotation' }
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
            desc = 'function annotaton',
        },
        {
            '<leader>ac',
            function()
                require('neogen').generate({ type = 'class' })
            end,
            desc = 'class annotaton',
        },
        {
            '<leader>at',
            function()
                require('neogen').generate({ type = 'type' })
            end,
            desc = 'type annotaton',
        },
        {
            '<leader>ai',
            function()
                require('neogen').generate({ type = 'file' })
            end,
            desc = 'file annotaton',
        },
    }
}
