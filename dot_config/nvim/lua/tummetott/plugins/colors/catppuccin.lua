local M = {}

table.insert(M, {
    'catppuccin/nvim',
    enabled = true,
    name = 'catppuccin',
    -- cond = function()
    --     return vim.g.theme_spec.plugin == 'catppuccin'
    -- end,
    priority = 1000,
    opts = {
        flavour = 'frappe',
        custom_highlights = function(c)
            local darken = require 'catppuccin.utils.colors'.darken
            return {
                NormalFloat = { link = 'Normal' },
                FloatBorder = { fg = c.surface1 },
                WinSeparator = { fg = c.surface1 },
                Whitespace = { fg = c.surface0 },
                NonText = { link = 'Whitespace' },
                Visual = { bg = c.surface0, style = { nil } },
                Search = { fg = c.surface0, bg = darken(c.lavender, 0.7, c.base) },
                CurSearch = { link = 'Search' },
                IncSearch = { bg = c.maroon },
                FlashLabel = { fg = c.base, bg = c.maroon, style = { 'bold' } },
                CursorLine = { bg = darken(c.surface0, 0.4, c.base) },
                CursorLineNr = { fg = c.lavender, style = { 'bold' } },
                Folded = { fg = c.overlay0, bg = c.base },
                StatusLine = { bg = '' },
                DiagnosticError = { fg = c.red },
                DiagnosticWarn = { fg = c.peach },
                DiagnosticHint = { fg = c.yellow },
                DiagnosticInfo = { fg = c.blue },
                LspSignatureActiveParameter = { link = 'Visual' },
                LspReferenceRead = { bg = c.surface2 },
                LspReferenceWrite = { bg = c.surface2 },
                DiffAdd = { fg = c.base, bg = darken(c.base, 0.3, c.blue) },
                DiffText = { link = 'DiffAdd' },
                DiffChange = { link = 'Cursorline' },
                DiffDelete = { fg = c.surface0, bg = c.base },
                TabbyTab = { fg = c.surface2, bg = c.base },
                AlphaHeader = { fg = c.blue },
                AlphaFooter = { fg = c.subtext0 },
                TelescopeBorder = { link = 'WinSeparator' },
                TelescopeSelectionCaret = { fg = c.flamingo },
                TelescopeMatching = { fg = c.blue },
                TelescopeTitle = { fg = c.blue },
                CmpItemAbbrMatch = { fg = c.blue },
                CmpItemAbbrMatchFuzzy = { fg = c.blue },
                CmpItemMenu = { fg = c.surface1 }, -- Cmp source
                CmpItemAbbr = { fg = c.subtext0 }, -- Item
                PmenuThumb = { bg = c.surface1 }, -- Scrollbar of popup windows
                IblIndent = { link = 'Whitespace' },
                IblScope = { fg = c.surface2 },
                WhichKeyDesc = { fg = c.sapphire },
                WhichKeyGroup = { fg = c.mauve },
                GitSignsChange = { fg = c.blue },
                TroubleIndent = { link = 'Whitespace' },
                TroubleText = { fg = c.text },
                LazyReasonCmd = { fg = c.surface1 },
                LazyReasonEvent = { link = 'LazyReasonCmd' },
                LazyReasonFt = { link = 'LazyReasonCmd' },
                LazyReasonImport = { link = 'LazyReasonCmd' },
                LazyReasonKeys = { link = 'LazyReasonCmd' },
                LazyReasonPlugin = { link = 'LazyReasonCmd' },
                LazyReasonRequire = { link = 'LazyReasonCmd' },
                LazyReasonRuntime = { link = 'LazyReasonCmd' },
                LazyReasonSource = { link = 'LazyReasonCmd' },
                LazyReasonStart = { link = 'LazyReasonCmd' },
                LazySpecial = { fg = darken(c.sapphire, 0.9, c.base) },
                LazyButtonActive = { fg = c.base, bg = darken(c.sapphire, 0.9, c.base) },
                LazyH1 = { link = 'LazyButtonActive' },
                LazyLocal = { fg = c.maroon },
                YankyYanked = { link = 'Visual' },
                YankyPut = { link = 'YankyYanked' },
                ScrollbarHandle = { fg = c.surface1, bg = c.base },
                ScrollbarError = { fg = c.red, bg = c.base },
                ScrollbarErrorHandle = { fg = c.red, bg = c.surface0 },
                ScrollbarWarn = { fg = c.peach, bg = c.base },
                ScrollbarWarnHandle = { fg = c.peach, bg = c.surface0 },
                ScrollbarHint = { fg = c.yellow, bg = c.base },
                ScrollbarHintHandle = { fg = c.yellow, bg = c.surface0 },
                ScrollbarInfo = { fg = c.blue, bg = c.base },
                ScrollbarInfoHandle = { fg = c.blue, bg = c.surface0 },
                NvimTreeNormal = { bg = c.base },
                NvimTreeWinSeparator = { link = 'WinSeparator' },
                NvimTreeIndentMarker = { fg = c.surface0 },
                NvimTreeRootFolder = { fg = c.lavender },
                NvimTreeEndOfBuffer = { fg = c.mantle },
            }
        end,
        integrations = {
            alpha = false,
            cmp = true,
            flash = false,
            gitsigns = false,
            indent_blankline = false,
            markdown = true,
            mason = true,
            native_lsp = false,
            nvimtree = false,
            semantic_tokens = true,
            telescope = false,
            treesitter = true,
            dashboard = false,
            dropbar = false,
            illuminate = false,
            neogit = false,
            rainbow_delimiters = false,
            ufo = false,
        }
    },
    config = function(_, opts)
        require 'catppuccin'.setup(opts)
        if vim.g.theme_spec.plugin == 'catppuccin' then
            vim.cmd.colorscheme(vim.g.theme_spec.theme)
        end
    end
})

return M
