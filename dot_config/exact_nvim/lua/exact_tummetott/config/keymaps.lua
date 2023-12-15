---@diagnostic disable: param-type-mismatch

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
            require('copilot.suggestion').accept()
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
-- Emacs-style command
vim.keymap.set(
    'i',
    '<C-k>',
    'col(".") == col("$") ? "" : "<C-o>D"',
    { desc = 'Delete to end of line', expr = true }
)

-- gV selects the previous paste
vim.keymap.set(
    'n',
    '<leader>v',
    '`[v`]',
    { desc = 'Select previous pasted text' }
)

-- Jump to end of line with CTRL-e in insert mode. I don't use <c-o> to prevent
-- cursor flickering.
vim.keymap.set(
    'i',
    '<C-e>',
    '<cmd>norm A<cr>',
    { desc = 'Jump to end of line' }
)

-- Jump to start of line with CTRL-a in insert mode. I don't use <c-o> to prevent
-- cursor flickering.
vim.keymap.set(
    'i',
    '<C-a>',
    '<Cmd>norm 0<CR>',
    { desc = 'Jump to start of line' }
)

-- Jump to start of line with CTRL-a in command mode
vim.keymap.set(
    'c',
    '<C-a>',
    '<C-b>',
    { desc = 'Jump to start of line' }
)

-- ESC disables hlsearch until next search and clear the cmdline
vim.keymap.set(
    'n',
    '<esc>',
    '<cmd>nohlsearch | echo ""<cr>',
    { desc = 'Clear search highlights' }
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

-- When deleting a char with x, don't yank it into a register -- copy it into
-- the black hole register
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
-- to locate matches that commence with the characters already entered.
vim.keymap.set(
    'c',
    '<C-j>',
    '<down>',
    { desc = 'Next command' }
)
vim.keymap.set(
    'c',
    '<C-k>',
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
        vim.fn.winrestview(view)
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
        vim.fn.winrestview(view)
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
        vim.fn.winrestview(view)
    end,
    { desc = 'Indent with tab' }
)

require('tummetott.utils').which_key_register {
    ['<leader>i'] = { name = 'Indent' }
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
