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
        textobj = {
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
            desc = 'Put After',
        },
        -- In visual mode, 'YankyPutBefore' behaves similarly to
        -- 'YankyPutAfter,' with the distinction that it doesn't include the
        -- replaced text in the yank ring.
        {
            'p',
            '<Plug>(YankyPutBefore)',
            mode = 'x',
            desc = 'Put without Copying Replaced Text',
        },
        {
            'P',
            '<Plug>(YankyPutBefore)',
            mode = { 'n', 'x' },
            desc = 'Put Before',
        },
        -- I don't see any benefit in vims default `gp` and `gP` behaviour but
        -- the keys are easy to reach, so I'm redefining them to linewise paste
        -- and reindent.
        {
            'gp',
            '<Plug>(YankyPutAfterFilter)',
            desc = 'Put Below and Reindent',
            mode = { 'n', 'x' },
        },
        {
            'gP',
            '<Plug>(YankyPutBeforeFilter)',
            desc = 'Put Above and Reindent',
            mode = { 'n', 'x' },
        },
        {
            '<C-n>',
            '<Plug>(YankyCycleForward)',
            desc = 'Next in Yank Ring',
        },
        {
            '<C-p>',
            '<Plug>(YankyCycleBackward)',
            desc = 'Previous in Yank Ring',
        },
        {
            '<leader>fy',
            function()
                local items = vim.tbl_map(function(entry)
                    return {
                        text = entry.regcontents:gsub('%s+', ' '),
                        entry = entry,
                        preview = { text = entry.regcontents, ft = entry.filetype },
                    }
                end, require('yanky.history').all())
                Snacks.picker.pick({
                    source = 'yank_history',
                    title = 'Yank ring',
                    items = items,
                    format = 'text',
                    preview = 'preview',
                    confirm = function(picker, item)
                        picker:close()
                        if item then
                            require('yanky.picker').actions.put('p', false)(item.entry)
                        end
                    end,
                })
            end,
            desc = 'Yank Ring',
        },
        -- This keymap is set here because yanky must be loaded in order to
        -- highlight the yanked text.
        { 'Y', 'y$', desc = 'Yank to End of Line' },
    },
    highlights = {
        YankyYanked = { bg = 'dark_gray' },
        YankyPut = { link = 'YankyYanked' },
    }
}
