-- VSCode like scrollbar with gitsigns, and search result markers
return {
    'petertriho/nvim-scrollbar',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        handle = {
            -- text = vim.g.nerdfonts and '▐' or '█',
            text = '█',
        },
        handlers = {
            handle = true,
            cursor = false,
            diagnostic = true,
            gitsigns = false,
            search = false,
        },
        excluded_filetypes = {
            'prompt',
            'TelescopeResults',
            'NvimTree',
            'Outline',
            'lazy',
            'blink-cmp-menu',
            'blink-cmp-cmdline',
            'blink-cmp-signature',
            'blink-cmp-documentation',
        },
        set_highlights = false,
    },
    highlights = {
        ScrollbarHandle = { fg = 'dark_grey' },
        ScrollbarError = { fg = 'red' },
        ScrollbarErrorHandle = { fg = 'red', bg = 'dark_grey' },
        ScrollbarWarn = { fg = 'orange' },
        ScrollbarWarnHandle = { fg = 'orange', bg = 'dark_grey' },
        ScrollbarHint = { fg = 'yellow' },
        ScrollbarHintHandle = { fg = 'yellow', bg = 'dark_grey' },
        ScrollbarInfo = { fg = 'blue' },
        ScrollbarInfoHandle = { fg = 'blue', bg = 'dark_grey' },
    }
}
