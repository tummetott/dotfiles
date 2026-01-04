local function overwrite()
    local c = require('base16-colorscheme').colors
    if not c then return end
    local highlights = {
        ['LineNr'] = { link = 'Comment' },
        ['FloatBorder'] = { fg = c.base03 },
        ['WinSeparator'] = { link = 'FloatBorder' },
        ['Whitespace'] = { fg = c.base01 },
        ['Visual'] = { bg = c.base01 },
        ['MatchParen'] = { link = 'Visual' },
        ['Search'] = { fg = c.base00, bg = c.base03 },
        ['IncSearch'] = { fg = c.base00, bg = c.base09 },
        ['FlashLabel'] = { fg = c.base03, bg = c.base01 },
        ['EndOfBuffer'] = { fg = c.base00 },
        ['CursorLine'] = { bg = c.base01 },
        ['CursorLineNr'] = { fg = c.base05, bold = true },
        ['Folded'] = { fg = c.base03 },
        ['FoldColumn'] = { link = 'LineNr' },
        ['NonText'] = { link = 'Whitespace' },
        ['PmenuThumb'] = { bg = c.base02 },
        ['DiagnosticWarn'] = { fg = c.base09 },
        ['DiagnosticHint'] = { fg = c.base0A },
        ['DiagnosticInfo'] = { fg = c.base0D },
        ['LspReferenceRead'] = { bg = c.base02 },
        ['LspReferenceWrite'] = { bg = c.base02 },
        ['LspReferenceText'] = {},
        ['LspInfoBorder'] = { link = 'FloatBorder' },
        ['LspSignatureActiveParameter'] = { link = 'Visual' },
        ['DiffAdd'] = { fg = c.base03, bg = c.base01 },
        ['DiffText'] = { link = 'DiffAdd' },
        ['DiffChange'] = {},
        ['DiffDelete'] = { fg = c.base01, bg = c.base00 },
        ['DiffColorAdd'] = { fg = c.base05, bg = '#3b6a3e' },
        ['DiffColorDelete'] = { fg = c.base05, bg = '#864a43' },
        ['DiffVisual'] = { bg = c.base02 },
        ['StatusLine'] = {},
        ['WinBar'] = {},
        ['WinBarNC'] = {},
        ['TabbyTab'] = { fg = c.base00, bg = c.base02 },
        ['TabbyTabCurrent'] = { fg = c.base00, bg = c.base0D },
        ['TabbyBackground'] = { bg = c.base00 },
        ['DiffviewFilePanelTitle'] = { link = 'Title' },
        ['DiffviewFilePanelFileName'] = { link = 'Normal' },
        ['DiffviewFilePanelPath'] = { link = 'Normal' },
        ['DiffviewFilePanelRootPath'] = { link = 'SpecialKey' },
        ['DiffviewFilePanelCounter'] = { link = 'NonText' },
        ['DiffviewSecondary'] = { link = 'Conditional' },
        ['WhichKeyDesc'] = { fg = c.base0C },
        ['GitSignsAdd'] = { link = 'String' },
        ['GitSignsChange'] = { link = 'Conditional' },
        ['NvimTreeRootFolder'] = { fg = c.base0C },
        ['NvimTreeGitDirty'] = { fg = c.base08 },
        ['NvimTreeGitStaged'] = { fg = c.base0B },
        ['NvimTreeGitRenamed'] = { link = 'NvimTreeGitStaged' },
        ['NvimTreeGitMerge'] = { link = 'NvimTreeGitStaged' },
        ['NvimTreeNormal'] = { bg = c.base00 },
        ['NvimTreeEndOfBuffer'] = { fg = c.base00, bg = c.base00 },
        ['NvimTreeWinSeparator'] = { link = 'WinSeparator' },
        ['NvimTreeSymlink'] = {},
        ['NvimTreeExecFile'] = {},
        ['NvimTreeImageFile'] = {},
        ['NvimTreeCursorLine'] = { bg = c.base02 },
        ['SnacksDashboardHeader'] = { fg = c.base0D },
        ['SnacksDashboardFooter'] = { fg = c.base04 },
        ['TelescopeBorder'] = { link = 'FloatBorder' },
        ['TelescopeTitle'] = { fg = c.base0D },
        ['TroubleIndent'] = { link = 'Whitespace' },
        ['TroubleText'] = { fg = c.base05 },
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
        ['ScrollbarHandle'] = { fg = c.base02, bg = c.base00 },
        ['ScrollbarCursorHandle'] = { fg = c.base05, bg = c.base01 },
        ['ScrollbarError'] = { fg = c.base08, bg = c.base00 },
        ['ScrollbarErrorHandle'] = { fg = c.base08, bg = c.base01 },
        ['ScrollbarWarn'] = { fg = c.base09, bg = c.base00 },
        ['ScrollbarWarnHandle'] = { fg = c.base09, bg = c.base01 },
        ['ScrollbarHint'] = { fg = c.base0A, bg = c.base00 },
        ['ScrollbarHintHandle'] = { fg = c.base0A, bg = c.base01 },
        ['ScrollbarInfo'] = { fg = c.base0D, bg = c.base00 },
        ['ScrollbarInfoHandle'] = { fg = c.base0D, bg = c.base01 },
        ['YankyYanked'] = { link = 'Visual' },
        ['YankyPut'] = { link = 'Visual' },
    }
    for group, setting in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, setting)
    end
end

return {
    'RRethy/nvim-base16',
    enabled = true,
    priority = 1000,
    -- cond = function()
    --     return vim.g.theme_spec.plugin == 'base16'
    -- end,
    config = function()
        require('base16-colorscheme').with_config({
            telescope = false,
            indentblankline = false,
            cmp = false,
        })
        -- Whenever the colorscheme changes, apply my overwrites
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup('base16_overwrites', {}),
            callback = function(ctx)
                if string.find(ctx.match, '^base16%-') then
                    overwrite()
                end
            end,
        })
        if vim.g.theme_spec.plugin == 'base16' then
            vim.cmd.colorscheme(vim.g.theme_spec.theme)
        end
    end,
}
