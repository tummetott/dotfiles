return {
    'dlyongemallo/diffview.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            { '<leader>d', group = 'Diff' },
        }
    end,
    opts = {
        file_panel = {
            show = false,
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
            merge_tool = {
                winbar_info = false,
            },
        },
        hooks = {
            diff_buf_win_enter = function(bufnr, winid, ctx)
                -- Locally disable line wrap, list chars and relative numbers
                vim.wo.foldlevel = 0
                vim.wo.wrap = false
                vim.wo.list = false
                vim.wo.relativenumber = false

                -- Disable scrollbar
                local ok, scrollbar = pcall(require, 'scrollbar.utils')
                if ok then
                    scrollbar.hide()
                end
            end,
            view_closed = function()
                -- Enable scrollbar
                local ok, scrollbar = pcall(require, 'scrollbar.utils')
                if ok then
                    scrollbar.show()
                end
            end,
        }
    },
    cmd = {
        'DiffviewOpen',
        'DiffviewClose',
        'DiffviewFileHistory',
        'DiffviewToggleFiles',
        'DiffviewFocusFiles ',
        'DiffviewRefresh',
        'DiffviewLog',
    },
    keys = {
        {
            '<Leader>di',
            '<Cmd>DiffviewOpen --selected-file=%<CR>',
            desc = 'LOCAL against INDEX',
        },
        {
            '<Leader>dh',
            '<Cmd>DiffviewOpen HEAD --selected-file=%<CR>',
            desc = 'LOCAL against HEAD',
        },
        {
            '<Leader>ds',
            '<Cmd>DiffviewOpen HEAD --staged --selected-file=%<CR>',
            desc = 'INDEX against HEAD',
        },
        {
            '<Leader>da',
            '<Cmd>DiffviewFileHistory<CR>',
            desc = 'History for all files',
        },
        {
            '<Leader>dc',
            '<Cmd>DiffviewFileHistory %<CR>',
            desc = 'History for current file',
        },
        {
            '<Leader>dl',
            '<Cmd>DiffviewFileHistory --base=LOCAL %<CR>',
            desc = 'LOCAL against history',
        },
    },
}
