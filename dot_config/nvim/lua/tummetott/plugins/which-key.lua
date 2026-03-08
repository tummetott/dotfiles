return {
    'folke/which-key.nvim',
    enabled = true,
    -- No lazy loading! Many plugins add keymap descriptions during startup.
    -- Caching them to load at the 'VeryLazy' event adds unnecessary complexity
    -- for only a 0.6ms startup improvement.
    lazy = false,
    opts = {
        preset = 'classic',
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
            scroll_down = "<Down>",
            scroll_up = "<Up>",
        },
        icons = {
            breadcrumb = vim.g.nerdfonts and '»' or '>>',
            separator = vim.g.nerdfonts and '➜' or '->',
            group = '+',
            ellipsis = vim.g.nerdfonts and '…' or '...',
            -- Disable icons on the rhs of mappings
            mappings = false,
        },
        -- Overwrite some keymap descriptions
        spec = {
            { '&', desc = 'Repeat substitute on current line' },
            { '%', mode = { 'n', 'x' }, desc = 'Jump to matching pair' },
            { 'ib', mode = { 'o', 'x' }, desc = 'inner ()' },
            { 'ab', mode = { 'o', 'x' }, desc = 'outer ()' },
            { 'i(', mode = { 'o', 'x' }, desc = 'inner ()' },
            { 'a(', mode = { 'o', 'x' }, desc = 'outer ()' },
            { 'i)', mode = { 'o', 'x' }, desc = 'inner ()' },
            { 'a)', mode = { 'o', 'x' }, desc = 'outer ()' },
            { 'iB', mode = { 'o', 'x' }, desc = 'inner {}' },
            { 'aB', mode = { 'o', 'x' }, desc = 'outer {}' },
            { 'i{', mode = { 'o', 'x' }, desc = 'inner {}' },
            { 'a{', mode = { 'o', 'x' }, desc = 'outer {}' },
            { 'i}', mode = { 'o', 'x' }, desc = 'inner {}' },
            { 'a}', mode = { 'o', 'x' }, desc = 'outer {}' },
            { 'aw', mode = { 'o', 'x' }, desc = 'outer word' },
            { 'aW', mode = { 'o', 'x' }, desc = 'outer WORD' },
            { 'i"', mode = { 'o', 'x' }, desc = 'inner ""' },
            { 'a"', mode = { 'o', 'x' }, desc = 'outer ""' },
            { "i'", mode = { 'o', 'x' }, desc = "inner ''" },
            { "a'", mode = { 'o', 'x' }, desc = "outer ''" },
            { 'i`', mode = { 'o', 'x' }, desc = 'inner ``' },
            { 'a`', mode = { 'o', 'x' }, desc = 'outer ``' },
            { '@', desc = 'Execute macro' },
            { '*', desc = 'Search forward for word under cursor' },
            { '#', desc = 'Search backward for word under cursor' },
            { '*', mode = 'x', desc = 'Search forward for current selection' },
            { '#', mode = 'x', desc = 'Search backward for current selection' },
            { '@', mode = 'x', desc = 'Execute linewise macro' },
            -- FIX: https://github.com/folke/which-key.nvim/issues/934
            -- <C-i> and <tab> are not distinguished by which-key
            { '<C-i>', desc = 'Newer position in jump list' },
            { '<C-o>', desc = 'Older position in jump list' },
            { 'zj', desc = 'Go to next fold' },
            { 'zk', desc = 'Go to previous fold' },
            { 'gQ', hidden = true },
            { '<leader>i', group = 'Indent' },
            { 'grr', desc = 'Goto references' },
            { 'gra', desc = 'Code actions' },
            { 'grn', desc = 'Rename' },
            { 'gri', desc = 'Goto implementation' },
            { 'grt', desc = 'Goto type definition' },
            { 'gr',  group = 'LSP' },
        },
        show_help = true,
        show_key = true,
    },
    highlights = {
        WhichKeyDesc = { fg = 'bright_blue' },
        WhichKeyGroup = { fg = 'purple' },
    }
}
