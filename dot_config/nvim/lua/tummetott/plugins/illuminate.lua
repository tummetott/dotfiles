-- TODO: If I keep this plugin, remove the autocmd in lspconfig which resets the
-- manual highlighing
return {
    'RRethy/vim-illuminate',
    event = 'LazyFile',
    enabled = false,
    opts = {
        delay = 100,
        under_cursor = true,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { 'lsp' },
        },
    },
    config = function(_, opts)
        require('illuminate').configure(opts)
    end,
    keys = {
        {
            ']]',
            function()
                require('illuminate').goto_next_reference(true)
            end,
            desc = 'Goto next reference',
        },
        {
            '[[',
            function()
                require('illuminate').goto_prev_reference(true)
            end,
            desc = 'Goto previous reference',

        }
    }
}
