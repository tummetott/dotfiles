-- VSCode like scrollbar with gitsigns, and search result markers
return {
    'petertriho/nvim-scrollbar',
    enabled = false,
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
        ScrollbarHandle = { fg = 'dark_gray' },
        ScrollbarError = { fg = 'red' },
        ScrollbarErrorHandle = { fg = 'red', bg = 'dark_gray' },
        ScrollbarWarn = { fg = 'orange' },
        ScrollbarWarnHandle = { fg = 'orange', bg = 'dark_gray' },
        ScrollbarHint = { fg = 'yellow' },
        ScrollbarHintHandle = { fg = 'yellow', bg = 'dark_gray' },
        ScrollbarInfo = { fg = 'blue' },
        ScrollbarInfoHandle = { fg = 'blue', bg = 'dark_gray' },
    }
}
