return {
    'tinted-theming/tinted-nvim',
    enabled = true,
    lazy = false,
    opts = {
        default_scheme = "base16-catppuccin-frappe",
        apply_scheme_on_startup = true,
        compile = false,
        capabilities = {
            truecolor = true,
            undercurl = true,
            terminal_colors = true,
        },
        ui = {
            transparent  = false,
            dim_inactive = false,
        },
        styles = {
            comments  = { italic = true },
            keywords  = {},
            functions = {},
            variables = {},
            types     = {},
        },
        highlights = {
            integrations = {
                telescope = true,
                notify    = false,
                cmp       = false,
                blink     = true,
                dapui     = false,
            },
            use_lazy_specs = true,
            overrides = function(_)
                return {}
            end,
        },
        schemes = {},
        selector = {
            enabled = true,
            mode    = "file",
            watch   = true,
            path    = "~/.local/share/tinted-theming/tinty/current_scheme",
        },
    },
    highlights = {
        EndOfBuffer = { fg = 'background' },
        NonText = { fg = 'dark_grey' },
        Search = {
            fg = 'background',
            bg = { darken = 'brightest_white', amount = 0.3 }
        },
        IncSearch = { bg = 'orange', fg = 'background' },
        CursorLineNr = { fg = 'brightest_white', bold = true },
        StatusLine = {},
        StatusLineNC = {},
        FoldColumn = { link = 'LineNr' },
        TabLineFill = {},

        -- Lazy has no explicit plugin spec, so this goes in here
        LazyReasonCmd = { fg = 'dark_grey' },
        LazyReasonEvent = { link = 'LazyReasonCmd' },
        LazyReasonFt = { link = 'LazyReasonCmd' },
        LazyReasonImport = { link = 'LazyReasonCmd' },
        LazyReasonKeys = { link = 'LazyReasonCmd' },
        LazyReasonPlugin = { link = 'LazyReasonCmd' },
        LazyReasonRequire = { link = 'LazyReasonCmd' },
        LazyReasonRuntime = { link = 'LazyReasonCmd' },
        LazyReasonSource = { link = 'LazyReasonCmd' },
        LazyReasonStart = { link = 'LazyReasonCmd' },
        LazySpecial = { fg = 'cyan' }, -- bullet points
        LazyButton = { bg = 'darkest_grey' },
        LazyButtonActive = { bg = 'grey' },
        LazyH1 = { link = 'LazyButton' },
    }
}
