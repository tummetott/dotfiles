return {
    'numToStr/FTerm.nvim',
    enabled = true,
    opts = {
        border = 'rounded',
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
        }
    }
}
