local M = {}

-- Determine the colorscheme of the shell and create a theme spec. This spec is
-- used by colorscheme plugins to decide whether to load the plugin or not
local theme_file = vim.fn.expand('$BASE16_CONFIG_PATH/theme_name')
if vim.fn.filereadable(theme_file) == 1 then
    local theme = vim.fn.readfile(theme_file)[1]
    if string.find(theme, '^catppuccin') then
        vim.g.theme_spec = {
            plugin = 'catppuccin',
            theme = theme
        }
    elseif string.find(theme, '^tokyo%-night.*storm$') then
        vim.g.theme_spec = {
            plugin = 'tokyonight',
            theme = 'tokyonight-storm'
        }
    elseif string.find(theme, '^gruvbox%-material%-dark%-medium') then
        vim.g.theme_spec = {
            plugin = 'gruvbox',
            theme = 'gruvbox-material'
        }
    else
        vim.g.theme_spec = {
            plugin = 'base16',
            theme = 'base16-' .. theme,
        }
    end
else
    -- Default theme
    vim.g.theme_spec = {
        plugin = 'catppuccin',
        theme = 'catppuccin-frappe'
    }
end

-- Include all colorscheme plugin specs in this module. This is essential as
-- Lazy only scans for plugins at the top level of the plugin directory.
local dir = vim.fn.stdpath('config') .. '/lua/tummetott/plugins/colors'
local files = vim.fn.readdir(dir)
for _, file in ipairs(files) do
    if file ~= 'init.lua' then
        file = vim.fn.fnamemodify(file, ':r')
        table.insert(M, require('tummetott.plugins.colors.' .. file))
    end
end

return M
