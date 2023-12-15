-- Automated session management
return {
    'olimorris/persisted.nvim',
    enabled = false,
    event = 'BufReadPre',
    init = function()
        require('tummetott.utils').which_key_register {
            ['<leader>s'] = { name = 'Session' }
        }
    end,
    opts = {
        use_git_branch = true,
        autosave = true,
        autoload = false,
        should_autosave = function()
            if vim.bo.filetype == 'alpha' then return false end
            return true
        end,
        save_dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')
    },
    -- TODO: add telescope extension
    -- require('telescope').extensions.persisted.persisted()
    keys = {
        {
            '<leader>sc',
            '<cmd>SessionLoad<cr>',
            desc = 'load current directory session',
        },
        {
            '<leader>sl',
            '<cmd>SessionLoadLast<cr>',
            desc = 'load last session',
        },
        {
            '<leader>st',
            '<cmd>SessionToggle<cr>',
            desc = 'toggle session recording',
        },
        {
            '<leader>ss',
            '<cmd>SessionSave<cr>',
            desc = 'save current session',
        },
    }
}
