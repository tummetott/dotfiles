return {
    'linrongbin16/gitlinker.nvim',
    enabled = true,
    opts = {
        -- Disable output on yank
        message = false,
        -- Matches yanky.nvim
        highlight_duration = 200,

    },
    cmd = 'GitLink',
    keys = {
        {
            '<leader>gy',
            '<cmd>GitLink<cr>',
            mode = { 'n', 'v' },
            desc = 'Yank git permalink',
        },
        {
            '<leader>gY',
            '<cmd>GitLink!<cr>',
            mode = { 'n', 'v' },
            desc = 'Open git permalink',
        },
    },
    highlights = {
        NvimGitLinkerHighlightTextObject = { link = 'YankyYanked' }
    },
}
