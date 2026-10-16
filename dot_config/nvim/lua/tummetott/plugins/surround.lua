return {
    'kylechui/nvim-surround',
    enabled = true,
    init = function()
        vim.g.nvim_surround_no_mappings = true
    end,
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
            desc = 'Surround Current Line',
        },
        {
            'S',
            '<Plug>(nvim-surround-normal-line)',
            desc = 'Surround on New Lines',
        },
        {
            'SS',
            '<Plug>(nvim-surround-normal-cur-line)',
            desc = 'Surround Current Line on New Lines',
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
            desc = 'Surround on New Lines',
        },
        {
            'ds',
            '<Plug>(nvim-surround-delete)',
            desc = 'Delete Surround',
        },
        {
            'cs',
            '<Plug>(nvim-surround-change)',
            desc = 'Change Surround',
        },
        {
            'cS',
            '<Plug>(nvim-surround-change-line)',
            desc = 'Change Surround on New Lines',
        }
    }
}
