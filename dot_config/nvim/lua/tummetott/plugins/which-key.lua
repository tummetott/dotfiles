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
        -- Auto triggers skip insert mode. Only trigger in insert mode for
        -- explicit prefixes.
        triggers = {
            { '<auto>', mode = 'nxso' },
            { '<c-,>', mode = 'i' },
        },
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
            },
            presets = {
                operators = false,
                motions = false,
                text_objects = false,
                windows = false,
                nav = false,
                z = false,
                g = false,
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
            group = '+',
            ellipsis = vim.g.nerdfonts and '…' or '...',
            -- Only mappings with an explicit icon, such as snacks toggles,
            -- show one. Icons derived from descriptions are off.
            rules = false,
        },
        spec = {
            { '&', desc = 'Repeat substitute on current line' },
            { '@', desc = 'Execute macro' },
            { '@', mode = 'x', desc = 'Execute linewise macro' },
            { '!', mode = { 'n', 'x' }, desc = 'Run program' },

            { 'gU', mode = { 'n', 'x' }, desc = 'Uppercase' },
            { 'gu', mode = { 'n', 'x' }, desc = 'Lowercase' },
            { 'in', mode = { 'o', 'x' }, desc = 'inner treesitter node' },
            { 'an', mode = { 'o', 'x' }, desc = 'outer treesitter node' },
            { 'it', mode = { 'o', 'x' }, desc = 'inner tag block' },
            { 'at', mode = { 'o', 'x' }, desc = 'outer tag block' },

            { '<c-w>', mode = { 'n', 'x' }, group = 'window' },
            { '<c-w>=', mode = { 'n', 'x' }, desc = 'Equally high and wide' },
            { '<c-w>T', mode = { 'n', 'x' }, desc = 'Break out into a new tab' },
            { '<c-w>_', mode = { 'n', 'x' }, desc = 'Max out the height' },
            { '<c-w>o', mode = { 'n', 'x' }, desc = 'Close all other windows' },
            { '<c-w>x', mode = { 'n', 'x' }, desc = 'Swap current with next' },
            { '<c-w>|', mode = { 'n', 'x' }, desc = 'Max out the width' },
            { '<c-w>H', mode = { 'n', 'x' }, desc = 'Move window to far left' },
            { '<c-w>J', mode = { 'n', 'x' }, desc = 'Move window to far bottom' },
            { '<c-w>K', mode = { 'n', 'x' }, desc = 'Move window to far top' },
            { '<c-w>L', mode = { 'n', 'x' }, desc = 'Move window to far right' },

            { 'z<CR>', desc = 'Top this line' },
            { 'z=', desc = 'Spelling suggestions' },
            { 'zH', desc = 'Half screen to the left' },
            { 'zL', desc = 'Half screen to the right' },
            { 'zb', desc = 'Bottom this line' },
            { 'ze', desc = 'Right this line' },
            { 'zg', desc = 'Add word to spell list' },
            { 'zi', desc = 'Toggle folding' },
            { 'zs', desc = 'Left this line' },
            { 'zt', desc = 'Top this line' },
            { 'zz', desc = 'Center this line' },
            { 'zj', desc = 'Go to next fold' },
            { 'zk', desc = 'Go to previous fold' },

            { 'H', desc = 'Top line of window' },
            { 'L', desc = 'Last line of window' },
            { 'M', desc = 'Middle line of window' },
            { '[s', desc = 'Previous misspelled word' },
            { ']s', desc = 'Next misspelled word' },
            { ']a', desc = 'Next file in arglist' },
            { '[a', desc = 'Previous file in arglist' },
            { ']b', desc = 'Next buffer' },
            { '[b', desc = 'Previous buffer' },
            { ']l', desc = 'Next loclist entry' },
            { '[l', desc = 'Previous loclist entry' },

            -- FIX: https://github.com/folke/which-key.nvim/issues/934
            -- <C-i> and <tab> are not distinguished by which-key
            { '<C-i>', hidden = true },

            { '<C-h>', mode = { 'n', 'x' }, hidden = true },
            { '<C-j>', mode = { 'n', 'x' }, hidden = true },
            { '<C-k>', mode = { 'n', 'x' }, hidden = true },
            { '<C-l>', mode = { 'n', 'x' }, hidden = true },
            { '<C-a>', mode = 'i', hidden = true },
            { '<C-b>', mode = 'i', hidden = true },
            { '<C-c>', mode = 'i', hidden = true },
            { '<C-e>', mode = 'i', hidden = true },
            { '<C-f>', mode = 'i', hidden = true },
            { '<C-k>', mode = 'i', hidden = true },
            { '<C-u>', mode = 'i', hidden = true },
            { '<C-w>', mode = 'i', hidden = true },
            { '<M-Left>', mode = 'i', hidden = true },
            { '<M-Right>', mode = 'i', hidden = true },

            { 'g;', desc = 'Previous position in change list' },
            { 'g,', desc = 'Next position in change list' },
            { 'gn', desc = 'Search forwards and select' },
            { 'gN', desc = 'Search backwards and select' },
            { 'gT', desc = 'Go to previous tab page' },
            { 'gx', desc = 'Open file with system app' },
            { 'gi', desc = 'Go to last insert' },
            { 'gv', desc = 'Last visual selection' },

            { 'gr', group = 'LSP' },
            { 'gra', desc = 'Code actions' },
            { 'grn', desc = 'Rename' },
            { 'gri', desc = 'Goto implementation' },
            { 'grt', desc = 'Goto type definition' },

            { '<leader>o', group = 'Open' },
            { '<c-,>', mode = { 'n', 'i' }, group = 'Toggle' },
        },
        show_help = true,
        show_keys = true,
    },
    highlights = {
        WhichKeyDesc = { fg = 'bright_blue' },
        WhichKeyGroup = { fg = 'purple' },
    }
}
