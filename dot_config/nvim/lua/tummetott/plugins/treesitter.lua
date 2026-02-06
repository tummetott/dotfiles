local M = {}

-- TODO: integrate incremental selection once merged
-- See: https://github.com/neovim/neovim/pull/36993
-- Use <c-n> <c-p> in visual mode

-- TODO: Consider adding treesitter-locals once plugin is stable
-- https://github.com/nvim-treesitter/nvim-treesitter-locals

table.insert(M, {
    'nvim-treesitter/nvim-treesitter',
    -- This plugin does not support lazy loading
    lazy = false,
    build = ':TSUpdate',
    init = function()
        require('which-key').add {
            { '[s', group = 'Swap with previous' },
            { ']s', group = 'Swap with next' },
        }
    end,
    -- This plugin does not necessarily need a call to setup
    config = function()
        local treesitter = require('nvim-treesitter')
        -- NOTE: tree-sitter-cli must be installed globally in order to install
        -- parsers
        treesitter.install({
            'bash',
            'c',
            'cpp',
            'dockerfile',
            'html',
            'java',
            'json',
            'lua',
            'markdown',
            'nu',
            'python',
            'rust',
            'toml',
            'yaml',
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterAttach", { clear = true }),
            desc = 'Auto enable treesitter for supported filetype',
            callback = function(ctx)
                local ft = ctx.match
                if ft == "bigfile" then
                    return
                end

                -- Filetype and parser name are not always the same.
                -- Example: filetype 'tex' uses the 'latex' parser.
                local parser_name = vim.treesitter.language.get_lang(ft)

                local parser = vim.treesitter.get_parser(ctx.buf, parser_name, { error = false })
                if not parser_name or not parser then return end

                -- Enable treesitter syntax highlighting
                if vim.treesitter.query.get(parser_name, "highlights") then
                    vim.treesitter.start(ctx.buf, parser_name)
                end

                -- Enable treesitter folding
                if vim.treesitter.query.get(parser_name, "folds") then
                    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo[0][0].foldmethod = 'expr'
                end
            end,
        })
    end,
})

table.insert(M, {
    'nvim-treesitter/nvim-treesitter-textobjects',
    enabled = true,
    branch = 'main',
    init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
        vim.g.no_plugin_maps = true
    end,
    opts = {
        -- Automatically jump forward to textobj
        lookahead = true,
        -- Select which visual mode is used for each treesitter textobject.
        -- Default is 'v'.
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V',  -- linewise
            ['@class.outer'] = 'V',     -- linewise
        },
        move = {
            -- whether to set jumps in the jumplist
            set_jumps = true,
        },
        include_surrounding_whitespace = false,
    },
    keys = {
        -- Select keymaps
        {
            'am',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@function.outer', 'textobjects')
            end,
            desc = 'outer method',
            mode = { 'x', 'o' },
        },
        {
            'im',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@function.inner', 'textobjects')
            end,
            desc = 'inner method',
            mode = { 'x', 'o' },
        },
        {
            'ac',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@class.outer', 'textobjects')
            end,
            desc = 'outer class',
            mode = { 'x', 'o' },
        },
        {
            'ic',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@class.inner', 'textobjects')
            end,
            desc = 'inner class',
            mode = { 'x', 'o' },
        },
        {
            'aa',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@parameter.outer', 'textobjects')
            end,
            desc = 'outer argument',
            mode = { 'x', 'o' },
        },
        {
            'ia',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@parameter.inner', 'textobjects')
            end,
            desc = 'inner argument',
            mode = { 'x', 'o' },
        },
        {
            'ao',
            function()
                require('nvim-treesitter-textobjects.select')
                    .select_textobject('@comment.outer', 'textobjects')
            end,
            desc = 'outer comment',
            mode = { 'x', 'o' },
        },
        -- Jump keymaps
        {
            ']m',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_next_start('@function.outer', 'textobjects')
            end,
            desc = 'next function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[m',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_previous_start('@function.outer', 'textobjects')
            end,
            desc = 'previous function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']]',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_next_start('@class.outer', 'textobjects')
            end,
            desc = 'next class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[[',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_previous_start('@class.outer', 'textobjects')
            end,
            desc = 'previous class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']M',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_next_end('@function.outer', 'textobjects')
            end,
            desc = 'next function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[M',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_previous_end('@function.outer', 'textobjects')
            end,
            desc = 'previous function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']o',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_next_start('@local.scope', 'locals')
            end,
            desc = 'next scope start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[o',
            function()
                require('nvim-treesitter-textobjects.move')
                .goto_previous_start('@local.scope', 'locals')
            end,
            desc = 'previous scope start',
            mode = { 'n', 'x', 'o' },
        },
        -- Swap keymaps
        {
            ']sa',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_next('@parameter.inner')
            end,
            desc = 'swap with next parameter',
            mode = 'n',
        },
        {
            '[sa',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_previous('@parameter.inner')
            end,
            desc = 'swap with previous parameter',
            mode = 'n',
        },
        {
            ']sf',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_next('@function.outer')
            end,
            desc = 'swap with next function',
            mode = 'n',
        },
        {
            '[sf',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_previous('@function.outer')
            end,
            desc = 'swap with previous function',
            mode = 'n',
        },
        {
            ']sc',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_next('@class.outer')
            end,
            desc = 'swap with next class',
            mode = 'n',
        },
        {
            '[sc',
            function()
                require('nvim-treesitter-textobjects.swap')
                .swap_previous('@class.outer')
            end,
            desc = 'swap with previous class',
            mode = 'n',
        },
    },
})

table.insert(M, {
    'RRethy/nvim-treesitter-endwise',
    enabled = true,
    -- Lazy loading does not work for some reason
    lazy = false,
})

return M
