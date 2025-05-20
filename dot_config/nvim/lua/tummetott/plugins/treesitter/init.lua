local M = {}

table.insert(M, {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    build = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = { 'nushell/tree-sitter-nu' },
    opts = {
        -- The following parsers are pre-installed with nvim:
        -- c, lua, markdown, vim, vimdoc
        ensure_installed = {
            'bash',
            'cpp',
            'dockerfile',
            'html',
            'java',
            'json',
            'nu',
            'python',
            'rust',
            'toml',
            'yaml',
        },
        highlight = {
            enable = true,
            disable = function()
                return vim.bo.filetype == 'bigfile'
            end,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                -- TODO: Keymap descriptions are not configurable. Treesitter
                -- v1.0 will remove this syntax soon.
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
    -- TODO: nvim 0.10 don't let me lazy load treesitter
    lazy = false,
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
                    ['af'] = { query = '@function.outer', desc = 'Outer function' },
                    ['if'] = { query = '@function.inner', desc = 'Inner function' },
                    ['ac'] = { query = '@class.outer', desc = 'Outer class' },
                    ['ic'] = { query = '@class.inner', desc = 'Inner class' },
                    ['aa'] = { query = '@parameter.outer', desc = 'Outer parameter' },
                    ['ia'] = { query = '@parameter.inner', desc = 'Inner parameter' },
                    ['ao'] = { query = '@comment.outer', desc = 'Outer comment' },
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
                    [']m'] = { query = '@function.outer', desc = 'Next method start' },
                },
                goto_next_end = {
                    [']M'] = { query = '@function.outer', desc = 'Next method end' },
                },
                goto_previous_start = {
                    ['[m'] = { query = '@function.outer', desc = 'Previous method start' },
                },
                goto_previous_end = {
                    ['[M'] = { query = '@function.outer', desc = 'Previous method end' },
                },
            },
            swap = {
                enable = true,
                -- These keymaps override the default Vim keybindings for
                -- moving to next/previous spelling errors.
                swap_next = {
                    [']sa'] = { query = '@parameter.inner', desc = 'Parameter' },
                    [']sf'] = { query = '@function.outer', desc = 'Function' },
                    [']sc'] = { query = '@class.outer', desc = 'Class' },
                },
                swap_previous = {
                    ['[sa'] = { query = '@parameter.inner', desc = 'Parameter' },
                    ['[sf'] = { query = '@function.outer', desc = 'Function' },
                    ['[sc'] = { query = '@class.outer', desc = 'Class' },
                },
            },
        },
    },
    main = 'nvim-treesitter.configs',
    keys = {
        { 'af',  mode = { 'o', 'v' }, desc = 'Outer function' },
        { 'if',  mode = { 'o', 'v' }, desc = 'Inner function' },
        { 'ac',  mode = { 'o', 'v' }, desc = 'Outer class' },
        { 'ic',  mode = { 'o', 'v' }, desc = 'Inner class' },
        { 'aa',  mode = { 'o', 'v' }, desc = 'Outer parameter' },
        { 'ia',  mode = { 'o', 'v' }, desc = 'Inner parameter' },
        { 'ao',  mode = { 'o', 'v' }, desc = 'Outer comment' },
        { ']m',  mode = 'n',          desc = 'Next method start' },
        { ']M',  mode = 'n',          desc = 'Next method end' },
        { '[m',  mode = 'n',          desc = 'Previous method start' },
        { '[M',  mode = 'n',          desc = 'Previous method end' },
        { ']sa', mode = 'n',          desc = 'Parameter' },
        { ']sf', mode = 'n',          desc = 'Function' },
        { ']sc', mode = 'n',          desc = 'Class' },
        { '[sa', mode = 'n',          desc = 'Parameter' },
        { '[sf', mode = 'n',          desc = 'Function' },
        { '[sc', mode = 'n',          desc = 'Class' },
    },
    init = function()
        require('which-key').add {
            { '[s', group = 'Swap with previous' },
            { ']s', group = 'Swap with next' },
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
                -- Only for visual mode
                ['<CR>'] = {
                    'textsubjects-smart',
                    desc = 'Smart selection',
                },
            },
        },
    },
    main = 'nvim-treesitter.configs',
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
