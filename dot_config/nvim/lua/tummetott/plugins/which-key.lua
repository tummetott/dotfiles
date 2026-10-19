return {
    'folke/which-key.nvim',
    enabled = true,
    -- No lazy loading! Many plugins add keymap descriptions during startup.
    -- Caching them to load at the 'VeryLazy' event adds unnecessary complexity
    -- for only a 0.6ms startup improvement.
    lazy = false,
    opts = {
        preset = 'classic',
        -- A mapping without a description has nothing to show, so it is left
        -- out rather than listed blank.
        filter = function(mapping)
            if mapping.hidden then
                return true
            end
            return mapping.desc ~= nil and mapping.desc ~= ''
        end,
        triggers = {
            { '<leader>', mode = 'nx' },
            { '<c-,>', mode = 'ni' },
            { 'gr', mode = 'n' },
        },
        plugins = {
            marks = true,
            registers = true,
            spelling = { enabled = false },
            presets = false,
        },
        win = {
            border = 'rounded',
            padding = { 1, 1 },
        },
        keys = {
            scroll_down = '<Down>',
            scroll_up = '<Up>',
        },
        icons = {
            breadcrumb = vim.g.nerdfonts and '»' or '>>',
            separator = vim.g.nerdfonts and '➜' or '->',
            group = '',
            ellipsis = vim.g.nerdfonts and '…' or '...',
            -- Only mappings with an explicit icon, such as snacks toggles,
            -- show one. Icons derived from descriptions are off.
            rules = false,
        },
        show_help = true,
        show_keys = true,
        spec = {
            -- <C-i> and <tab> are not distinguished by which-key
            -- ISSUE: https://github.com/folke/which-key.nvim/issues/934

            { '&', desc = 'Repeat Substitute on Current Line' },
            { '@', desc = 'Execute Macro' },
            { '@', mode = 'x', desc = 'Execute Linewise Macro' },
            { 'in', mode = { 'o', 'x' }, desc = 'Inner Treesitter Node' },
            { 'an', mode = { 'o', 'x' }, desc = 'Outer Treesitter Node' },
            { 'zj', desc = 'Go to Next Fold' },
            { 'zk', desc = 'Go to Previous Fold' },
            { ']a', desc = 'Next File in Arglist' },
            { '[a', desc = 'Previous File in Arglist' },
            { ']b', desc = 'Next Buffer' },
            { '[b', desc = 'Previous Buffer' },
            { ']l', desc = 'Next Loclist Entry' },
            { '[l', desc = 'Previous Loclist Entry' },
            { 'gra', desc = 'Code Actions' },
            { 'grn', desc = 'Rename' },
            { 'gri', desc = 'Goto Implementation' },
            { 'grt', desc = 'Goto Type Definition' },
            { 'grx', desc = 'Run Codelens' },
            {
                '<c-w>',
                mode = { 'n', 'x' },
                group = 'window',
                icon = vim.g.nerdfonts and '' or nil,
            },
            {
                '<leader>r',
                desc = 'Restart Neovim',
                icon = vim.g.nerdfonts and '󰜉' or nil,
            },
            {
                '<leader>o',
                mode = { 'n', 'x' },
                group = 'Open',
                icon = vim.g.nerdfonts and '󰏌' or nil,
            },
            {
                '<leader>y',
                mode = { 'n', 'x' },
                group = 'Yank',
                icon = vim.g.nerdfonts and '' or nil,
            },
            {
                '<c-,>',
                mode = { 'n', 'i' },
                group = 'Toggle',
                icon = vim.g.nerdfonts and '' or nil,
            },
            {
                'gr',
                group = 'LSP',
                icon = vim.g.nerdfonts and '' or nil,
            },
        },
    },
    keys = {
        {
            'g?',
            function() require('which-key').show() end,
            mode = { 'n', 'x' },
            desc = 'Show Keymaps',
        },
        {
            '<c-g>?',
            function() require('which-key').show() end,
            mode = 'i',
            desc = 'Show Keymaps',
        },
    },
    highlights = {
        WhichKeyDesc = { fg = 'bright_blue' },
        WhichKeyGroup = { fg = 'purple' },
        WhichKeyIcon = { fg = 'orange' },
    }
}
