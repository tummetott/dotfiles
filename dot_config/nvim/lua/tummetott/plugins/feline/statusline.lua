local provider = require 'tummetott.plugins.feline.provider'
local mode_color = require('feline.providers.vi_mode').get_mode_color

local left = {}
local mid = {}
local right = {}
local left_special = {}
local right_special = {}

-- Vim Mode
table.insert(left, {
    provider = 'vi_mode',
    icon = '',
    hl = function()
        return {
            fg = mode_color(),
            style = 'bold'
        }
    end,
    left_sep = {
        vim.g.nerdfonts and {
            str = 'left_rounded',
            hl = { fg = 'bg', bg = 'base' },
        } or {
            str = ' '
        },
        { str = ' ' },
    },
    priority = 9,
})

-- Git branch
table.insert(left, {
    provider = 'git_branch',
    icon = not vim.g.nerdfonts and '' or nil,
    short_provider = '',
    left_sep = '  ',
    priority = 5,
})

-- Git added
table.insert(left, {
    provider = 'git_diff_added',
    icon = not vim.g.nerdfonts and '+' or nil,
    short_provider = '',
    left_sep = ' ',
    priority = 3,
})

-- Git removed
table.insert(left, {
    provider = 'git_diff_removed',
    icon = not vim.g.nerdfonts and '-' or nil,
    short_provider = '',
    left_sep = ' ',
    priority = 3,
})

-- Git changed
table.insert(left, {
    provider = 'git_diff_changed',
    icon = not vim.g.nerdfonts and '~' or '  ',
    short_provider = '',
    left_sep = ' ',
    priority = 3,
})

-- LSP error
table.insert(mid, {
    provider = 'diagnostic_errors',
    icon = not vim.g.nerdfonts and 'E' or nil,
    short_provider = '',
    hl = { fg = 'red' },
    left_sep = '  ',
    priority = 6,
})

-- LSP warning
table.insert(mid, {
    provider = 'diagnostic_warnings',
    icon = not vim.g.nerdfonts and 'W' or nil,
    short_provider = '',
    hl = { fg = 'orange' },
    left_sep = '  ',
    priority = 6,
})

-- LSP hint
table.insert(mid, {
    provider = 'diagnostic_hints',
    icon = not vim.g.nerdfonts and 'H' or nil,
    short_provider = '',
    hl = { fg = 'yellow' },
    left_sep = '  ',
    priority = 6,
})

-- LSP info
table.insert(mid, {
    provider = 'diagnostic_info',
    icon = not vim.g.nerdfonts and 'I' or nil,
    short_provider = '',
    hl = { fg = 'blue' },
    left_sep = '  ',
    priority = 6,
})

-- Git conflict
table.insert(right, {
    provider = {
        name = 'git_conflict',
        update = { 'BufWritePost', 'CursorHold' },
    },
    short_provider = '',
    right_sep = '  ',
    hl = { fg = 'red' },
    priority = 1,
})

-- Filetype
table.insert(right, {
    provider = {
        name = 'filetype',
        update = { 'FileType', 'BufNewFile' },
        opts = { filetype_icon = true },
    },
    right_sep = '  ',
})

-- Conda environment
table.insert(right, {
    provider = {
        name = 'conda_environment',
        update = {
            'BufWinEnter',
            'TermEnter',
            'TermLeave',
            'FocusGained',
        }
    },
    short_provider = '',
    right_sep = '  ',
    hl = { fg = 'blue' },
    priority = 4,
})

-- Trailing whitespaces
table.insert(right, {
    provider = {
        name = 'trailing_whitespace',
        update = { 'BufWritePost', 'CursorHold' },
    },
    short_provider = '',
    right_sep = '  ',
    hl = { fg = 'red' },
})

-- LSP active information
table.insert(right, {
    provider = {
        name = 'lsp_attached',
    },
    short_provider = '',
    right_sep = '  ',
    priority = 7,
})

-- Indent
table.insert(right, {
    provider = {
        name = 'indent',
        update = { 'BufWritePost', 'CursorHold', 'BufWinEnter' },
    },
    right_sep = '  ',
    hl = function()
        return provider.mixed and { fg = 'red' } or nil
    end
})

-- Encoding
table.insert(right, {
    provider = 'file_encoding',
    icon = vim.g.nerdfonts and ' ' or 'ENCODING: ',
    right_sep = '  ',
})

-- Search count
table.insert(right, {
    provider = {
        name = 'searchcount',
        update = { 'CursorMoved' }
    },
    hl = function()
        if vim.g.search_wrapped then
            vim.g.search_wrapped = false
            return { fg = 'teal' }
        end
    end,
    right_sep = '  ',
})

table.insert(right, {
    provider = 'line_percentage',
    icon = vim.g.nerdfonts and ' ' or 'LINES: ',
    right_sep = {
        { str = ' ' },
        vim.g.nerdfonts and {
            str = 'right_rounded',
            hl = { fg = 'bg', bg = 'base' },
        } or {
            str = ' '
        },
    },
})

----------------------------------  Special filetypes

table.insert(left_special, {
    provider = ' ',
    left_sep = {
        vim.g.nerdfonts and {
            str = 'left_rounded',
            hl = { fg = 'bg', bg = 'base' },
        } or {
            str = ' '
        }
    }
})

table.insert(left_special, {
    provider = 'bufname_by_filetype',
    hl = {
        fg = 'blue',
        style = 'bold',
    },
    enabled = function()
        return not vim.tbl_contains({
            'help',
            'lspinfo',
            'man',
            'Trouble',
        }, vim.bo.filetype)
    end,
})

-- Just for help buffers
table.insert(left_special, {
    provider = 'help_file',
    enabled = function()
        return vim.bo.filetype == 'help'
    end
})

-- Search count
table.insert(right_special, {
    provider = {
        name = 'searchcount',
        update = { 'CursorMoved' }
    },
    right_sep = '  ',
    enabled = function()
        return not vim.tbl_contains({
            'TelescopePrompt',
        }, vim.bo.filetype)
    end,
})

table.insert(right_special, {
    provider = 'line_percentage',
    icon = ' ',
    right_sep = ' ',
    enabled = function()
        return not vim.tbl_contains({
            'TelescopePrompt',
        }, vim.bo.filetype)
    end,
})

table.insert(right_special, {
    provider = ' ',
    right_sep = {
        vim.g.nerdfonts and {
            str = 'right_rounded',
            hl = { fg = 'bg', bg = 'base' },
        } or {
            str = ' '
        }
    },
})

local components = {
    active = { left, mid, right },
    inactive = { left_special, right_special }
}

return components
