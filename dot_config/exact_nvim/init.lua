local version = '0.9'
if vim.fn.has('nvim-' .. version) ~= 1 then
    print('NVIM version ' .. version .. ' or newer is required for this config!')
    return
end

-- Run the plugin manager lazy.nvim
require('tummetott.config.lazy')
