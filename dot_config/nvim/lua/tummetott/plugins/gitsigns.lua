return {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        signcolumn = true,
        signs = {
            add = { text = '│' },
            change = { text = '│' },
            untracked = { text = '│' },
        },
        signs_staged = {
            add          = { text = '╎' },
            change       = { text = '╎' },
            delete       = { text = '╎' },
        },
        -- Show separate gutter signs for changes that have been git-staged
        signs_staged_enable = true,
        preview_config = {
            border = 'rounded',
        },
        -- Untracked files are shown by gitsigns
        attach_to_untracked = true,
    },
    init = function()
        require('which-key').add {
            {
                '<leader>g',
                mode = { 'n', 'x' },
                group = 'Git',
                icon = vim.g.nerdfonts and '󰊢' or nil,
            },
        }
    end,
    config = function(_, opts)
        local gitsigns = require 'gitsigns'
        local config = require('gitsigns.config').config
        gitsigns.setup(opts)

        Snacks.toggle.new({
            name = 'gitsigns',
            get = function() return config.signcolumn end,
            set = gitsigns.toggle_signs,
        }):map('<c-,>g')

        Snacks.toggle.new({
            name = 'line blame',
            get = function() return config.current_line_blame end,
            set = gitsigns.toggle_current_line_blame,
        }):map('<c-,>b')
    end,
    keys = {
        {
            ']h',
            function() require 'gitsigns'.nav_hunk('next') end,
            desc = 'Next Unstaged Hunk',
        },
        {
            '[h',
            function() require 'gitsigns'.nav_hunk('prev') end,
            desc = 'Previous Unstaged Hunk',
        },
        {
            ']H',
            ---@diagnostic disable-next-line: missing-fields
            function() require 'gitsigns'.nav_hunk('next', { target = 'all' }) end,
            desc = 'Next Hunk',
        },
        {
            '[H',
            ---@diagnostic disable-next-line: missing-fields
            function() require 'gitsigns'.nav_hunk('prev', { target = 'all' }) end,
            desc = 'Previous Hunk',
        },
        {
            '<Leader>gs',
            function() require 'gitsigns'.stage_hunk() end,
            desc = 'Stage/Unstage Hunk',
        },
        {
            '<Leader>gS',
            function() require 'gitsigns'.stage_buffer() end,
            desc = 'Stage Buffer'
        },
        {
            '<Leader>gr',
            function() require 'gitsigns'.reset_hunk() end,
            desc = 'Reset Hunk'
        },
        {
            '<Leader>gR',
            function() require 'gitsigns'.reset_buffer() end,
            desc = 'Reset Buffer'
        },
        {
            '<Leader>gh',
            function() require 'gitsigns'.preview_hunk_inline() end,
            desc = 'Preview Hunk'
        },
        {
            '<Leader>gb',
            function() require 'gitsigns'.blame_line() end,
            desc = 'Blame Current Line'
        },
        {
            '<Leader>gs',
            ':Gitsigns stage_hunk<CR>',
            mode = 'v',
            desc = 'Stage Selected',
        },
        {
            '<Leader>gr',
            ':Gitsigns reset_hunk<CR>',
            mode = 'v',
            desc = 'Reset Selected',
        },
        {
            'ih',
            ':<C-u>Gitsigns select_hunk<CR>',
            mode = { 'o', 'x' },
            desc = 'Inner Hunk',
        }
    },
    highlights = {
        GitSignsAdd = { fg = 'green' },
        GitSignsDelete = { fg = 'red' },
        GitSignsChange = { fg = 'blue' },
        GitSignsUntracked = { fg = 'dark_gray' },
        -- Staged hunks recede through brightness
        GitSignsStagedAdd = { fg = { darken = 'green', amount = 0.5 } },
        GitSignsStagedChange = { fg = { darken = 'blue', amount = 0.5 } },
        GitSignsStagedDelete = { fg = { darken = 'red', amount = 0.5 } },
        GitSignsCurrentLineBlame = { fg = 'gray' },
    }
}
