local M = {}

M.setup = function(bufnr)
    local gs = package.loaded.gitsigns

    vim.keymap.set(
        'n',
        ']h',
        function()
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end,
        { desc = 'Go to next hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '[h',
        function()
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end,
        { desc = 'Go to previous hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gs',
        function() gs.stage_hunk() end,
        { desc = 'stage hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gS',
        function() gs.stage_buffer() end,
        { desc = 'Stage buffer', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gu',
        function() gs.undo_stage_hunk() end,
        { desc = 'undo stage hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gr',
        function() gs.reset_hunk() end,
        { desc = 'reset hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gR',
        function() gs.reset_buffer() end,
        { desc = 'reset buffer', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gp',
        function() gs.preview_hunk() end,
        { desc = 'preview hunk', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gb',
        function() gs.blame_line() end,
        { desc = 'blame current line', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gl',
        function() gs.toggle_current_line_blame() end,
        { desc = 'toggle current line blame', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>gv',
        function() gs.toggle_deleted() end,
        { desc = 'toggle virtual text diff', buffer = bufnr }
    )

    -- Stage partial hunks in visual mode
    vim.keymap.set(
        'v',
        '<Leader>gs',
        ':Gitsigns stage_hunk<CR>',
        { desc = 'stage selected', buffer = bufnr }
    )

    -- Reset partial hunks in visual mode
    vim.keymap.set(
        'v',
        '<Leader>gr',
        '<Cmd>Gitsigns reset_hunk<CR>',
        { desc = 'reset selected', buffer = bufnr }
    )

    -- Toggle signs in the signcolumn
    vim.keymap.set(
        'n',
        'yog',
        function() gs.toggle_signs() end,
        { desc = 'Toggle gitsigns', buffer = bufnr }
    )

    -- Add textobject
    vim.keymap.set(
        { 'o', 'x' },
        'ih',
        ':<C-u>Gitsigns select_hunk<CR>',
        { desc = 'inner hunk', buffer = bufnr }
    )

    -- Fix prefix description for local keymaps
    require('which-key').register({
        ['<Leader>g'] = { name = 'Gitsigns' }
    }, { buffer = bufnr })
end

return M
