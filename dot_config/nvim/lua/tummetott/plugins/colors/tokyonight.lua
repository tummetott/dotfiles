return {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- cond = function()
    --     return vim.g.theme_spec.plugin == 'tokyonight'
    -- end,
    opts = {
        styles = {
            sidebars = 'dark',
            floats = 'light',
        },
        sidebars = { 'NvimTree' },
        on_highlights = function(hl, c)
            hl.FloatBorder = { fg = c.git.ignore }
            hl.TelescopeBorder = { link = 'FloatBorder' }
            hl.WinSeparator = { fg = c.git.ignore }
            hl.ScrollbarHandle = { fg = c.black, bg = c.base }
        end
    },
    config = function(_, opts)
        require('tokyonight').setup(opts)
        if vim.g.theme_spec.plugin == 'tokyonight' then
            vim.cmd.colorscheme(vim.g.theme_spec.theme)
        end
    end,
}
