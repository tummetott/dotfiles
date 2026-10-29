return {
    'tummetott/diffview-plus.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            {
                '<leader>d',
                group = 'Diff',
                icon = vim.g.nerdfonts and '' or nil,
            },
        }
    end,
    opts = {
        file_panel = {
            show = true,
            listing_style = 'list',
            win_config = {
                position = 'bottom',
                height = 12,
            },
        },
        file_history_panel = {
            show = true,
        },
        use_icons = vim.g.nerdfonts,
        wrap_entries = false,
        -- Histogram groups changes into cleaner hunks than the default myers
        -- algorithm, and linematch pairs added with deleted lines inside a
        -- hunk so the intra-line DiffText highlight carries meaning.
        diffopt = {
            algorithm = 'histogram',
            linematch = 60,
        },
        auto_close_on_empty = true,
        clean_up_buffers = true,
        keymaps = {
            view = {
                ['<C-s>'] = '<CMD>DiffviewToggleFiles<CR>',
                ['<c-q>'] = function()
                    if require('dismiss').has_dismissable_win() then
                        require('dismiss').dismiss()
                    else
                        vim.cmd('DiffviewClose')
                    end
                end,
            },
            file_panel = {
                ['<C-s>'] = '<CMD>DiffviewToggleFiles<CR>',
            },
            file_history_panel = {
                ['<C-s>'] = '<CMD>DiffviewToggleFiles<CR>',
            },
        },
        view = {
            default = {
                focus_diff = true,
            },
            merge_tool = {
                winbar_info = false,
            },
        },
        hooks = {
            diff_buf_win_enter = function(bufnr, winid, ctx)
                -- Save revision information. Consumed by winbar plugin
                vim.w[winid].diffview_ctx = ctx
                -- diff_wrap sync the wrap of all diff windows
                vim.wo.wrap = vim.t.diff_wrap or false
                vim.wo.relativenumber = false
                -- In a diffview, a fold always hides unchanged code. Diffview makes
                -- an exception for added or deleted files and keeps the buffer's own
                -- folds there. Forcing diff folding keeps that meaning everywhere, so
                -- a file without a counterpart stays fully open.
                vim.wo.foldmethod = 'diff'
            end,
        }
    },
    cmd = {
        'DiffviewOpen',
        'DiffviewToggle',
        'DiffviewClose',
        'DiffviewFileHistory',
        'DiffviewToggleFiles',
        'DiffviewFocusFiles',
        'DiffviewRefresh',
        'DiffviewLog',
    },
    keys = {
        {
            '<Leader>di',
            '<Cmd>DiffviewOpen --selected-file=%<CR>',
            desc = 'LOCAL vs INDEX',
        },
        {
            '<Leader>dh',
            '<Cmd>DiffviewOpen HEAD --selected-file=%<CR>',
            desc = 'LOCAL vs HEAD',
        },
        {
            '<Leader>ds',
            '<Cmd>DiffviewOpen HEAD --staged --selected-file=%<CR>',
            desc = 'INDEX vs HEAD',
        },
        {
            '<Leader>da',
            '<Cmd>DiffviewFileHistory<CR>',
            desc = 'All Files Log',
        },
        {
            '<Leader>dc',
            '<Cmd>DiffviewFileHistory %<CR>',
            desc = 'Current File Log',
        },
        {
            '<Leader>dl',
            '<Cmd>DiffviewFileHistory --pin-local %<CR>',
            desc = 'LOCAL vs History',
        },
        {
            '<Leader>dp',
            function() require('tummetott.utils.pr').diff() end,
            desc = 'BRANCH vs PR TARGET',
        },
    },
}
