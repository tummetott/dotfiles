local utils = require 'tummetott.utils'

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
        rhs = '`[v`]',
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
        mode = 'n',
        lhs = '<esc>',
        rhs = function()
            -- Disable highlights temporarily (until next search)
            vim.cmd('nohlsearch')
            -- Clear the cmdline
            vim.cmd('echo ""')
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
    -- TODO: this creates timeout when pressing 'q'
    -- {
    --     mode = 'n',
    --     lhs = 'q:',
    --     rhs = '<NOP>', -- Can also be accessed with 'q?'
    --     opts = {}
    -- },
    {
        mode = 'n',
        lhs = ']w',
        rhs = function() vim.fn.search('\\s\\+$', 'w') end,
        opts = { desc = 'Jump to next trailing whitespace' }
    },
    {
        mode = 'n',
        lhs = '[w',
        rhs = function() vim.fn.search('\\s\\+$', 'bw') end,
        opts = { desc = 'Jump to previous trailing whitespace' }
    },
    {
        mode = 'n',
        lhs = 'x',
        rhs = '"_x', -- Don't pollute register
        opts = { desc = 'Delete char under cursor' }
    },
    -- TAB and C-i share a legacy keycode. Mapping <Tab> also captures <C-i>,
    -- so we remap <C-i> to itself to restore jumplist behavior.
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
