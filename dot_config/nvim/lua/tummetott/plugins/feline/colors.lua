local M = {}

M.get_palette = function()
    local scheme = vim.g.colors_name
    if not scheme then return end
    local palette = {}
    if string.find(scheme, '^catppuccin') then
        local flavor = string.gsub(scheme, 'catppuccin%-', '')
        local ok, catppuccin = pcall(require, 'catppuccin.palettes')
        if ok then
            local c = catppuccin.get_palette(flavor)
            if not c then return end
            palette.fg = c.subtext0
            palette.bg = c.surface0
            palette.base = c.base
            palette.red = c.red
            palette.orange = c.peach
            palette.yellow = c.yellow
            palette.blue = c.blue
            palette.teal = c.teal
            palette.purple = c.mauve
        end
    elseif string.find(scheme, '^gruvbox%-material') then
        local conf = vim.fn['gruvbox_material#get_configuration']()
        local t = vim.fn['gruvbox_material#get_palette'] (conf.background, conf.foreground, conf.colors_override)
        palette.fg = t.grey1[1]
        palette.bg = t.bg2[1]
        palette.base = t.bg0[1]
        palette.red = t.red[1]
        palette.orange = t.orange[1]
        palette.yellow = t.yellow[1]
        palette.blue = t.blue[1]
        palette.teal = t.aqua[1]
        palette.purple = t.purple[1]
    elseif string.find(scheme, '^base16') then
        local ok, base16 = pcall(require, 'base16-colorscheme')
        if ok then
            local c = base16.colors
            palette.fg = c.base05
            palette.bg = c.base01
            palette.base = c.base00
            palette.red = c.base08
            palette.orange = c.base09
            palette.yellow = c.base0A
            palette.blue = c.base0D
            palette.teal = c.base0C
            palette.purple = c.base0E
        end
    elseif string.find(scheme, '^tokyonight') then
        local ok, tokyonight = pcall(require, 'tokyonight.colors')
        if ok then
            local c = tokyonight.setup()
            palette.fg = c.fg_dark
            palette.bg = c.bg_dark
            palette.case = c.bg
            palette.red = c.red
            palette.orange = c.orange
            palette.yellow = c.yellow
            palette.blue = c.blue
            palette.purple = c.purple
            palette.teal = c.teal
        end
    end
    return not vim.tbl_isempty(palette) and palette or nil
end

M.set_theme = function()
    local palette = M.get_palette()
    if palette then
        require('feline').use_theme(palette)
    end
end

M.setup = function()
    -- Set the theme now
    M.set_theme()

    -- Autocmd for later colorscheme changes
    vim.api.nvim_create_autocmd('ColorScheme', {
        callback = M.set_theme,
        group = vim.api.nvim_create_augroup('feline_colorscheme', {})
    })
end

return M
