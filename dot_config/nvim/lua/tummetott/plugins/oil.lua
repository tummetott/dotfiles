return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        columns = {
            'icon',
            'permissions',
        },
        use_default_keymaps = false,
        keymaps = {
            ['g?'] = 'actions.show_help',
            ['<CR>'] = 'actions.select',
            ['<C-c>'] = 'actions.close',
            ['<C-w>s'] = 'actions.select_split',
            ['<C-w>v'] = 'actions.select_vsplit',
            ['<bs>'] = 'actions.parent',
            ['_'] = 'actions.open_cwd',
            ['gs'] = 'actions.change_sort',
            ['gx'] = 'actions.open_external',
            ['g.'] = 'actions.toggle_hidden',
            -- [''] = 'actions.refresh',
            -- [''] = 'actions.cd',
        },
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, _)
                if vim.tbl_contains({
                    '..',
                    '.DS_Store',
                    '.git',
                }, name) then
                    return true
                end
                return false
            end,
        }
    },
    -- No lazy loading because the plugin hijacks netrw
}
