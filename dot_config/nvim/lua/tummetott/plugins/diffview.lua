return {
    'dlyongemallo/diffview-plus.nvim',
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
                -- Locally disable list chars and relative numbers. Line wrap
                -- follows the tab scoped flag that the <leader><space>w keymap
                -- sets, so it stays off unless the user asked for it.
                vim.wo.foldlevel = 0
                vim.wo.wrap = vim.t.diff_wrap or false
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
            '<Cmd>DiffviewFileHistory --pin-local %<CR>',
            desc = 'LOCAL against history',
        },
        {
            '<Leader>dp',
            function()
                vim.ui.input({ prompt = 'PR number: ' }, function(id)
                    if not id or id == '' then
                        return
                    end

                    local remote_url =
                        vim.fn.system('git remote get-url origin'):gsub('%s+$', '')
                    local ref
                    local branch = 'pr-' .. id

                    if remote_url:match('gitlab') then
                        ref = string.format('merge-requests/%s/head', id)
                    elseif remote_url:match('github') then
                        ref = string.format('pull/%s/head', id)
                    else
                        vim.notify(
                            'Unrecognized remote host for origin: ' .. remote_url,
                            vim.log.levels.ERROR
                        )
                        return
                    end

                    local result =
                        vim.fn.system(string.format('git fetch origin +%s:%s', ref, branch))
                    if vim.v.shell_error ~= 0 then
                        vim.notify('git fetch failed:\n' .. result, vim.log.levels.ERROR)
                        return
                    end

                    local default_branch_result = vim.system({
                        'git',
                        'ls-remote',
                        '--symref',
                        'origin',
                        'HEAD',
                    }, { text = true }):wait()
                    local default_branch = (default_branch_result.stdout or ''):match(
                        'ref: refs/heads/([^%s]+)%s+HEAD'
                    )
                    if default_branch_result.code ~= 0 or not default_branch then
                        vim.notify(
                            'Unable to determine the default branch for origin',
                            vim.log.levels.ERROR
                        )
                        return
                    end

                    vim.cmd('DiffviewOpen origin/' .. default_branch .. '...' .. branch)
                end)
            end,
            desc = 'PR against TARGET',
        },
    },
}
