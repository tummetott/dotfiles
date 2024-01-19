---@diagnostic disable: redefined-local

-- Scroll the window in the Diffview's file and history panels until the lines
-- displaying help and context information are no longer visible
local scroll_panel = function()
    local offset
    local ft = vim.bo.filetype
    if ft == 'DiffviewFiles' then
        offset = 3
    elseif ft == 'DiffviewFileHistory' then
        offset = 5
    end
    if offset then
        local first_line = vim.fn.line('w0')
        local shift = offset - first_line
        if shift > 0 then
            vim.api.nvim_input(shift .. '<c-e>')
        end
    end
end

return {
    'sindrets/diffview.nvim',
    enabled = true,
    init = function()
        require('tummetott.utils').which_key_register {
            ['<leader>d'] = { name = 'Diff' }
        }
    end,
    opts = {
        file_panel = {
            listing_style = 'list',
        },
        keymaps = {
            view = {
                ['<C-\\>'] = function()
                    vim.cmd('DiffviewToggleFiles')
                    scroll_panel()
                end,
                [']c'] = function()
                    require('diffview.config').actions.select_next_entry()
                end,
                ['[c'] = function()
                    require('diffview.config').actions.select_prev_entry()
                end,
                ['q'] = '<cmd>DiffviewClose<cr>',
            },
            file_panel = {
                ['<C-\\>'] = '<CMD>DiffviewToggleFiles<CR>',
                [']c'] = function()
                    require('diffview.config').actions.select_next_entry()
                end,
                ['[c'] = function()
                    require('diffview.config').actions.select_prev_entry()
                end,
            },
            file_history_panel = {
                ['<C-\\>'] = '<CMD>DiffviewToggleFiles<CR>',
                [']c'] = function()
                    require('diffview.config').actions.select_next_entry()
                end,
                ['[c'] = function()
                    require('diffview.config').actions.select_prev_entry()
                end,
            },
        },
        view = {
            merge_tool = {
                winbar_info = false,
            },
        },
        hooks = {
            view_opened = function(view)
                -- Hide the file browser for diffviews but not for history views
                if (view.class:name() == 'DiffView') then
                    vim.cmd('DiffviewToggleFiles')
                end
            end,
            diff_buf_win_enter = function(bufnr, winid, ctx)
                -- Locally disable line wrap, list chars and relative numbers
                vim.opt_local.wrap = false
                vim.opt_local.list = false
                vim.opt_local.relativenumber = false

                -- Disable local indentation guides
                local ok, ibl = pcall(require, 'ibl')
                if ok then
                    ibl.setup_buffer(bufnr, { enabled = false })
                end

                -- Disable scrollbar
                local ok, scrollbar = pcall(require, 'scrollbar.utils')
                if ok then
                    scrollbar.hide()
                end

                -- Scroll the window until the lines displaying help and context
                -- information are no longer visible
                vim.schedule(scroll_panel)
            end,
            view_closed = function()
                -- Enable local indentation guides
                local loaded, ibl = pcall(require, 'ibl')
                if loaded then
                    ibl.setup_buffer(0, { enabled = true })
                end

                -- Disable scrollbar
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
            '<Cmd>DiffviewOpen --selected-file=' ..
                vim.fn.resolve(vim.fn.expand('%')) .. '<CR>',
            desc = 'LOCAL against INDEX',
        },
        {
            '<Leader>dh',
            '<Cmd>DiffviewOpen HEAD --selected-file=' ..
                vim.fn.resolve(vim.fn.expand('%')) .. '<CR>',
            desc = 'LOCAL against HEAD',
        },
        {
            '<Leader>ds',
            '<Cmd>DiffviewOpen HEAD --staged --selected-file=' ..
                vim.fn.resolve(vim.fn.expand('%')) .. '<CR>',
            desc = 'INDEX against HEAD',
        },
        {
            '<Leader>da',
            '<Cmd>DiffviewFileHistory<CR>',
            desc = 'history for all files',
        },
        {
            '<Leader>dc',
            '<Cmd>DiffviewFileHistory %<CR>',
            desc = 'history for current file',
        },
        {
            '<Leader>dl',
            '<Cmd>DiffviewFileHistory --base=LOCAL %<CR>',
            desc = 'LOCAL against history',
        },
        {
            '<Leader>dq',
            '<Cmd>DiffviewClose<CR>',
            desc = 'quit diffview',
        },
    },
}
