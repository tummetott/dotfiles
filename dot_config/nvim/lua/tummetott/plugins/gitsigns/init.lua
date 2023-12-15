return {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    event = 'LazyFile',
    opts = {
        signcolumn = true,
        signs = {
            add = {
                text = '│'
            },
            change = {
                text = '│'
            },
            untracked = {
                text = '│'
            }
        },
        preview_config = {
            border = 'rounded',
        },
        -- Untracked files are not shown by gitsigns. You need to manually add a
        -- file with 'git add' before gitsigns works
        attach_to_untracked = false,
        on_attach = function(bufnr)
            require('tummetott.plugins.gitsigns.keymaps').setup(bufnr)
        end,
        trouble = true,
    }
}
