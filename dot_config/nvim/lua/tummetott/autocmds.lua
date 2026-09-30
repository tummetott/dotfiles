local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local group = augroup('CoreGroup', { clear = true })

-- Register keymaps after startup so they do not delay the UI.
autocmd('User', {
    group = group,
    pattern = 'VeryLazy',
    once = true,
    callback = function()
        require('tummetott.keymaps')
    end,
})

-- Hide the last entered ex command
autocmd('CmdlineLeave', {
    group = group,
    command = 'echo ""',
})

-- Whether a view should be created or loaded.
local view_check = function()
    return vim.bo.buftype == ''
        and vim.bo.modifiable
        and not vim.wo.diff
        and vim.wo.foldmethod ~= 'diff'
        and vim.fn.filereadable(vim.fn.expand('%:p')) == 1
end

-- Loads a view when opening a new buffer
autocmd('BufWinEnter', {
    group = group,
    pattern = '?*',
    callback = function()
        if not view_check() then
            return
        end
        -- HACK: A view restores folds by line number, so the folds have to
        -- exist before it is sourced. vim.treesitter.foldexpr() reports level 0
        -- for every line until its parse finishes, and that parse is
        -- asynchronous once a buffer exceeds a few thousand lines. Parsing
        -- synchronously here fills the fold cache first.
        if vim.wo.foldmethod == 'expr' then
            local parser = vim.treesitter.get_parser(0)
            if parser then
                vim.g._ts_force_sync_parsing = true
                parser:parse(true)
                vim.g._ts_force_sync_parsing = false
            end
        end
        vim.cmd('silent! loadview')
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

autocmd('FileType', {
    pattern = 'qf',
    group = group,
    callback = function(ctx)
        -- delete current entry
        vim.keymap.set('n', 'dd', function()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            require('tummetott.utils.qflist').delete_qf_entries(line, line)
        end, {
            buffer = ctx.buf,
            desc = 'Delete quickfix entry',
        })

        -- delete visual selection
        vim.keymap.set('x', 'd', function()
            local first = vim.fn.line('v')
            local last = vim.api.nvim_win_get_cursor(0)[1]
            require('tummetott.utils.qflist').delete_qf_entries(math.min(first, last), math.max(first, last))
        end, {
            buffer = ctx.buf,
            desc = 'Delete qf entries',
        })
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
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- Disable diff highlights when in visual mode.
autocmd('ModeChanged', {
    -- Entering any visual mode (\22 is visual block mode).
    pattern = '*:[v\22]',
    callback = function()
        -- This window local flag is set by a keymap
        if vim.w.diff_highlights_forced_off then
            return
        end
        vim.opt_local.winhl:append {
            DiffAdd = 'None',
            DiffText = 'None',
            DiffChange = 'None',
        }
    end
})
autocmd('ModeChanged', {
    -- Leaving any visual mode.
    pattern = '*:[^v\22]',
    callback = function()
        if vim.w.diff_highlights_forced_off then
            return
        end
        vim.opt_local.winhl:remove {
            'DiffAdd',
            'DiffText',
            'DiffChange',
        }
    end
})

-- FIX: Snacks reuses its dashboard buffer when opening a file (via :edit,
-- Telescope, etc.). Since the buffer already exists, Neovim skips
-- BufRead/BufNewFile events, leaving no filetype. This hook re-detects the
-- filetype for any buffer missing one, restoring syntax highlighting and LSP
-- setup.
autocmd('BufEnter', {
    group = group,
    callback = function()
        if vim.bo.filetype == '' and vim.fn.expand('%:e') ~= '' then
            vim.cmd('silent! filetype detect')
        end
    end,
})

-- Prevent accidentally saving a file named '\'.
-- When typing ":w\" by mistake, automatically do ":w" instead
autocmd('BufWriteCmd', {
    pattern = [[\\]],
    group = group,
    callback = function()
        vim.cmd('write')
    end,
    desc = "Prevent accidentally saving a file named '\\'"
})

-- Disable the command line history window opened by `q:`.
-- Mapping `q:` to <Nop> would introduce a delay when stopping macro
-- recording with `q`, because `q:` makes `q` a keymap prefix and
-- Neovim waits for `timeoutlen` to see if `:` follows.
-- Instead, allow the built-in command to trigger and immediately
-- close the command window via an autocmd, which avoids affecting
-- macro behavior.
-- autocmd("CmdwinEnter", {
--     callback = function()
--         if vim.fn.getcmdwintype() == ":" then
--             vim.cmd("quit")
--         end
--     end,
--     desc = "Disable q: command window",
-- })

-- Disable linenumbers in command windows (search and cmd history)
autocmd("CmdwinEnter", {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
    desc = "Disable linenumbers in command windows",
})

-- An empty spec lets lazy.nvim profile this configuration module.
return {}
