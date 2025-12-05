-- VSCode like scrollbar with gitsigns, and search result markers
return {
    'petertriho/nvim-scrollbar',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        handle = {
            text = vim.g.nerdfonts and '▐' or '█',
        },
        handlers = {
            handle = true,
            cursor = false,
            diagnostic = false,
            gitsigns = false,
            search = false,
        },
        excluded_filetypes = {
            'prompt',
            'TelescopeResults',
            'NvimTree',
            'DressingInput',
            'Outline',
            'blink-cmp-menu',
            'blink-cmp-cmdline',
            'blink-cmp-signature',
            'blink-cmp-documentation',
        },
        set_highlights = false,
    }
}
