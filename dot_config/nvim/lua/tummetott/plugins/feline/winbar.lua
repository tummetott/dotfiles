local left = {}
local right = {}

table.insert(right, {
    provider = {
        name = 'buff_name',
        update = { 'BufWinEnter' }
    },
    left_sep = {
        vim.g.nerdfonts and {
            str = 'left_rounded',
            hl = { fg = 'bg', bg = 'base' },
        } or {
            str = ' '
        },
        { str = ' ' }
    },
})

table.insert(right, {
    provider = 'buff_modified',
    left_sep = ' ',
})

table.insert(right, {
    provider = ' ',
    right_sep = {
        vim.g.nerdfonts and {
            str = 'right_rounded',
            hl = { fg = 'bg', bg = 'base' }
        } or {
            str = ' '
        }
    },
})

local components = {
    active = { left, right },
    inactive = { left, right },
}

return components
