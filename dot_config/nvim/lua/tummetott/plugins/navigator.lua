-- Navigate tmux and vim splits with the same shortcuts
return {
    'numToStr/Navigator.nvim',
    enabled = false,
    config = true,
    keys = {
        {
            '<C-h>',
            function() require('Navigator').left() end,
            desc = 'Jump to left window',
        },
        {
            '<C-l>',
            function() require('Navigator').right() end,
            desc = 'Jump to right window',
        },
        {
            '<C-k>',
            function() require('Navigator').up() end,
            desc = 'Jump to upper window',
        },
        {
            '<C-j>',
            function() require('Navigator').down() end,
            desc = 'Jump to lower window',
        },
    },
}
