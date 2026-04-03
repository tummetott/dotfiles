return {
    'RRethy/vim-illuminate',
    event = 'VeryLazy',
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
        -- ISSUE: https://github.com/folke/lazy.nvim/issues/2136
        {
            '<c-[>',
            function()
                local ok, result = pcall(function()
                    return require('pathnav').open({
                        jump = false,
                        highlight = true,
                    })
                end)
                if not ok or not result then
                    require("illuminate").visible_buf()
                end
            end,
            desc = 'Highlight reference',
        },
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
