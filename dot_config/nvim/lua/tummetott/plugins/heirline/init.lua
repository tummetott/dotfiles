local colors = {}
local ok, catppuccin = pcall(require, 'catppuccin.palettes')
if ok then
    local c = catppuccin.get_palette('frappe')
    if not c then return end
    colors.fg = c.subtext0
    colors.bg = c.surface0
    colors.surface2 = c.surface2
    colors.base = c.base
    colors.red = c.red
    colors.orange = c.peach
    colors.yellow = c.yellow
    colors.blue = c.blue
    colors.teal = c.teal
    colors.purple = c.mauve
end


return {
    'rebelot/heirline.nvim',
    enabled = true,
    lazy = false,
    dependencies = 'lewis6991/gitsigns.nvim',
    config = function()
        local comp = require('tummetott.plugins.heirline.components')
        require('heirline').setup {
            statusline = comp.statusline,
            winbar = comp.winbar,
            tabline = comp.tabline,
            opts = {
                colors = colors,
                disable_winbar_cb = function(args)
                    return require('heirline.conditions').buffer_matches({
                        buftype = {
                            'nofile',
                            'prompt',
                            'help',
                            'quickfix',
                        },
                        filetype = {
                            'trouble',
                            'FTerm',
                            'help',
                            'NvimTree',
                            'man',
                            'DiffviewFiles',
                            'DiffviewFileHistory',
                            'qf',
                            'sidekick_terminal',
                        },
                    }, args.buf)
                end,
            }
        }
    end,
}
