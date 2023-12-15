local left = {}
local right = {}

table.insert(right, {
    provider = {
        name = 'buff_name',
        update = { 'BufWinEnter' }
    },
    left_sep = {
        {
            str = 'left_rounded',
            hl = { fg = 'bg', bg = 'base' },
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
        str = 'right_rounded',
        hl = { fg = 'bg', bg = 'base' }
    },
})

local components = {
    active = { left, right },
    inactive = { left, right },
}

return components
