---@diagnostic disable: param-type-mismatch
-- Smooth scolling
return {
    'karb94/neoscroll.nvim',
    enabled = true,
    opts = {
        mappings = {
            '<C-u>',
            '<C-d>',
            '<C-b>',
            '<C-f>',
            'zt',
            'zz',
            'zb',
        },
        -- When true, turn of syntax highlighting while scrolling
        performance_mode = false,
        pre_hook = function()
            vim.cmd('silent! ScrollbarHide')
            vim.opt.eventignore:append({
                'WinScrolled',
                'CursorMoved',
            })
        end,
        post_hook = function()
            vim.cmd('silent! ScrollbarShow')
            vim.opt.eventignore:remove({
                'WinScrolled',
                'CursorMoved',
            })
        end,
        easing_function = 'sine',
    },
    keys = {
        {
            '<C-f>',
            mode = { 'n', 'x' },
            desc = 'Scroll page down',
        },
        {
            '<C-b>',
            mode = { 'n', 'x' },
            desc = 'Scroll page up',
        },
        {
            '<C-d>',
            mode = { 'n', 'x' },
            desc = 'Scroll half page down',
        },
        {
            '<C-u>',
            mode = { 'n', 'x' },
            desc = 'Scroll half page up',
        },
        {
            'zt',
            desc = 'Top this line',
        },
        {
            'zz',
            desc = 'Center this line',
        },
        {
            'zb',
            desc = 'Bottom this line',
        },
    },
}
