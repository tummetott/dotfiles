return {
    'tummetott/tinted-nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
        supports = {
            tinty = true,
            tinted_shell = false,
            live_reload = true,
        },
        highlights = {
            telescope = false,
            telescope_borders = false,
            indentblankline = false,
            notify = false,
            cmp = false,
            ts_rainbow = false,
            illuminate = false,
            lsp_semantic = true,
            mini_completion = false,
            dapui = false,
        }
    },
    -- TODO: make PR to drop first parameter of setup function
    config = function(_, opts)
        require('tinted-colorscheme').setup(nil, opts)

        local palette = require("tinted-colorscheme").colors
        local color = require('tummetott.utils.color')
        local specs = color.collect_highlights()
        -- Apply highlights
        for group, spec in pairs(specs) do
            vim.api.nvim_set_hl(0, group, color.resolve_hl(spec, palette))
        end
        -- Also register highlights when ColorScheme event fires
        vim.api.nvim_create_autocmd('User', {
            group = vim.api.nvim_create_augroup("TintedNvim", { clear = true }),
            pattern = 'TintedColorsPost',
            callback = function()
                ---@diagnostic disable-next-line: redefined-local
                local palette = require("tinted-colorscheme").colors
                for group, spec in pairs(specs) do
                    vim.api.nvim_set_hl(0, group, color.resolve_hl(spec, palette))
                end
            end,
        })
    end,
    highlights = {
        EndOfBuffer = { fg = 'background' },
        NonText = { fg = 'darkest_grey' },
        WinSeparator = { fg = 'dark_grey' },
        NormalFloat = { link = 'Normal' },
        FloatBorder = { fg = 'grey' },
        Visual = { bg = 'darkest_grey' },
        Search = {
            fg = 'background',
            bg = { darken = 'brightest_white', amount = 0.3 }
        },
        CurSearch = { link = 'Search' },
        IncSearch = { bg = 'orange', fg = 'background' },
        CursorLine = {
            bg = { darken = 'darkest_grey', amount = 0.6 },
        },
        CursorColumn = { link = 'CursorLine' },
        CursorLineNr = { fg = 'brightest_white', bold = true },
        LineNr = { fg = 'dark_grey' },
        Folded = { fg = 'grey' },
        StatusLine = {},
        StatusLineNC = {},
        DiffAdd = {
            fg = 'background',
            bg = { darken = 'blue', amount = 0.4 },
        },
        DiffText = { link = 'DiffAdd' },
        DiffChange = { link = 'Cursorline' },
        DiffDelete = { link = 'NonText' },
        Pmenu = { bg = 'background' },
        PmenuSel = { bg = 'darkest_grey' },
        PmenuThumb = { bg = 'dark_grey' },
        MatchParen = { bg = 'dark_grey' },
        FoldColumn = { link = 'LineNr' },
        TabLineFill = {},

        -- TODO: This should go into tinted-nvim. Make a rewrite of the plugin.
        -- Use https://github.com/rebelot/kanagawa.nvim as architecture
        -- inspiration
        ['@variable'] = { fg = 'foreground' },
        ['@variable.parameter'] = { fg = 'red' },

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
