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

-- Start insert mode when switching to a terminal buffer
autocmd('BufEnter', {
    group = group,
    pattern = 'term://*',
    callback = function()
        if vim.bo.buftype == 'terminal' then
            vim.cmd('startinsert')
        end
    end
})

-- Disable diff highlights when in visual mode.
-- PERF: Check the performance. If the impact is too big, figure out how to
-- register this autocmds on diff split enter, and clear the group on diff split
-- exit.
autocmd('ModeChanged', {
    -- Entering any visual mode (\22 is visual block mode).
    pattern = '*:[v\22]',
    callback = function()
        vim.opt_local.winhl:append {
            ['DiffAdd'] = 'None',
            ['DiffText'] = 'None',
            ['DiffChange'] = 'None',
        }
        -- Disable hlsearch in visual mode because when both hlsearch and Visual
        -- mode are active, overlapping highlights cause readability issues
        vim.opt.hlsearch = false
    end
})
autocmd('ModeChanged', {
    -- Leaving any visual mode.
    pattern = '*:[^v\22]',
    callback = function()
        vim.opt_local.winhl:remove {
            'DiffAdd',
            'DiffText',
            'DiffChange',
        }
    end
})

-- Autocmds that trigger on the OptionSet diff event should also work when
-- entering vim. By default, no OptionSet event is fired on startup.
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        vim.schedule(function()
            vim.cmd.doautocmd('OptionSet diff')
        end)
    end
})

-- Disable treesitter folding for files > 1.5MB because of performance
autocmd('BufReadPre', {
    group = group,
    callback = function(ctx)
        local bufname = vim.api.nvim_buf_get_name(ctx.buf)
        local size = vim.fn.getfsize(bufname)
        if size < 0 or size > 1.5 * 1024 * 1024 then
            vim.opt.foldmethod = 'manual'
        else
            vim.opt.foldmethod = 'expr'
        end
    end
})
