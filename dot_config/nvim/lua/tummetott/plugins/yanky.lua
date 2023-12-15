return {
    'gbprod/yanky.nvim',
    enabled = true,
    opts = {
        ring = {
            -- Cycle through the yank ring is disabled when the cursor has been
            -- moved.
            cancel_event = 'move',
            -- When you cycle through the ring, the contents of the register
            -- used to update will be updated with the last content cycled.
            update_register_on_cycle = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 200,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    },
    keys = {
        {
            'y',
            '<Plug>(YankyYank)',
            mode = { 'n', 'x' },
            desc = 'Yank',
        },
        {
            'p',
            '<Plug>(YankyPutAfter)',
            desc = 'Put after',
        },
        -- In visual mode, 'YankyPutBefore' behaves similarly to
        -- 'YankyPutAfter,' with the distinction that it doesn't include the
        -- replaced text in the yank ring.
        {
            'p',
            '<Plug>(YankyPutBefore)',
            mode = 'x',
            desc = 'Put without copying replaced text',
        },
        {
            'P',
            '<Plug>(YankyPutBefore)',
            mode = { 'n', 'x' },
            desc = 'Put before',
        },
        -- I don't see any benefit in vims default `gp` and `gP` behaviour but
        -- the keys are easy to reach, so I'm redefining them to linewise paste
        -- and reindent.
        {
            'gp',
            '<Plug>(YankyPutAfterFilter)',
            desc = 'Put below current line and reindent',
            mode = { 'n', 'x' },
        },
        {
            'gP',
            '<Plug>(YankyPutBeforeFilter)',
            desc = 'Put above current line and reindent',
            mode = { 'n', 'x' },
        },
        {
            ']p',
            '<Plug>(YankyPutIndentAfterLinewise)',
            desc = 'Put below current line using indent of current line',
        },
        {
            '[p',
            '<Plug>(YankyPutIndentBeforeLinewise)',
            desc = 'Put above current line using indent of current line',
        },
        {
            '<C-n>',
            '<Plug>(YankyCycleForward)',
            desc = 'Next item in yank ring',
        },
        {
            '<C-p>',
            '<Plug>(YankyCycleBackward)',
            desc = 'Previous item in yank ring',
        },
        {
            '<leader>fy',
            '<Cmd>YankyRingHistory<Cr>',
            desc = 'Show yank ring history',
        },
    }
}
