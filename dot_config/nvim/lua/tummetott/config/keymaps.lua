local utils = require 'tummetott.utils'

-- Pressing J in visual mode moves the entire line down and corrects the indent
vim.keymap.set(
    'x',
    'J',
    [[:<C-u>exe "'<,'>move '>+".v:count1<CR>gv=gv]],
    { desc = 'Move selection [count] lines down' }
)

-- Pressing K in visual mode moves the entire line down and corrects the indent
vim.keymap.set(
    'x',
    'K',
    [[:<C-u>exe "'<,'>move '<--".v:count1<CR>gv=gv]],
    { desc = 'Move selection [count] lines up' }
)

-- Exclude the insert mode mapping because a special case is needed to make C-f
-- also accept the copilot suggestion
vim.keymap.set(
    { 'c', 's' },
    '<C-f>',
    '<Right>',
    { desc = 'Move cursor right' }
)

-- Determine if Copilot is currently visible with an active suggestion
local active_suggestion = function()
    return require 'tummetott.utils'.is_loaded('copilot.lua') and
        require 'copilot.suggestion'.is_visible()
end

vim.keymap.set(
    'i',
    '<C-f>',
    function()
        if active_suggestion() then
            require('copilot.suggestion').accept_word()
        else
            vim.api.nvim_input('<Right>')
        end
    end,
    { desc = 'Move cursor right' }
)

vim.keymap.set(
    { 'i', 'c', 's' },
    '<C-b>',
    '<Left>',
    { desc = 'Move cursor left' }
)

-- Delete from the current cursor position to the end of the line, following an
-- Emacs-style command. Delete to the black hole register and don't move the
-- cursor.
vim.keymap.set(
    'i',
    '<C-k>',
    function()
        if vim.fn.col('.') ~= vim.fn.col('$') then
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_command('normal! "_D')
            vim.api.nvim_win_set_cursor(0, cursor)
        end
    end,
    { desc = 'Delete to end of line' }
)

-- gV selects the previous paste
vim.keymap.set(
    'n',
    'gV',
    '`[v`]',
    { desc = 'Select previous pasted text' }
)

-- Change word with BS
vim.keymap.set(
    'n',
    '<bs>',
    'ciw',
    { desc = 'Change word' }
)

vim.keymap.set(
    'n',
    '<C-h>',
    '<C-w>h',
    { desc = 'Jump to left window' }
)
vim.keymap.set(
    'n',
    '<C-j>',
    '<C-w>j',
    { desc = 'Jump to below window' }
)
vim.keymap.set(
    'n',
    '<C-k>',
    '<C-w>k',
    { desc = 'Jump to above window' }
)
vim.keymap.set(
    'n',
    '<C-l>',
    '<C-w>l',
    { desc = 'Jump to right window' }
)

-- Jump to end of line or close LSP floating window.
vim.keymap.set(
    'i',
    '<C-e>',
    function()
        -- Try to close a floating window.
        local win = vim.api.nvim_get_current_win()
        if utils.close_lsp_float(win) then
            return
        end
        -- If no float is present, move to end of the line.
        local key = vim.api.nvim_replace_termcodes('<End>', true, false, true)
        vim.api.nvim_feedkeys(key, 'i', false)
    end,
    { desc = 'Jump to end of line' }
)

-- Jump to start of line.
vim.keymap.set(
    'i',
    '<C-a>',
    '<Home>',
    { desc = 'Jump to start of line' }
)

-- Jump one word back (emacs style)
vim.keymap.set(
    'i',
    '<M-b>',
    function() vim.cmd('normal! b') end,
    {
        noremap = true,
        silent = true,
        desc = 'Jump to previous word'
    }
)

-- Jump one word forward (emacs style)
vim.keymap.set(
    'i',
    '<M-f>',
    function() vim.cmd('normal! w') end,
    {
        noremap = true,
        silent = true,
        desc = 'Jump to next word'
    }
)

-- Jump to start of line with CTRL-a in command mode
vim.keymap.set(
    'c',
    '<C-a>',
    '<C-b>',
    { desc = 'Jump to start of line' }
)

-- Various clearing cmds on escape
vim.keymap.set(
    'n',
    '<esc>',
    function()
        -- Disable highlights temporarily (until next search)
        vim.cmd('nohlsearch')
        -- Clear the cmdline
        vim.cmd('echo ""')
        -- Close the LSP floating window if present
        local win = vim.api.nvim_get_current_win()
        utils.close_lsp_float(win)
    end,
    { desc = 'Clear search highlights, cmdline and close floats' }
)

-- Disable ex mode. This mode is useless and it's annoying to quit out of it
-- when entered accidentally
vim.keymap.set('n', 'gQ', '<NOP>', {})

-- Jump to next trailing whitespace
vim.keymap.set(
    'n',
    ']w',
    function() vim.fn.search('\\s\\+$', 'w') end,
    { desc = 'Jump to next trailing whitespace' }
)

-- Jump to previous trailing whitespace
vim.keymap.set(
    'n',
    '[w',
    function() vim.fn.search('\\s\\+$', 'bw') end,
    { desc = 'Jump to previous trailing whitespace' }
)

-- When deleting a char with x, don't yank it into a register.
vim.keymap.set(
    'n',
    'x',
    '"_x',
    { desc = 'Delete char under cursor' }
)

-- In the past, TAB and C-i were identified by the same terminal code. However,
-- recent versions of nvim are capable of distinguishing between them. However,
-- as soon as we define a mapping for TAB, the C-i is assigned to the same
-- mapping, thats why we must restore the original functionality by assigning
-- CTRL-i to itself.
vim.keymap.set(
    'n',
    '<C-i>',
    '<C-i>',
    { desc = 'Newer position in jump list' }
)

-- Make 'n' always search forward and 'N' always search backward, no matter if
-- you started the search with '/' or '?'
vim.keymap.set(
    'n',
    'n',
    '"Nn"[v:searchforward]."zv"',
    { expr = true, desc = 'Next search result' }
)
vim.keymap.set(
    { 'x', 'o' },
    'n',
    '"Nn"[v:searchforward]',
    { expr = true, desc = 'Next search result' }
)
vim.keymap.set(
    'n',
    'N',
    '"nN"[v:searchforward]."zv"',
    { expr = true, desc = 'Prev search result' }
)
vim.keymap.set(
    { 'x', 'o' },
    'N',
    '"nN"[v:searchforward]',
    { expr = true, desc = 'Prev search result' }
)

-- Navigate through previous commands in the command line, restrict the search
-- to locate matches that commence with the characters already entered. If a
-- completion window is open, C-n and C-p navigate within it. Pressing C-e
-- closes this window, allowing the keymaps to also navigate command history.
vim.keymap.set(
    'c',
    '<C-n>',
    '<down>',
    { desc = 'Next command' }
)
vim.keymap.set(
    'c',
    '<C-p>',
    '<up>',
    { desc = 'Previous command' }
)

-- Keymap to close a tab
vim.keymap.set(
    'n',
    '<c-w>t',
    '<cmd>tabc<cr>',
    { desc = 'Tab close' }
)

vim.keymap.set(
    'n',
    '<leader>i2',
    function()
        -- Don't pullute the jumplist and preserve the cursor position
        vim.opt.tabstop = 2
        vim.opt.expandtab = true
        local view = vim.fn.winsaveview()
        vim.cmd('keepjumps normal! gg=G')
        if view then vim.fn.winrestview(view) end
    end,
    { desc = 'Indent with 2 spaces' }
)

vim.keymap.set(
    'n',
    '<leader>i4',
    function()
        vim.opt.tabstop = 4
        vim.opt.expandtab = true
        local view = vim.fn.winsaveview()
        vim.cmd('keepjumps normal! gg=G')
        if view then vim.fn.winrestview(view) end
    end,
    { desc = 'Indent with 4 spaces' }
)

vim.keymap.set(
    'n',
    '<leader>it',
    function()
        vim.opt.expandtab = false
        local view = vim.fn.winsaveview()
        -- Replace multiples of tabstop spaces with a single tab. Only replace
        -- at the beginning of the line to avoid replacing spaces in string literals
        local pattern = string.format([[\v^( {%d})+]], vim.o.tabstop)
        local replace = string.format([[\=repeat("\t", len(submatch(0))/%d)]], vim.o.tabstop)
        vim.cmd('silent! %s:' .. pattern .. ':' .. replace)
        if view then vim.fn.winrestview(view) end
    end,
    { desc = 'Indent with tab' }
)

require('which-key').add {
    { "<leader>i", group = "Indent" },
}

-- Replicate the 'gn' keymap of normal mode in visual mode
vim.keymap.set(
    'x',
    'gn',
    '<esc>ngn',
    { desc = 'Search forwards and select' }
)

-- Repeat last recorded macro and move line down
vim.keymap.set(
    'n',
    'Q',
    'Qj',
    { desc = 'Repeat macro and move line down', remap = true }
)

-- Repeat last recorded macro on each line
vim.keymap.set(
    'x',
    'Q',
    ':norm Q<CR>',
    { desc = 'Repeat macro on each line' }
)

vim.keymap.set(
    'n',
    '<leader>z',
    '<cmd>Lazy<cr>',
    { desc = 'Open Lazy' }
)

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
    for _, key in ipairs({'Tab', 'Left', 'Right', 'Up', 'Down', 'Home', 'End', 'PageUp', 'PageDown'}) do
        map('<S-' .. key .. '>', 'Shift+' .. key)
    end

    vim.notify('DebugKeymaps active — press any key to test.')
end, { desc = 'Register debug mappings for all common keys' })
