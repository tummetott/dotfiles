local utils = require 'tummetott.utils'

local function echo_toggle(label, enabled)
    vim.api.nvim_echo({
        { label .. ' ', 'Normal' },
        { enabled and 'enabled' or 'disabled', enabled and 'DiagnosticOk' or 'DiagnosticWarn' },
    }, false, {})
end

local maps = {
    {
        mode = 'x',
        lhs = 'J',
        rhs = [[:<C-u>exe "'<,'>move '>+".v:count1<CR>gv=gv]],
        opts = { desc = 'Move selection [count] lines down' }
    },
    {
        mode = 'x',
        lhs = 'K',
        rhs = [[:<C-u>exe "'<,'>move '<--".v:count1<CR>gv=gv]],
        opts = { desc = 'Move selection [count] lines up' }
    },
    {
        mode = { 'i', 'c', 's' },
        lhs = '<C-f>',
        rhs = '<Right>',
        opts = { desc = 'Move cursor right' }
    },
    {
        mode = { 'i', 'c', 's' },
        lhs = '<C-b>',
        rhs = '<Left>',
        opts = { desc = 'Move cursor left' }
    },
    {
        mode = 'i',
        lhs = '<C-k>',
        rhs = function()
            if vim.fn.col('.') ~= vim.fn.col('$') then
                local cursor = vim.api.nvim_win_get_cursor(0)
                vim.api.nvim_command('normal! "_D')    -- Delete to black hole register
                vim.api.nvim_win_set_cursor(0, cursor) -- Restore cursor position
            end
        end,
        opts = { desc = 'Delete to end of line' }
    },
    {
        mode = 'n',
        lhs = 'gV',
        rhs = function()
            local ok, textobj = pcall(require, "yanky.textobj")
            if ok then
                textobj.last_put()
            else
                vim.cmd([[normal! `[v`]])
            end
        end,
        opts = { desc = 'Select previous pasted text' }
    },
    {
        mode = 'n',
        lhs = '<bs>',
        rhs = 'ciw',
        opts = { desc = 'Change word' }
    },
    {
        mode = 'n',
        lhs = '<C-h>',
        rhs = '<C-w>h',
        opts = { desc = 'Jump to left window' }
    },
    {
        mode = 'n',
        lhs = '<C-j>',
        rhs = '<C-w>j',
        opts = { desc = 'Jump to below window' }
    },
    {
        mode = 'n',
        lhs = '<C-k>',
        rhs = '<C-w>k',
        opts = { desc = 'Jump to above window' }
    },
    {
        mode = 'n',
        lhs = '<C-l>',
        rhs = '<C-w>l',
        opts = { desc = 'Jump to right window' }
    },
    {
        mode = 'i',
        lhs = '<C-e>',
        rhs = '<End>',
        opts = { desc = 'Jump to end of line' }
    },
    {
        mode = 'i',
        lhs = '<C-a>',
        rhs = '<Home>',
        opts = { desc = 'Jump to start of line' }
    },
    {
        mode = 'i',
        lhs = '<M-b>',
        rhs = function() vim.cmd('normal! b') end,
        opts = { desc = 'Jump to previous word' }
    },
    {
        mode = 'i',
        lhs = '<M-f>',
        rhs = function() vim.cmd('normal! w') end,
        opts = { desc = 'Jump to next word' }
    },
    {
        mode = 'c',
        lhs = '<C-a>',
        rhs = '<C-b>',
        opts = { desc = 'Jump to start of line' }
    },
    {
        mode = 'c',
        lhs = '<M-Left>',
        rhs = '<S-Left>',
        opts = { desc = 'Jump word backward' }
    },
    {
        mode = 'c',
        lhs = '<M-Right>',
        rhs = '<S-Right>',
        opts = { desc = 'Jump word forward' }
    },
    {
        mode = 'c',
        lhs = '<M-Bs>',
        rhs = '<C-w>',
        opts = { desc = 'Delete word backward' },
    },
    {
        mode = { 'n', 't' },
        lhs = '<c-=>',
        rhs = require('tummetott.utils.winsize').expand,
        opts = { desc = 'Expand window' },
    },
    {
        mode = { 'n', 't' },
        lhs = '<c-->',
        rhs = require('tummetott.utils.winsize').contract,
        opts = { desc = 'Contract window' },
    },
    {
        mode = 'n',
        lhs = '<esc>',
        rhs = function()
            -- Disable highlights temporarily (until next search)
            vim.cmd('nohlsearch')
            -- Clear the cmdline
            vim.cmd('echo ""')
            -- Clear pending highlights
            vim.lsp.buf.clear_references()
            pcall(function()
                require('follow.highlight').clear()
            end)
            -- Close attached floats
            local win = vim.api.nvim_get_current_win()
            utils.close_attached_floats(win)
        end,
        opts = { desc = 'Clear search highlights, cmdline and close floats' }
    },
    {
        mode = 'n',
        lhs = 'gQ',
        rhs = '<NOP>', -- Disable ex mode
        opts = {}
    },
    {
        mode = 'n',
        lhs = ']w',
        rhs = function() vim.fn.search('\\s\\+$', 'w') end,
        opts = { desc = 'Next trailing whitespace' }
    },
    {
        mode = 'n',
        lhs = '[w',
        rhs = function() vim.fn.search('\\s\\+$', 'bw') end,
        opts = { desc = 'Previous trailing whitespace' }
    },
    {
        mode = 'n',
        lhs = 'x',
        rhs = '"_x', -- Don't pollute register
        opts = { desc = 'Delete char under cursor' }
    },
    -- <Tab> and <C-i> share a legacy keycode. Mapping only one key collapses
    -- both to the same action. I therefore map <C-i> to itself to preserve
    -- jumplist behavior.
    {
        mode = 'n',
        lhs = '<C-i>',
        rhs = '<C-i>',
        opts = { desc = 'Newer position in jump list' }
    },
    -- Make `n` always move to the next match and `N` to the previous one,
    -- independent of whether the search was started with `/` or `?`.
    {
        mode = 'n',
        lhs = 'n',
        rhs = '"Nn"[v:searchforward]."zv"',
        opts = { expr = true, desc = 'Next search result' }
    },
    {
        mode = { 'x', 'o' },
        lhs = 'n',
        rhs = '"Nn"[v:searchforward]',
        opts = { expr = true, desc = 'Next search result' }
    },
    {
        mode = 'n',
        lhs = 'N',
        rhs = '"nN"[v:searchforward]."zv"',
        opts = { expr = true, desc = 'Prev search result' }
    },
    {
        mode = { 'x', 'o' },
        lhs = 'N',
        rhs = '"nN"[v:searchforward]',
        opts = { expr = true, desc = 'Prev search result' }
    },
    -- Navigate command line history (prefix sensitive). When a completion menu
    -- is open, <C-n>/<C-p> are used by completion; otherwise they move through
    -- history.
    {
        mode = 'c',
        lhs = '<C-n>',
        rhs = '<down>',
        opts = { desc = 'Next command' }
    },
    {
        mode = 'c',
        lhs = '<C-p>',
        rhs = '<up>',
        opts = { desc = 'Previous command' }
    },
    {
        mode = 'n',
        lhs = '<c-w>t',
        rhs = '<cmd>tabc<cr>',
        opts = { desc = 'Tab close' }
    },
    {
        mode = 'n',
        lhs = '<leader>i2',
        rhs = function()
            -- Don't pullute the jumplist and preserve the cursor position
            vim.opt.tabstop = 2
            vim.opt.expandtab = true
            local view = vim.fn.winsaveview()
            vim.cmd('keepjumps normal! gg=G')
            if view then vim.fn.winrestview(view) end
        end,
        opts = { desc = 'Indent with 2 spaces' }
    },
    {
        mode = 'n',
        lhs = '<leader>i4',
        rhs = function()
            vim.opt.tabstop = 4
            vim.opt.expandtab = true
            local view = vim.fn.winsaveview()
            vim.cmd('keepjumps normal! gg=G')
            if view then vim.fn.winrestview(view) end
        end,
        opts = { desc = 'Indent with 4 spaces' }
    },
    {
        mode = 'n',
        lhs = '<leader>it',
        rhs = function()
            vim.opt.expandtab = false
            local view = vim.fn.winsaveview()
            -- Replace multiples of tabstop spaces with a single tab. Only replace
            -- at the beginning of the line to avoid replacing spaces in string literals
            local pattern = string.format([[\v^( {%d})+]], vim.o.tabstop)
            local replace = string.format([[\=repeat("\t", len(submatch(0))/%d)]], vim.o.tabstop)
            vim.cmd('silent! %s:' .. pattern .. ':' .. replace)
            if view then vim.fn.winrestview(view) end
        end,
        opts = { desc = 'Indent with tab' }
    },
    {
        mode = 'x',
        lhs = 'gn',
        rhs = '<esc>ngn',
        opts = { desc = 'Search forwards and select' }
    },
    {
        mode = 'n',
        lhs = 'Q',
        rhs = 'Qj',
        opts = { desc = 'Repeat macro and move line down', remap = true }
    },
    {
        mode = 'x',
        lhs = 'Q',
        rhs = ':norm Q<CR>',
        opts = { desc = 'Repeat macro on each line' }
    },
    {
        mode = 'n',
        lhs = '<leader>z',
        rhs = '<cmd>Lazy<cr>',
        opts = { desc = 'Open Lazy' }
    },
    {
        mode = 'n',
        lhs = '<leader>yd',
        rhs = function()
            vim.cmd(vim.o.diff and 'diffoff' or 'diffthis')
            echo_toggle('Diff', vim.o.diff)
        end,
        opts = { desc = 'diff' }
    },
    {
        mode = 'n',
        lhs = '<leader>yh',
        rhs = function()
            vim.o.hlsearch = not vim.o.hlsearch
            echo_toggle('Highlight search', vim.o.hlsearch)
        end,
        opts = { desc = 'highlight search' }
    },
    {
        mode = 'n',
        lhs = '<leader>yl',
        rhs = function()
            vim.o.list = not vim.o.list
            echo_toggle('Listchars', vim.o.list)
        end,
        opts = { desc = 'listchars' }
    },
    {
        mode = 'n',
        lhs = '<leader>yn',
        rhs = function()
            vim.o.number = not vim.o.number
            echo_toggle('Line numbers', vim.o.number)
        end,
        opts = { desc = 'line numbers' }
    },
    {
        mode = 'n',
        lhs = '<leader>yr',
        rhs = function()
            vim.o.relativenumber = not vim.o.relativenumber
            echo_toggle('Relative numbers', vim.o.relativenumber)
        end,
        opts = { desc = 'relative numbers' }
    },
    {
        mode = 'n',
        lhs = '<leader>ys',
        rhs = function()
            vim.o.spell = not vim.o.spell
            echo_toggle('Spell check', vim.o.spell)
        end,
        opts = { desc = 'spell check' }
    },
    {
        mode = 'n',
        lhs = '<leader>yt',
        rhs = function()
            vim.o.colorcolumn = vim.o.colorcolumn == '' and '+1' or ''
            echo_toggle('Colorcolumn', vim.o.colorcolumn ~= '')
        end,
        opts = { desc = 'colorcolumn' }
    },
    {
        mode = 'n',
        lhs = '<leader>yv',
        rhs = function()
            vim.diagnostic.config {
                virtual_text = not vim.diagnostic.config().virtual_text,
            }
            echo_toggle('Virtual text', vim.diagnostic.config().virtual_text)
        end,
        opts = { desc = 'virtual text' }
    },
    {
        mode = 'n',
        lhs = '<leader>yw',
        rhs = function()
            vim.o.wrap = not vim.o.wrap
            echo_toggle('Wrap', vim.o.wrap)
        end,
        opts = { desc = 'line wrapping' }
    },
    {
        mode = 'n',
        lhs = 'zh',
        rhs = function()
            if vim.w.diff_highlights_forced_off then
                vim.w.diff_highlights_forced_off = false
                vim.opt_local.winhl:remove {
                    'DiffAdd',
                    'DiffText',
                    'DiffChange',
                }
                local ok, reticle = pcall(require, 'reticle')
                if ok then
                    reticle.set_cursorline(false)
                else
                    vim.wo.cursorline = false
                end
            else
                vim.w.diff_highlights_forced_off = true
                vim.opt_local.winhl:append {
                    DiffAdd = 'None',
                    DiffText = 'None',
                    DiffChange = 'None',
                }
                -- ISSUE: cursorline still shows an underline even if diff
                -- highlights are disabled. See:
                -- https://github.com/neovim/neovim/issues/9800
                local ok, reticle = pcall(require, 'reticle')
                if ok then
                    reticle.set_cursorline(true)
                else
                    vim.wo.cursorline = true
                end
            end
        end,
        opts = { desc = 'Toggle diff highlights' }
    },
    {
        mode = 't',
        lhs = '<c-[>',
        rhs = '<c-\\><c-n>',
        opts = { desc = 'Exit terminal insert mode' }
    },
    -- <esc> and <c-[> share a legacy keycode. Mapping only one key
    -- collapses both to the same action. I therefore map <esc> to itself to
    -- pass the <esc> character through to the terminal program.
    {
        mode = 't',
        lhs = '<esc>',
        rhs = '<esc>',
        opts = { desc = 'Esc passthrough' }
    },
}

for _, m in ipairs(maps) do
    vim.keymap.set(m.mode, m.lhs, m.rhs, m.opts)
end

vim.api.nvim_create_user_command('DebugKeymaps', function()
    local function map(lhs, desc)
        pcall(vim.keymap.set, 'n', lhs, function()
            vim.print(string.format('Pressed: %s', lhs))
        end, { desc = desc })
    end

    local keys = {
        -- letters and numbers
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        -- punctuation & symbols
        ';', ',', '.', '/', '-', '=', '[', ']', '`', "'", '~', '_', '+',
        -- navigation & control
        'Tab', 'CR', 'Enter', 'Esc', 'Bslash', 'Space',
        'Up', 'Down', 'Left', 'Right', 'Home', 'End', 'PageUp', 'PageDown',
    }

    for _, key in ipairs(keys) do
        map('<' .. key .. '>', key)
        map('<C-' .. key .. '>', 'Ctrl+' .. key)
        map('<A-' .. key .. '>', 'Alt+' .. key)
        map('<C-S-' .. key .. '>', 'Ctrl+Shift+' .. key)
    end
    for _, key in ipairs({ 'Tab', 'Left', 'Right', 'Up', 'Down', 'Home', 'End', 'PageUp', 'PageDown' }) do
        map('<S-' .. key .. '>', 'Shift+' .. key)
    end

    vim.notify('DebugKeymaps active — press any key to test.')
end, { desc = 'Register debug mappings for all common keys' })
