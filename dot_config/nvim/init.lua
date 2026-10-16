local version = '0.12'
if vim.fn.has('nvim-' .. version) ~= 1 then
    print('NVIM version ' .. version .. ' or newer is required for this config!')
    return
end

-- Detect if nerdfonts are disabled.
vim.g.nerdfonts = vim.env.NO_NERDFONTS == nil

require('tummetott.options')
require('tummetott.pack')
require('tummetott.autocmds')
require('tummetott.commands')
require('tummetott.lazy')
