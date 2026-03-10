-- Move the file/history panel cursor to the current active file in the view.
-- This normalizes cursor placement after panel open/toggle so it lands on a
-- selectable entry (not header/context lines) in both DiffView and
-- FileHistoryView.
local function focus_panel_selection(view)
    view = view or require("diffview.lib").get_current_view()
    local p = view and view.panel
    if not p or not p:is_open() then return end

    -- DiffView panel
    if p.highlight_cur_file and p.cur_file then
        p:highlight_cur_file()
        return
    end

    -- FileHistoryView panel
    if p.highlight_item and type(p.cur_file) == "function" then
        local file = p:cur_file()
        if file then
            p:highlight_item(file)
            return
        end
    end
end

return {
    'sindrets/diffview.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            { '<leader>d', group = 'Diff' },
        }
    end,
    opts = {
        file_panel = {
            listing_style = 'list',
            win_config = {
                position = 'bottom',
                height = 12,
            },
        },
        use_icons = vim.g.nerdfonts,
        keymaps = {
            view = {
                ['<C-s>'] = function()
                    vim.cmd('DiffviewToggleFiles')
                    -- Fix the cursor position in the file / commit panel
                    focus_panel_selection()
                end,
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
            view_opened = function(view)
                -- Fix the cursor position in the file / commit panel
                view.emitter:on("file_open_post", function()
                    focus_panel_selection(view)
                end)
            end,
            diff_buf_win_enter = function(bufnr, winid, ctx)
                -- Locally disable line wrap, list chars and relative numbers
                vim.opt_local.wrap = false
                vim.opt_local.list = false
                vim.opt_local.relativenumber = false

                -- Disable scrollbar
                local ok, scrollbar = pcall(require, 'scrollbar.utils')
                if ok then
                    scrollbar.hide()
                end
            end,
            view_closed = function()
                -- IBL only has buffer local indent guides. We therefore must
                -- enable the guid of the buffer again when exiting the
                -- diffview.
                local loaded, ibl = pcall(require, 'ibl')
                if loaded then
                    ibl.setup_buffer(0, { enabled = true })
                end

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
