local utils = require 'tummetott.utils'

local maps = {
    {
        mode = 'x',
        lhs = 'J',
        rhs = [[:<C-u>exe "'<,'>move '>+".v:count1<CR>gv=gv]],
        opts = { desc = 'Move Selection [count] Lines Down' }
    },
    {
        mode = 'x',
        lhs = 'K',
        rhs = [[:<C-u>exe "'<,'>move '<--".v:count1<CR>gv=gv]],
        opts = { desc = 'Move Selection [count] Lines Up' }
    },
    {
        mode = { 'i', 'c', 's' },
        lhs = '<C-f>',
        rhs = '<Right>',
        opts = { desc = 'Move Cursor Right' }
    },
    {
        mode = { 'i', 'c', 's' },
        lhs = '<C-b>',
        rhs = '<Left>',
        opts = { desc = 'Move Cursor Left' }
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
        opts = { expr = true, desc = 'Delete Word Backward' }
    },
    {
        mode = { 'i', 'c' },
        lhs = '<M-Bs>',
        rhs = '<C-w>',
        opts = { remap = true, desc = 'Delete Word Backward' },
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
        opts = { desc = 'Delete to End of Line' }
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
        opts = { desc = 'Select Previous Pasted Text' }
    },
    {
        mode = 'n',
        lhs = '<bs>',
        rhs = 'ciw',
        opts = { desc = 'Change Word' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-h>',
        rhs = '<C-w>h',
        opts = { desc = 'Jump to Left Window' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-j>',
        rhs = '<C-w>j',
        opts = { desc = 'Jump to Below Window' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-k>',
        rhs = '<C-w>k',
        opts = { desc = 'Jump to Above Window' }
    },
    {
        mode = { 'n', 'x' },
        lhs = '<C-l>',
        rhs = '<C-w>l',
        opts = { desc = 'Jump to Right Window' }
    },
    {
        mode = 'i',
        lhs = '<C-e>',
        rhs = '<End>',
        opts = { desc = 'Jump to End of Line' }
    },
    {
        mode = 'i',
        lhs = '<C-a>',
        rhs = '<Home>',
        opts = { desc = 'Jump to Start of Line' }
    },
    {
        mode = 'i',
        lhs = '<M-Left>',
        rhs = function() vim.cmd('normal! b') end,
        opts = { desc = 'Jump to Previous Word' }
    },
    {
        mode = 'i',
        lhs = '<M-Right>',
        rhs = function() vim.cmd('normal! w') end,
        opts = { desc = 'Jump to Next Word' }
    },
    {
        mode = 'c',
        lhs = '<C-a>',
        rhs = '<C-b>',
        opts = { desc = 'Jump to Start of Line' }
    },
    {
        mode = 'c',
        lhs = '<M-Left>',
        rhs = '<S-Left>',
        opts = { desc = 'Jump Word Backward' }
    },
    {
        mode = 'c',
        lhs = '<M-Right>',
        rhs = '<S-Right>',
        opts = { desc = 'Jump Word Forward' }
    },
    {
        mode = { 'n', 't' },
        lhs = '<c-=>',
        rhs = require('tummetott.utils.winsize').expand,
        opts = { desc = 'Expand Window' },
    },
    {
        mode = { 'n', 't' },
        lhs = '<c-->',
        rhs = require('tummetott.utils.winsize').contract,
        opts = { desc = 'Contract Window' },
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
            -- Close attached floats
            local win = vim.api.nvim_get_current_win()
            utils.close_attached_floats(win)
        end,
        opts = { desc = 'Clear Search Highlights, Cmdline and Close Floats' }
    },
    {
        mode = { 'n', 't', 'x' },
        lhs = '<s-bs>',
        rhs = function()
            vim.cmd('echo ""')
        end,
        opts = { desc = 'Clear Cmdline' }
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
        opts = { desc = 'Next Trailing Whitespace' }
    },
    {
        mode = 'n',
        lhs = '[w',
        rhs = function() vim.fn.search('\\s\\+$', 'bw') end,
        opts = { desc = 'Previous Trailing Whitespace' }
    },
    {
        mode = 'n',
        lhs = '[e',
        rhs = function()
            vim.cmd('silent! move --' .. vim.v.count1)
            vim.cmd.normal '=='
        end,
        opts = { desc = 'Exchange Above' }
    },
    {
        mode = 'n',
        lhs = ']e',
        rhs = function()
            vim.cmd('silent! move +' .. vim.v.count1)
            vim.cmd.normal '=='
        end,
        opts = { desc = 'Exchange Below' }
    },
    {
        mode = 'n',
        lhs = 'x',
        rhs = '"_x', -- Don't pollute register
        opts = { desc = 'Delete Char Under Cursor' }
    },
    -- <Tab> and <C-i> share a legacy keycode. Mapping only one key collapses
    -- both to the same action. I therefore map <C-i> to itself to preserve
    -- jumplist behavior.
    {
        mode = 'n',
        lhs = '<C-i>',
        rhs = '<C-i>',
        opts = { desc = 'Newer Position in Jump List' }
    },
    -- Navigate command line history (prefix sensitive). When a completion menu
    -- is open, <C-n>/<C-p> are used by completion; otherwise they move through
    -- history.
    {
        mode = 'c',
        lhs = '<C-n>',
        rhs = '<down>',
        opts = { desc = 'Next Command' }
    },
    {
        mode = 'c',
        lhs = '<C-p>',
        rhs = '<up>',
        opts = { desc = 'Previous Command' }
    },
    {
        mode = 'n',
        lhs = '<c-w>t',
        rhs = '<cmd>tabc<cr>',
        opts = { desc = 'Tab Close' }
    },
    {
        mode = 'n',
        lhs = '<leader>r',
        rhs = '<cmd>restart<cr>',
        opts = { desc = 'Restart Neovim' }
    },
    {
        mode = 'x',
        lhs = 'gn',
        rhs = '<esc>ngn',
        opts = { desc = 'Search Forwards and Select' }
    },
    {
        mode = 'x',
        lhs = 'Q',
        rhs = ':norm Q<CR>',
        opts = { desc = 'Repeat Macro on Each Line' }
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
        opts = { desc = 'Exit Terminal Insert Mode' }
    },
    -- <esc> and <c-[> share a legacy keycode. Mapping only one key
    -- collapses both to the same action. I therefore map <esc> to itself to
    -- pass the <esc> character through to the terminal program.
    {
        mode = 't',
        lhs = '<esc>',
        rhs = '<esc>',
        opts = { desc = 'Esc Passthrough' }
    },
    -- Neovim's builtin incremental selection lives on the `an` and `in` text
    -- objects, which stay available to operators. These remap them onto a
    -- grow/shrink pair for visual mode.
    {
        mode = 'x',
        lhs = '<C-n>',
        rhs = 'an',
        opts = { remap = true, desc = 'Increment Selection' }
    },
    {
        mode = 'x',
        lhs = '<C-p>',
        rhs = 'in',
        opts = { remap = true, desc = 'Decrement Selection' }
    },
    {
        mode = 'n',
        lhs = '<c-/>',
        rhs = 'gcc',
        opts = { remap = true, desc = 'Comment Current Line' }
    },
    {
        mode = 'i',
        lhs = '<c-/>',
        rhs = '<c-o>gcc',
        opts = { remap = true, desc = 'Comment Current Line' }
    },
    {
        mode = 'x',
        lhs = '<c-/>',
        rhs = 'gc',
        opts = { remap = true, desc = 'Comment Current Selection' }
    },
    -- All native ftplugin mappings are disabled by default. Remap matchit
    {
        mode = 'n',
        lhs = '%',
        rhs = '<Plug>(MatchitNormalForward)',
        opts = { desc = 'Jump to Matching Pair or Keyword' }
    },
    {
        mode = 'x',
        lhs = '%',
        rhs = '<Plug>(MatchitVisualForward)',
        opts = { desc = 'Jump to Matching Pair or Keyword' }
    },
    {
        mode = 'o',
        lhs = '%',
        rhs = '<Plug>(MatchitOperationForward)',
        opts = { desc = 'Jump to Matching Pair or Keyword' }
    },
    {
        mode = 'n',
        lhs = 'dd',
        rhs = function()
            local line = vim.api.nvim_win_get_cursor(0)[1]
            require('tummetott.utils.qflist').delete_qf_entries(line, line)
        end,
        opts = { ft = 'qf', desc = 'Delete Quickfix Entry' }
    },
    {
        mode = 'x',
        lhs = 'd',
        rhs = function()
            local first = vim.fn.line('v')
            local last = vim.api.nvim_win_get_cursor(0)[1]
            require('tummetott.utils.qflist').delete_qf_entries(
                math.min(first, last), math.max(first, last))
        end,
        opts = { ft = 'qf', desc = 'Delete Quickfix Entries' }
    },
    {
        mode = 'n',
        lhs = '<leader>yf',
        rhs = function()
            vim.fn.setreg('+', vim.fn.expand('%:p:~'))
        end,
        opts = { desc = 'File Path' }
    },
    {
        mode = 'n',
        lhs = '<leader>yb',
        rhs = function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            vim.fn.setreg('+', lines, 'V')
            vim.hl.range(0, vim.api.nvim_create_namespace('YankBuffer'),
                'YankyYanked', { 0, 0 }, { #lines - 1, 0 },
                { regtype = 'V', timeout = 200 })
        end,
        opts = { desc = 'Buffer Content' }
    }
}

for _, m in ipairs(maps) do
    Snacks.keymap.set(m.mode, m.lhs, m.rhs, m.opts)
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
