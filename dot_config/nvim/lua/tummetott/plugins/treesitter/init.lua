local M = {}

table.insert(M, {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    build = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    opts = {
        ensure_installed = {
            'bash',
            'c',
            'cpp',
            'dockerfile',
            'html',
            'java',
            'json',
            'lua',
            'nu',
            'python',
            'rust',
            'vim',
            'vimdoc',
            'yaml',
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<cr>',
                node_incremental = '<C-n>',
                node_decremental = '<C-p>',
            }
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        require('tummetott.plugins.treesitter.query-overwrites')
    end,
    cmd = {
        'TSInstall',
        'TSInstallSync',
        'TSInstallInfo',
        'TSUpdate',
        'TSUpdateSync',
        'TSUninstall',
        'TSBufEnable',
        'TSBufDisable',
        'TSBufToggle',
        'TSEnable',
        'TSDisable',
        'TSToggle',
        'TSModuleInfo',
        'TSEditQuery',
        'TSEditQueryUserAfter',
    },
    event = { 'LazyFile', 'VeryLazy' },
})

table.insert(M, {
    'nvim-treesitter/nvim-treesitter-textobjects',
    enabled = true,
    opts = {
        textobjects = {
            select = {
                enable = true,
                -- If not inside the textobject, jump to the next one
                lookahead = true,
                keymaps = {
                    ['af'] = { query = '@function.outer', desc = 'outer function' },
                    ['if'] = { query = '@function.inner', desc = 'inner function' },
                    ['ac'] = { query = '@class.outer', desc = 'outer class' },
                    ['ic'] = { query = '@class.inner', desc = 'inner class' },
                    ['aa'] = { query = '@parameter.outer', desc = 'outer parameter' },
                    ['ia'] = { query = '@parameter.inner', desc = 'inner parameter' },
                    ['ao'] = { query = '@comment.outer', desc = 'outer comment' },
                },
                -- When selecting outer classes, use linewise visual mode
                selection_modes = {
                    ['@class.outer'] = 'V',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = { query = '@function.outer', desc = 'next method start' },
                },
                goto_next_end = {
                    [']M'] = { query = '@function.outer', desc = 'next method end' },
                },
                goto_previous_start = {
                    ['[m'] = { query = '@function.outer', desc = 'previous method start' },
                },
                goto_previous_end = {
                    ['[M'] = { query = '@function.outer', desc = 'previous method end' },
                },
            },
            swap = {
                enable = true,
                -- These keymaps override the default Vim keybindings for
                -- moving to next/previous spelling errors.
                swap_next = {
                    [']sa'] = { query = '@parameter.inner', desc = 'parameter' },
                    [']sf'] = { query = '@function.outer', desc = 'function' },
                    [']sc'] = { query = '@class.outer', desc = 'class' },
                },
                swap_previous = {
                    ['[sa'] = { query = '@parameter.inner', desc = 'parameter' },
                    ['[sf'] = { query = '@function.outer', desc = 'function' },
                    ['[sc'] = { query = '@class.outer', desc = 'class' },
                },
            },
        },
    },
    main = 'nvim-treesitter.configs',
    keys = {
        { 'af',  mode = { 'o', 'v' }, desc = 'outer function' },
        { 'if',  mode = { 'o', 'v' }, desc = 'inner function' },
        { 'ac',  mode = { 'o', 'v' }, desc = 'outer class' },
        { 'ic',  mode = { 'o', 'v' }, desc = 'inner class' },
        { 'aa',  mode = { 'o', 'v' }, desc = 'outer parameter' },
        { 'ia',  mode = { 'o', 'v' }, desc = 'inner parameter' },
        { 'ao',  mode = { 'o', 'v' }, desc = 'outer comment' },
        { ']m',  mode = 'n',          desc = 'next method start' },
        { ']M',  mode = 'n',          desc = 'next method end' },
        { '[m',  mode = 'n',          desc = 'previous method start' },
        { '[M',  mode = 'n',          desc = 'previous method end' },
        { ']sa', mode = 'n',          desc = 'parameter' },
        { ']sf', mode = 'n',          desc = 'function' },
        { ']sc', mode = 'n',          desc = 'class' },
        { '[sa', mode = 'n',          desc = 'parameter' },
        { '[sf', mode = 'n',          desc = 'function' },
        { '[sc', mode = 'n',          desc = 'class' },
    },
    init = function()
        require('tummetott.utils').which_key_register {
            ['[s'] = { name = 'Swap with previous' },
            [']s'] = { name = 'Swap with next' },
        }
    end,
})

table.insert(M, {
    'RRethy/nvim-treesitter-textsubjects',
    enabled = true,
    opts = {
        textsubjects = {
            enable = true,
            keymaps = {
                ['<CR>'] = {
                    'textsubjects-smart',
                    desc = 'Smart selection',
                },
            },
        },
    },
    main = 'nvim-treesitter.configs',
    -- ISSUE: visual mode mapping with <CR> is not shown in which-key
    -- https://github.com/folke/which-key.nvim/issues/540
    keys = {
        { '<cr>', mode = 'x', desc = 'Smart selection' }
    }
})

table.insert(M, {
    'RRethy/nvim-treesitter-endwise',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        endwise = { enable = true },
    },
    main = 'nvim-treesitter.configs',
})

return M
