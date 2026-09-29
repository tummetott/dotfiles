return {
    'tummetott/gitlinker.nvim',
    enabled = true,
    opts = {
        -- Disable output on yank
        message = false,
        -- Matches yanky.nvim
        highlight_duration = 200,
        router = {
            browse = {
                ['^ssh%.gitlab%.srlabs%.de'] = 'https://gitlab.srlabs.de/'
                    .. '{_A.ORG}/'
                    .. '{_A.REPO}/blob/'
                    .. '{_A.REV}/'
                    .. '{_A.FILE}'
                    .. '#L{_A.LSTART}'
                    .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
            },
        },
    },
    cmd = 'GitLink',
    -- rev=HEAD pins the link to the commit checked out in neovim.
    keys = {
        {
            '<leader>gy',
            '<cmd>GitLink rev=HEAD<cr>',
            mode = { 'n', 'v' },
            desc = 'Yank git permalink',
        },
        {
            '<leader>gY',
            '<cmd>GitLink! rev=HEAD<cr>',
            mode = { 'n', 'v' },
            desc = 'Open git permalink',
        },
    },
    highlights = {
        NvimGitLinkerHighlightTextObject = { link = 'YankyYanked' }
    },
}
