local fallback_colors = {
    background = "#0b0e14",
    blue = "#59c2ff",
    bright_blue = "#59c2ff",
    bright_cyan = "#95e6cb",
    bright_green = "#aad94c",
    bright_grey = "#bfbdb6",
    bright_purple = "#d2a6ff",
    bright_red = "#f07178",
    bright_white = "#ece8db",
    bright_yellow = "#ffb454",
    brightest_white = "#f2f0e7",
    cyan = "#95e6cb",
    dark_grey = "#202229",
    dark_red = "#e6b450",
    darkest_grey = "#131721",
    foreground = "#e6e1cf",
    green = "#aad94c",
    grey = "#3e4b59",
    orange = "#ff8f40",
    purple = "#d2a6ff",
    red = "#f07178",
    yellow = "#ffb454"
}

return {
    'rebelot/heirline.nvim',
    enabled = true,
    lazy = false,
    dependencies = 'lewis6991/gitsigns.nvim',
    config = function()
        local comp = require('tummetott.plugins.heirline.components')
        local colors
        pcall(function() colors = require('tinted-nvim').get_palette_aliases() end)
        colors = colors or fallback_colors

        require('heirline').setup {
            statusline = comp.statusline,
            winbar = comp.winbar,
            tabline = comp.tabline,
            opts = {
                colors = colors,
                disable_winbar_cb = function(args)
                    local win = vim.fn.bufwinid(args.buf)
                    if win == -1 then
                        return false
                    end

                    -- 1. disable for floating windows
                    local cfg = vim.api.nvim_win_get_config(win)
                    if cfg.relative ~= "" then
                        return true
                    end

                    -- 2. disable for specific buffers entirely
                    return require("heirline.conditions").buffer_matches({
                        filetype = {
                            "snacks_dashboard",
                            "TelescopePrompt",
                            "TelescopeResults",
                        },
                        buftype = {
                            "prompt",
                        },
                    }, args.buf)
                end,
            }
        }
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup('HeirlineColorUpdate', { clear = true }),
            callback = function()
                colors = require('tinted-nvim').get_palette_aliases()
                if colors then
                    require('heirline.utils').on_colorscheme(colors)
                    vim.cmd('redrawstatus')
                    vim.cmd('redrawtabline')
                end
            end,
        })
    end,
}
