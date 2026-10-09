-- Directional focus keys for the snacks picker, one table per layout. Each
-- mirrors where that layout puts the input, list and preview windows.
local M = {}

-- Input on top, list below it, preview to the right of the list
M.ivy = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-l>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
            ['<c-l>'] = 'focus_preview',
        },
    },
    preview = {
        keys = {
            ['<c-h>'] = 'focus_input',
        },
    },
}

-- Preview on top, input below it, list at the bottom
M.dropdown = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-k>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
        },
    },
    preview = {
        keys = {
            ['<c-j>'] = 'focus_input',
        },
    },
}

-- Input on top, list below it. These sources carry no file to jump to, so the
-- trouble keys are dropped
M.vertical = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-o>'] = false,
            ['<c-i>'] = false,
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
        },
    },
}

return M
