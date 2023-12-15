local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local group = augroup('CoreGroup', { clear = true })

-- Hide the last entered ex command
autocmd('CmdlineLeave', {
    group = group,
    command = 'echo ""',
})

autocmd('CmdlineEnter', {
    group = group,
    pattern = { '/', '\\?' },
    callback = function()
        vim.opt.hlsearch = true
    end,
})

-- Turn of search highlights when jumping to a search
autocmd('CmdlineLeave', {
    group = group,
    pattern = { '/', '\\?' },
    callback = function()
        vim.opt.hlsearch = false
    end,
})

-- Helper function to check if a view should be created or loaded
local view_check = function()
    -- No special buffers
    if vim.bo.buftype ~= '' then
        return false
    end
    -- No diff views
    if vim.wo.diff then
        return false
    end
    -- Buffer must be modifiable
    if not vim.bo.modifiable then
        return false
    end
    -- File must exist
    if string.len(vim.fn.glob(vim.fn.expand('%:p'))) == 0 then
        return false
    end
    return true
end

-- Loads a view when opening a new buffer
autocmd('BufWinEnter', {
    group = group,
    pattern = '?*',
    callback = function()
        if view_check() then
            -- HACK: https://github.com/nvim-telescope/telescope.nvim/issues/559
            vim.cmd('normal! zX')
            vim.cmd('silent! loadview')
        end
    end,
})

-- Store a view when leaving
autocmd({ 'BufWritePre', 'BufWinLeave' }, {
    group = group,
    pattern = '?*',
    callback = function()
        if view_check() then
            vim.cmd('silent! mkview')
        end
    end,
})

-- Change the visual highlight for diff views
autocmd('OptionSet', {
    group = group,
    pattern = 'diff',
    callback = function()
        -- Don't do anything when diffview is open
        if require 'tummetott.utils'.is_loaded('diffview.nvim') and
            require 'diffview.lib'.get_current_view() then
            return
        end
        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
            vim.api.nvim_win_call(win, function()
                if vim.wo.diff then
                    vim.opt_local.winhl:append {
                        ['Visual'] = 'DiffVisual',
                    }
                else
                    vim.opt_local.winhl:remove { 'Visual' }
                end
            end)
        end
    end
})

-- OptionSet is not triggered on startup, therfore the above autocmd is not
-- triggered when starting nvim in diff move. Trigger it manually.
autocmd('VimEnter', {
    group = group,
    callback = function()
        vim.cmd('doautocmd OptionSet diff')
    end,
    once = true
})

-- Resize splits if window got resized
autocmd('VimResized', {
    group = group,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

-- Wrap and check for spell in text filetypes
autocmd('FileType', {
    group = group,
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does
-- not exist
autocmd({ 'BufWritePre' }, {
    group = group,
    callback = function(event)
        if event.match:match('^%w%w+://') then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})
