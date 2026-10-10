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
            { '<leader>g', mode = { 'n', 'x' }, group = 'Git' },
        }
    end,
    keys = {
        {
            ']h',
            function() require 'gitsigns'.nav_hunk('next') end,
            desc = 'Next unstaged hunk',
        },
        {
            '[h',
            function() require 'gitsigns'.nav_hunk('prev') end,
            desc = 'Previous unstaged hunk',
        },
        {
            ']H',
            ---@diagnostic disable-next-line: missing-fields
            function() require 'gitsigns'.nav_hunk('next', { target = 'all' }) end,
            desc = 'Next hunk',
        },
        {
            '[H',
            ---@diagnostic disable-next-line: missing-fields
            function() require 'gitsigns'.nav_hunk('prev', { target = 'all' }) end,
            desc = 'Previous hunk',
        },
        {
            '<Leader>gs',
            function() require 'gitsigns'.stage_hunk() end,
            desc = 'Stage/Unstage hunk',
        },
        {
            '<Leader>gS',
            function() require 'gitsigns'.stage_buffer() end,
            desc = 'Stage buffer'
        },
        {
            '<Leader>gr',
            function() require 'gitsigns'.reset_hunk() end,
            desc = 'Reset hunk'
        },
        {
            '<Leader>gR',
            function() require 'gitsigns'.reset_buffer() end,
            desc = 'Reset buffer'
        },
        {
            '<Leader>gh',
            function() require 'gitsigns'.preview_hunk_inline() end,
            desc = 'Preview hunk'
        },
        {
            '<Leader>gb',
            function() require 'gitsigns'.blame_line() end,
            desc = 'Blame current line'
        },
        {
            '<Leader><space>b',
            function()
                local enabled = require 'gitsigns'.toggle_current_line_blame()
                require 'tummetott.utils'.echo_toggle('Line blame', enabled)
            end,
            desc = 'Line blame'
        },
        {
            '<Leader>gs',
            ':Gitsigns stage_hunk<CR>',
            mode = 'v',
            desc = 'Stage selected',
        },
        {
            '<Leader>gr',
            ':Gitsigns reset_hunk<CR>',
            mode = 'v',
            desc = 'Reset selected',
        },
        {
            '<c-,>g',
            function()
                local enabled = require 'gitsigns'.toggle_signs()
                require 'tummetott.utils'.echo_toggle('Gitsigns', enabled)
            end,
            desc = 'Gitsigns'
        },
        {
            'ih',
            ':<C-u>Gitsigns select_hunk<CR>',
            mode = { 'o', 'x' },
            desc = 'inner hunk',
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
