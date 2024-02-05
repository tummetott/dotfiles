-- Options must be loaded before plugins
require('tummetott.config.options')

-- Setup additional lazy events like LazyFile and LazySearch
require('tummetott.core.events')

-- Autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
    require('tummetott.config.autocmds')
end

-- Lazy load my keymaps and (if not already loaded) my autocmds
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        if lazy_autocmds then
            require('tummetott.config.autocmds')
        end
        require('tummetott.config.keymaps')
        return true
    end,
})

-- Set global variables
if vim.env.NO_NERDFONTS then
    vim.g.nerdfonts = false
else
    vim.g.nerdfonts = true
end

-- Return a dummy plugin spec representing lazy itself
return { 'folke/lazy.nvim', version = '*' }
