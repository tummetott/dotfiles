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
    -- C-w should respect '-' and '_' and delete a segment at a time
    {
        mode = { 'i', 'c' },
        lhs = '<C-w>',
        rhs = function()
            -- Repeated presses collapse into one restore
            if vim.b.iskeyword_restore == nil then
                local buf = vim.api.nvim_get_current_buf()
                vim.b.iskeyword_restore = vim.bo.iskeyword
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                        vim.bo[buf].iskeyword = vim.b[buf].iskeyword_restore
                        vim.b[buf].iskeyword_restore = nil
                    end
                end)
            end
            vim.opt_local.iskeyword:remove { '-', '_' }
            return '<C-S-w>'
        end,
        opts = { expr = true, desc = 'Delete word backward' }
    },
    {
        mode = { 'i', 'c' },
        lhs = '<M-Bs>',
        rhs = '<C-w>',
        opts = { remap = true, desc = 'Delete word backward' },
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
            local ok, textobj = pcall(require, 'yanky.textobj')
            if ok then
                textobj.last_put()
            else
                vim.cmd([=[normal! `[v`] ]=])
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
        mode = { 'n', 'x' },
        lhs = '<C-h>',
        rhs = '<C-w>h',
        opts = { desc = 'Jump to left window' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-j>',
        rhs = '<C-w>j',
        opts = { desc = 'Jump to below window' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-k>',
        rhs = '<C-w>k',
        opts = { desc = 'Jump to above window' }
    },
    {
        mode = { 'n', 'x' },
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
        lhs = '<M-Left>',
        rhs = function() vim.cmd('normal! b') end,
        opts = { desc = 'Jump to previous word' }
    },
    {
        mode = 'i',
        lhs = '<M-Right>',
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
            pcall(function() require('pathnav.highlight').clear() end)
            pcall(function() require('illuminate').invisible_buf() end)
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
        lhs = '[e',
        rhs = function()
            vim.cmd('silent! move --' .. vim.v.count1)
            vim.cmd.normal '=='
        end,
        opts = { desc = 'Exchange above' }
    },
    {
        mode = 'n',
        lhs = ']e',
        rhs = function()
            vim.cmd('silent! move +' .. vim.v.count1)
            vim.cmd.normal '=='
        end,
        opts = { desc = 'Exchange below' }
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
        lhs = '<leader>r',
        rhs = '<cmd>restart<cr>',
        opts = { desc = 'Restart neovim' }
    },
    {
        mode = 'x',
        lhs = 'gn',
        rhs = '<esc>ngn',
        opts = { desc = 'Search forwards and select' }
    },
    {
        mode = 'x',
        lhs = 'Q',
        rhs = ':norm Q<CR>',
        opts = { desc = 'Repeat macro on each line' }
    },
    {
        mode = 'n',
        lhs = '<leader>oz',
        rhs = '<cmd>Lazy<cr>',
        opts = { desc = 'Lazy' }
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
    -- Neovim's builtin incremental selection lives on the `an` and `in` text
    -- objects, which stay available to operators. These remap them onto a
    -- grow/shrink pair for visual mode.
    {
        mode = 'x',
        lhs = '<C-n>',
        rhs = 'an',
        opts = { remap = true, desc = 'Increment selection' }
    },
    {
        mode = 'x',
        lhs = '<C-p>',
        rhs = 'in',
        opts = { remap = true, desc = 'Decrement selection' }
    },
    {
        mode = 'n',
        lhs = '<c-/>',
        rhs = 'gcc',
        opts = { remap = true, desc = 'Comment current line' }
    },
    {
        mode = 'i',
        lhs = '<c-/>',
        rhs = '<c-o>gcc',
        opts = { remap = true, desc = 'Comment current line' }
    },
    {
        mode = 'x',
        lhs = '<c-/>',
        rhs = 'gc',
        opts = { remap = true, desc = 'Comment current selection' }
    },
    -- All native ftplugin mappings are disabled by default. Remap matchit
    {
        mode = 'n',
        lhs = '%',
        rhs = '<Plug>(MatchitNormalForward)',
        opts = { desc = 'Jump to matching pair or keyword' }
    },
    {
        mode = 'x',
        lhs = '%',
        rhs = '<Plug>(MatchitVisualForward)',
        opts = { desc = 'Jump to matching pair or keyword' }
    },
    {
        mode = 'o',
        lhs = '%',
        rhs = '<Plug>(MatchitOperationForward)',
        opts = { desc = 'Jump to matching pair or keyword' }
    },
}

for _, m in ipairs(maps) do
    vim.keymap.set(m.mode, m.lhs, m.rhs, m.opts)
end

Snacks.toggle.option(
    'hlsearch',
    { name = 'highlight search' }
):map('<c-,>h')

Snacks.toggle.option(
    'list',
    { name = 'listchars' }
):map('<c-,>l')

Snacks.toggle.option(
    'number',
    { name = 'line numbers' }
):map('<c-,>n')

Snacks.toggle.option(
    'relativenumber',
    { name = 'relative numbers' }
):map('<c-,>r')

Snacks.toggle.option(
    'spell',
    { name = 'spell check' }
):map('<c-,>s')

Snacks.toggle.option('colorcolumn', {
    name = 'colorcolumn',
    on = '+1',
    off = '',
}):map('<c-,>t')

Snacks.toggle.new({
    name = 'diff',
    get = function() return vim.wo.diff end,
    set = function(state) vim.cmd(state and 'diffthis' or 'diffoff') end,
}):map('<c-,>d')

Snacks.toggle.new({
    name = 'virtual text',
    get = function() return vim.diagnostic.config().virtual_text ~= false end,
    set = function(state) vim.diagnostic.config { virtual_text = state } end,
}):map('<c-,>v')

Snacks.toggle.new({
    name = 'line wrapping',
    get = function() return vim.wo.wrap end,
    set = function(state)
        if not vim.wo.diff then
            vim.opt_local.wrap = state
            return
        end
        -- In a diff, wrapping applies to every diff window of the tabpage.
        -- The tab scoped flag is the source of truth, so diff windows opened
        -- later pick up the same setting.
        vim.t.diff_wrap = state
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.wo[win].diff then
                vim.wo[win].wrap = state
            end
        end
    end,
}):map('<c-,>w')

Snacks.toggle.new({
    name = 'diff highlights',
    get = function() return not vim.w.diff_highlights_forced_off end,
    set = function(state)
        if not vim.wo.diff then
            return
        end
        vim.w.diff_highlights_forced_off = not state
        if state then
            vim.opt_local.winhl:remove {
                'DiffAdd',
                'DiffText',
                'DiffTextAdd',
                'DiffChange',
            }
        else
            vim.opt_local.winhl:append {
                DiffAdd = 'None',
                DiffText = 'None',
                DiffTextAdd = 'None',
                DiffChange = 'None',
            }
        end
        -- ISSUE: cursorline still shows an underline even if diff highlights
        -- are disabled. See: https://github.com/neovim/neovim/issues/9800
        local ok, reticle = pcall(require, 'reticle')
        if ok then
            reticle.set_cursorline(not state)
        else
            vim.wo.cursorline = not state
        end
    end,
}):map('zh')
