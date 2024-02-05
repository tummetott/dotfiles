return {
    'numToStr/FTerm.nvim',
    enabled = true,
    opts = {
        border = vim.g.nerdfonts and 'rounded' or 'single',
        dimensions = { height = 0.9, width = 0.9, },
    },
    keys = {
        {
            '<c-s>',
            function() require('FTerm').toggle() end,
            desc = 'Open terminal',
        },
        {
            '<c-s>',
            '<c-\\><c-n><cmd>lua require("FTerm").toggle()<cr>',
            mode = 't',
            desc = 'Close terminal',
        },
        {
            '<c-;>',
            '<c-\\><c-n><c-;>i',
            mode = 't',
            remap = true,
            desc = 'Toggle terminal size',
        },
        {
            '<c-k>',
            '<c-\\><c-n><c-w>k',
            mode = 't',
            desc = 'Move to top pane',
        },
    }
}
