return {
    'sindrets/winshift.nvim',
    enabled = true,
    config = true,
    cmd = 'WinShift',
    keys = {
        {
            '<c-w>m',
            '<cmd>WinShift<CR>',
            desc = 'Move current window',
        }
    }
}
