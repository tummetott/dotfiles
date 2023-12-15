local M = {}

local get_palette = function()
    local palette = {}
    local conf = vim.fn['gruvbox_material#get_configuration']()
    local table = vim.fn['gruvbox_material#get_palette'] (conf.background, conf.foreground, conf.colors_override)
    for key, value in pairs(table) do
        palette[key] = value[1]
    end
    return palette
end

local overwrites = function()
    local c = get_palette()
    local darken = require 'catppuccin.utils.colors'.darken
    local highlights = {
        ['Comment'] = { fg = c.grey0 },
        ['Search'] = { fg = c.bg0, bg = c.grey1 },
        ['IncSearch'] = { fg = c.bg0, bg = c.orange },
        -- ['FlashLabel'] = { fg = c.base03, bg = c.base01 },
        ['EndOfBuffer'] = { fg = c.bg0 },
        ['CursorLine'] = { bg = c.bg1 },
        ['CursorLineNr'] = { fg = c.grey2, bold = true },
        ['Folded'] = { fg = c.grey1, bg = c.bg },
        ['Whitespace'] = { fg = c.bg3 },
        ['NonText'] = { link = 'Whitespace' },
        ['NormalFloat'] = { link = 'Normal' },
        ['FloatBorder'] = { fg = c.bg5 },
        ['PmenuThumb'] = { bg = c.bg3 },
        ['Visual'] = { bg = c.bg3 },
        ['DiagnosticWarn'] = { fg = c.orange },
        ['DiagnosticHint'] = { fg = c.yellow },
        ['DiagnosticInfo'] = { fg = c.blue },
        -- ['LspReferenceRead'] = { bg = c.base02 },
        -- ['LspReferenceWrite'] = { bg = c.base02 },
        -- ['LspReferenceText'] = {},
        ['LspSignatureActiveParameter'] = { link = 'Visual' },
        ['DiffAdd'] = { fg = c.grey1, bg = c.bg1 },
        ['DiffText'] = { link = 'DiffAdd' },
        ['DiffChange'] = {},
        ['DiffDelete'] = { fg = c.bg1, bg = c.bg0 },
        ['DiffColorAdd'] = { bg = darken(c.aqua, 0.4, '#000000') },
        ['DiffColorDelete'] = { bg = darken(c.red, 0.4, '#000000') },
        ['DiffVisual'] = { bg = c.base02 },
        ['StatusLine'] = {},
        ['WinBar'] = {},
        ['WinBarNC'] = {},
        ['TabLineFill'] = {},
        ['TabbyTab'] = { fg = c.bg5, bg = c.bg0 },
        -- TODO: add missing cmp highlights
        ['CmpItemAbbr'] = { fg = c.fg0 }, -- item
        ['CmpItemMenu'] = { fg = c.bg3 }, -- source
        ['CmpItemAbbrMatch'] = { fg = c.blue },
        ['CmpItemAbbrMatchFuzzy'] = { fg = c.blue },
        -- ['DiffviewFilePanelTitle'] = { link = 'Title' },
        -- ['DiffviewFilePanelFileName'] = { link = 'Normal' },
        -- ['DiffviewFilePanelPath'] = { link = 'Normal' },
        -- ['DiffviewFilePanelRootPath'] = { link = 'SpecialKey' },
        -- ['DiffviewFilePanelCounter'] = { link = 'NonText' },
        -- ['DiffviewSecondary'] = { link = 'Conditional' },
        ['WhichKey'] = { fg = c.blue },
        ['WhichKeyDesc'] = { fg = c.aqua },
        ['WhichKeyGroup'] = { fg = c.purple },
        ['NvimTreeFolderName'] = { fg = c.blue },
        ['NvimTreeRootFolder'] = { fg = c.purple },
        ['NvimTreeGitDirty'] = { fg = c.red },
        ['NvimTreeGitStaged'] = { fg = c.aqua },
        ['NvimTreeGitRenamed'] = { link = 'NvimTreeGitStaged' },
        ['NvimTreeGitMerge'] = { link = 'NvimTreeGitStaged' },
        ['NvimTreeNormal'] = { bg = c.bg0 },
        ['NvimTreeEndOfBuffer'] = { fg = c.bg0 },
        ['NvimTreeWinSeparator'] = { link = 'WinSeparator' },
        ['NvimTreeSymlink'] = {},
        ['NvimTreeExecFile'] = {},
        ['NvimTreeImageFile'] = {},
        ['NvimTreeCursorLine'] = { link = 'CursorLine' },
        ['NvimTreeIndentMarker'] = { link = 'IblIndent' },
        ['AlphaHeader'] = { fg = c.blue },
        ['AlphaFooter'] = { fg = c.grey1 },
        ['TelescopeSelection'] = { link = 'CursorLine' },
        ['TelescopeMatching'] = { fg = c.blue },
        ['TelescopeBorder'] = { link = 'FloatBorder' },
        ['TelescopeTitle'] = { fg = c.blue },
        -- TODO: Trouble Winbar?
        ['TroubleIndent'] = { link = 'Whitespace' },
        ['LazyReasonCmd'] = { fg = c.base02 },
        ['LazyReasonEvent'] = { link = 'LazyReasonCmd' },
        ['LazyReasonFt'] = { link = 'LazyReasonCmd' },
        ['LazyReasonImport'] = { link = 'LazyReasonCmd' },
        ['LazyReasonPlugin'] = { link = 'LazyReasonCmd' },
        ['LazyReasonRequire'] = { link = 'LazyReasonCmd' },
        ['LazyReasonRuntime'] = { link = 'LazyReasonCmd' },
        ['LazyReasonSource'] = { link = 'LazyReasonCmd' },
        ['LazyReasonStart'] = { link = 'LazyReasonCmd' },
        ['LazyReasonKeys'] = { link = 'LazyReasonCmd' },
        ['ScrollbarHandle'] = { fg = c.bg_dim, bg = c.bg0 },
        ['YankyYanked'] = { link = 'Visual' },
        ['YankyPut'] = { link = 'Visual' },
        ['IblIndent'] = { fg = c.bg2 },
    }
    for group, setting in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, setting)
    end
end

table.insert(M, {
    'sainnhe/gruvbox-material',
    -- cond = function()
    --     return vim.g.theme_spec.plugin == 'gruvbox'
    -- end,
    config = function()
        -- soft / medium / hard
        vim.g.gruvbox_material_background = 'medium'
        -- material / mix / original
        vim.g.gruvbox_material_foreground = 'material'
        -- Whenever the colorscheme changes, apply my overwrites
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup('base16_overwrites', {}),
            callback = function(ctx)
                if string.find(ctx.match, '^gruvbox%-material') then
                    overwrites()
                end
            end,
        })
        if vim.g.theme_spec.plugin == 'gruvbox' then
            vim.cmd.colorscheme('gruvbox-material')
        end
    end
})

table.insert(M, {
    'tummetott/gruvbox.nvim',
    enabled = false,
    dev = true,
    config = function()
        require('gruvbox').setup({

        })
    end,
})

return M
