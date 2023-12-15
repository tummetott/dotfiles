-- VSCode like scrollbar with gitsigns, and search result markers
return {
    'petertriho/nvim-scrollbar',
    enabled = false,
    event = 'VeryLazy',
    opts = {
        handle = {
            text = '▐',
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
            'alpha',
            'cmp_menu',
            'cmp_docs',
            'Outline',
        },
        set_highlights = false,
    }
}
