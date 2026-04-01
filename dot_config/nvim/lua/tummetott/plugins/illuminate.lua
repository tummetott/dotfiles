-- TODO: If I keep this plugin, remove the autocmd in lspconfig which resets the
-- manual highlighing
return {
    'RRethy/vim-illuminate',
    event = 'LazyFile',
    enabled = true,
    opts = {
        providers = {
            'lsp',
            -- ISSUE: https://github.com/RRethy/vim-illuminate/issues/247
            'treesitter',
            'regex',
        },
        delay = 0,
        -- Also highlight token under cursor
        under_cursor = true,
        large_file_cutoff = 1000,
        large_file_overrides = {
            providers = { 'lsp' },
        },
    },
    config = function(_, opts)
        require('illuminate').configure(opts)
        -- Disable at startup
        require('illuminate').invisible_buf()
        -- Disable once cursor moved
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
            callback = function()
                require('illuminate').invisible_buf()
            end,
        })
    end,
    keys = {
        {
            ']]',
            function()
                require('illuminate').goto_next_reference(true)
                -- Enable when jumping
                vim.schedule(function()
                    require("illuminate").visible_buf()
                end)
            end,
            desc = 'Next reference under cursor',
        },
        {
            '[[',
            function()
                require('illuminate').goto_prev_reference(true)
                -- Enable when jumping
                vim.schedule(function()
                    require("illuminate").visible_buf()
                end)
            end,
            desc = 'Previous reference under cursor',
        }
    },
    highlights = {
        IlluminatedWordText = { link = 'LspReferenceText' },
        IlluminatedWordRead = { link = 'IlluminatedWordText' },
        IlluminatedWordWrite = { link = 'IlluminatedWordText' },
    }
}
