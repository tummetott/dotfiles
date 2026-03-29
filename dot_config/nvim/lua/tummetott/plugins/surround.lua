return {
    'kylechui/nvim-surround',
    enabled = true,
    opts = {
        move_cursor = false,
    },
    keys = {
        {
            's',
            '<Plug>(nvim-surround-normal)',
            desc = 'Surround',
        },
        {
            'ss',
            '<Plug>(nvim-surround-normal-cur)',
            desc = 'Surround current line',
        },
        {
            'S',
            '<Plug>(nvim-surround-normal-line)',
            desc = 'Surround on new lines',
        },
        {
            'SS',
            '<Plug>(nvim-surround-normal-cur-line)',
            desc = 'Surround current line on new lines',
        },
        {
            's',
            '<Plug>(nvim-surround-visual)',
            mode = 'x',
            desc = 'Surround',
        },
        {
            'S',
            '<Plug>(nvim-surround-visual-line)',
            mode = 'x',
            desc = 'Surround on new lines',
        },
        {
            'ds',
            '<Plug>(nvim-surround-delete)',
            desc = 'Delete surround',
        },
        {
            'cs',
            '<Plug>(nvim-surround-change)',
            desc = 'Change surround',
        },
        {
            'cS',
            '<Plug>(nvim-surround-change-line)',
            desc = 'Change surround on new lines',
        }
    }
}
