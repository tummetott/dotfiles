local version = '0.11'
if vim.fn.has('nvim-' .. version) ~= 1 then
    print('NVIM version ' .. version .. ' or newer is required for this config!')
    return
end

-- Detect if nerdfonts are disabled.
vim.env.NO_NERDFONTS = vim.g.nerdfonts ~= nil

-- Run the plugin manager lazy.nvim
require('tummetott.config.lazy')
