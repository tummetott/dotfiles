M = {}

table.insert(M, {
    'tummetott/unimpaired.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        keymaps = {
            cprevious = false,
            cnext = false,
            cfirst = false,
            clast = false,
        }
    },
    init = function()
        require('tummetott.utils').which_key_register {
            ['yo'] = { name = 'Toggle option' },
        }
    end,
})

table.insert(M, {
    'tpope/vim-unimpaired',
    enabled = false,
    dependencies = 'tpope/vim-repeat',
})

return M
