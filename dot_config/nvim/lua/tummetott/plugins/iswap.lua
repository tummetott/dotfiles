return {
    'mizlan/iswap.nvim',
    enabled = true,
    dependencies = 'tpope/vim-repeat',
    opts = {
        flash_style = false,
        move_cursor = true,
        hl_snipe = 'IncSearch',
    },
    cmd = {
        'ISwap',
        'ISwapWith',
        'ISwapNode',
        'ISwapNodeWith',
        'ISwapWithLeft',
        'ISwapWithRight',
        'ISwapNodeWithLeft',
        'ISwapNodeWithRight',
    },
    keys = {
        {
            '[sn',
            '<cmd>ISwapNodeWithLeft<cr>',
            desc = 'node',
        },
        {
            ']sn',
            '<cmd>ISwapNodeWithRight<cr>',
            desc = 'node',
        },
        {
            '<leader>e',
            '<cmd>ISwapWith<cr>',
            desc = 'Swap current node',
        },
    }
}
