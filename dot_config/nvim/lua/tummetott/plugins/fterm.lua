return {
    'numToStr/FTerm.nvim',
    enabled = true,
    opts = {
        border = 'rounded',
        dimensions = { height = 0.9, width = 0.9, },
    },
    keys = {
        {
            '<c-cr>',
            function() require('FTerm').toggle() end,
            desc = 'Open terminal',
        },
        {
            '<c-cr>',
            '<c-\\><c-n><cmd>lua require("FTerm").toggle()<cr>',
            mode = 't',
            desc = 'Close terminal',
        },
    }
}
