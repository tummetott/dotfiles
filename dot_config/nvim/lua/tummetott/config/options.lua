-- Display line numbers
vim.opt.number = true

-- Use relative numbers
vim.opt.relativenumber = true

-- Show signcolumn when necessary with a column of maximum 1 char
vim.opt.signcolumn = 'auto:1'

-- Only show tabline if there are at least two tab pages
vim.opt.showtabline = 1

-- Disable startup message
vim.opt.shortmess:append('I')

-- When writing a file, show verbose output for number of lines / bytes written
vim.opt.shortmess:remove('l')

-- Remove searchcount because I show it in the statusline
vim.opt.shortmess:append('S')

-- Don't show 'search hit BOTTOM, continuing at TOP'. This shown in the
-- statusline by a subtle color change
vim.opt.shortmess:append('s')

-- Only show one global statusline, independent of the number of windows
vim.opt.laststatus = 3

-- Show no ruler in vims native statusline
vim.opt.ruler = false

-- Don't display mode changes as the statusline plugin already shows that
vim.opt.showmode = false

-- With a modeline command, you can e.g. define the filetype of a textfile
-- explicitly)
vim.opt.modeline = true

-- Enable mouse support for all modes. This let's you scroll, jump, select,
-- resize windows etc.
vim.opt.mouse = 'a'

-- Scrolling should be as fine grain as possible with the mouse
vim.opt.mousescroll = "ver:1,hor:1"

-- No linewrap
vim.opt.wrap = false

-- Don't break wrapped lines at the last character that fits on screen but after
-- whole words
vim.opt.linebreak = true

-- Case insensitive search, except when using capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Don't highlight all my matches
vim.opt.hlsearch = false

-- Always leave some lines below and above the cursor when scrolling
vim.opt.scrolloff = 2

-- Disable swap files
vim.opt.swapfile = false

-- Make undo persistent, even after restart
vim.opt.undofile = true

-- With how many whitespace is a '\t' char displayed
vim.opt.tabstop = 4

-- How many whitespaces has a level of indentation. Zero defaults to tabstop
vim.opt.shiftwidth = 0

-- Expand tabs to spaces
vim.opt.expandtab = true

-- Copy indent from current line when starting a new line
vim.opt.autoindent = true

-- Indentation is dependending on the programming language. This is probably
-- overwritten by treesitter
vim.opt.smartindent = true

-- New splits will be right and below instead of left and above
vim.opt.splitbelow = true
vim.opt.splitright = true

-- While adjusting horizontal splits, maintain the distance between the top line
-- and the split separator.
vim.opt.splitkeep = 'topline'

-- Start diff mode with vertical splits
vim.opt.diffopt:append('vertical')

-- This setting significantly improves the diff matching. Why is this no
-- default?
vim.opt.diffopt:append('linematch:60')

-- When doing 'cw' on a word, also delete the whitespace after the word
vim.opt.cpoptions:remove('_')

-- Define various fill characters
vim.opt.fillchars = { fold = '⋅', foldopen = '┬', diff = '╱' }

-- Set characters for blanks. Enable them with 'set list'
vim.opt.listchars = { space = '⋅', tab = '——▸', eol = '↴' }

-- Hyphens are part of keywords
vim.opt.iskeyword:append('-')

-- By default, all folds are open
vim.opt.foldlevelstart = 99

-- Use treesitter to define folds automatically
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Don't show the foldcolumn
vim.opt.foldcolumn = '0'

-- Don't save the current directory when saving a view with :mkview
vim.opt.viewoptions:remove('curdir')

-- Remap leader key to space
vim.g.mapleader = ' '

-- The width where 'gww' would break the line
vim.opt.textwidth = 80

-- I don't want nvim to break my lines automatically at textwidth. This should
-- be the default, however I make it explicit
vim.opt.formatoptions:remove('t')

-- Time until which-key triggers
vim.opt.timeoutlen = 1000

-- Copy to system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Mode sensitive cursor
vim.o.guicursor = "n-v-sm:block,i-c-ci-t:ver25,r-cr-o:hor20"

local function paste()
    return {
        vim.fn.split(vim.fn.getreg(''), '\n'),
        vim.fn.getregtype(''),
    }
end

-- When connected to a remote server over SSH, use OSC 52 to copy text from
-- Neovim on the remote side into the clipboard of the local machine running the
-- terminal
if vim.env.SSH_TTY ~= nil then
    vim.g.clipboard = {
        name = 'OSC 52',
        -- Use OSC 52 for copy
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        -- Do not use OSC 52 for paste: most terminals cannot read clipboard
        -- contents back from the host. Fall back to Neovim’s internal registers
        -- instead
        paste = {
            ['+'] = paste,
            ['*'] = paste,
        },
    }
end

-- Use rounded borders for floating windows
vim.opt.winborder = 'rounded'

-- Don't complain about missing providers in checkhealth
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
