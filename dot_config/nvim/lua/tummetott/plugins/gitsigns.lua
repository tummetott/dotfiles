return {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    event = 'LazyFile',
    opts = {
        signcolumn = true,
        signs = {
            add = { text = '│' },
            change = { text = '│' },
            untracked = { text = '│' },
        },
        signs_staged = {
            add          = { text = '│' },
            change       = { text = '│' },
        },
        -- Show separate gutter signs for changes that have been git-staged
        -- (index vs HEAD)
        signs_staged_enable = false,
        preview_config = {
            border = 'rounded',
        },
        -- Untracked files are not shown by gitsigns. You need to manually add a
        -- file with 'git add' before gitsigns works
        attach_to_untracked = false,
        trouble = true,
    },
    init = function()
        require('which-key').add {
            { "<Leader>g", group = "Gitsigns" }
        }
    end,
    keys = {
        {
            ']h',
            function()
               vim.schedule(function() require 'gitsigns'.next_hunk() end)
                return '<Ignore>'
            end,
            desc = 'Go to next hunk',
            expr = true,
        },
        {
            '[h',
            function()
                vim.schedule(function() require 'gitsigns'.prev_hunk() end)
                return '<Ignore>'
            end,
            desc = 'Go to previous hunk',
            expr = true,
        },
        {
            '<Leader>gs',
            function() require 'gitsigns'.stage_hunk() end,
            desc = 'Stage hunk',
        },
        {
            '<Leader>gS',
            function() require 'gitsigns'.stage_buffer() end,
            desc = 'Stage buffer'
        },
        {
            '<Leader>gu',
            function() require 'gitsigns'.undo_stage_hunk() end,
            desc = 'Undo stage hunk'
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
            '<Leader>gp',
            function() require 'gitsigns'.preview_hunk() end,
            desc = 'Preview hunk'
        },
        {
            '<Leader>gb',
            function() require 'gitsigns'.blame_line() end,
            desc = 'Blame current line'
        },
        {
            '<Leader>gl',
            function() require 'gitsigns'.toggle_current_line_blame() end,
            desc = 'Toggle current line blame'
        },
        {
            '<Leader>gv',
            function() require 'gitsigns'.toggle_deleted() end,
            desc = 'Toggle virtual text diff'
        },
        {
            '<Leader>gs',
            ':Gitsigns stage_hunk<CR>',
            mode = 'v',
            desc = 'Stage selected',
        },
        {
            '<Leader>gr',
            '<Cmd>Gitsigns reset_hunk<CR>',
            mode = 'v',
            desc = 'Reset selected',
        },
        {
            'yog',
            function() require 'gitsigns'.toggle_signs() end,
            desc = 'Toggle gitsigns'
        },
        {
            'ih',
            ':<C-u>Gitsigns select_hunk<CR>',
            mode = { 'o', 'x' },
            desc = 'Inner hunk',
        }
    },
    highlights = {
        GitSignsAdd = { fg = 'green' },
        GitSignsDelete = { fg = 'red' },
        GitSignsChange = { fg = 'blue' },
        GitSignsUntracked = { fg = 'dark_grey' },
    }
}
