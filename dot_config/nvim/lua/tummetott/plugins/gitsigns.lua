return {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    event = 'LazyFile',
    opts = {
        signcolumn = true,
        signs = {
            add = {
                text = '│'
            },
            change = {
                text = '│'
            },
            untracked = {
                text = '│'
            }
        },
        preview_config = {
            border = vim.g.nerdfonts and 'rounded' or 'single',
        },
        -- Untracked files are not shown by gitsigns. You need to manually add a
        -- file with 'git add' before gitsigns works
        attach_to_untracked = false,
        trouble = true,
    },
    init = function()
        require('tummetott.utils').which_key_register {
            ['<Leader>g'] = { name = 'Gitsigns' }
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
            desc = 'stage hunk',
        },
        {
            '<Leader>gS',
            function() require 'gitsigns'.stage_buffer() end,
            desc = 'Stage buffer'
        },
        {
            '<Leader>gu',
            function() require 'gitsigns'.undo_stage_hunk() end,
            desc = 'undo stage hunk'
        },
        {
            '<Leader>gr',
            function() require 'gitsigns'.reset_hunk() end,
            desc = 'reset hunk'
        },
        {
            '<Leader>gR',
            function() require 'gitsigns'.reset_buffer() end,
            desc = 'reset buffer'
        },
        {
            '<Leader>gp',
            function() require 'gitsigns'.preview_hunk() end,
            desc = 'preview hunk'
        },
        {
            '<Leader>gb',
            function() require 'gitsigns'.blame_line() end,
            desc = 'blame current line'
        },
        {
            '<Leader>gl',
            function() require 'gitsigns'.toggle_current_line_blame() end,
            desc = 'toggle current line blame'
        },
        {
            '<Leader>gv',
            function() require 'gitsigns'.toggle_deleted() end,
            desc = 'toggle virtual text diff'
        },
        {
            '<Leader>gs',
            ':Gitsigns stage_hunk<CR>',
            mode = 'v',
            desc = 'stage selected',
        },
        {
            '<Leader>gr',
            '<Cmd>Gitsigns reset_hunk<CR>',
            mode = 'v',
            desc = 'reset selected',
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
            desc = 'inner hunk',
        }
    }
}
