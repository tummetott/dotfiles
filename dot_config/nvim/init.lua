local version = '0.11'
if vim.fn.has('nvim-' .. version) ~= 1 then
    print('NVIM version ' .. version .. ' or newer is required for this config!')
    return
end

-- Detect if nerdfonts are disabled.
if vim.env.NO_NERDFONTS then
    vim.g.nerdfonts = false
else
    vim.g.nerdfonts = true
end

-- Run the plugin manager lazy.nvim
require('tummetott.config.lazy')
