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
            spelling = {
                enabled = true,
            },
            presets = {
                operators = true,
                motions = false,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            }
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

            { '&', desc = 'Repeat substitute on current line' },
            { '@', desc = 'Execute macro' },
            { '@', mode = 'x', desc = 'Execute linewise macro' },
            { 'in', mode = { 'o', 'x' }, desc = 'inner treesitter node' },
            { 'an', mode = { 'o', 'x' }, desc = 'outer treesitter node' },
            { 'zj', desc = 'Go to next fold' },
            { 'zk', desc = 'Go to previous fold' },
            { ']a', desc = 'Next file in arglist' },
            { '[a', desc = 'Previous file in arglist' },
            { ']b', desc = 'Next buffer' },
            { '[b', desc = 'Previous buffer' },
            { ']l', desc = 'Next loclist entry' },
            { '[l', desc = 'Previous loclist entry' },
            { 'gra', desc = 'Code actions' },
            { 'grn', desc = 'Rename' },
            { 'gri', desc = 'Goto implementation' },
            { 'grt', desc = 'Goto type definition' },
            { 'grx', desc = 'Run codelens' },
            {
                '<c-w>',
                mode = { 'n', 'x' },
                group = 'window',
                icon = vim.g.nerdfonts and '' or nil,
            },
            {
                '<leader>r',
                desc = 'Restart neovim',
                icon = vim.g.nerdfonts and '󰜉' or nil,
            },
            {
                '<leader>o',
                group = 'Open',
                icon = vim.g.nerdfonts and '󰏌' or nil,
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
    highlights = {
        WhichKeyDesc = { fg = 'bright_blue' },
        WhichKeyGroup = { fg = 'purple' },
        WhichKeyIcon = { fg = 'orange' },
    }
}
