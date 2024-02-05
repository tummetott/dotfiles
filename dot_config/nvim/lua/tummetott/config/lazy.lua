-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    spec = {
        -- Due to the absence of a callback function in lazy that triggers after
        -- lazy initialization but before plugins are loaded, a workaround is
        -- employed. A Lua module is passed to lazy, returning a dummy plugin
        -- specification (representing lazy itself). This module acts as the
        -- desired callback.
        { import = 'tummetott.core.setup' },
        -- Each plugin specification is organized in a separate file. Here we
        -- define the path to the parent directory
		{ import = 'tummetott.plugins' },
	},
    ui = {
        border = 'rounded',
        icons = {
            cmd = vim.g.nerdfonts and ' ' or '',
            config = vim.g.nerdfonts and '' or '',
            event = vim.g.nerdfonts and '' or '',
            ft = vim.g.nerdfonts and ' ' or '',
            init = vim.g.nerdfonts and ' ' or '',
            import = vim.g.nerdfonts and ' ' or '',
            keys = vim.g.nerdfonts and ' ' or '',
            lazy = vim.g.nerdfonts and '󰒲 ' or '',
            loaded = vim.g.nerdfonts and '●' or '*',
            not_loaded = vim.g.nerdfonts and '○' or 'o',
            plugin = vim.g.nerdfonts and ' ' or '',
            runtime = vim.g.nerdfonts and ' ' or '',
            require = vim.g.nerdfonts and '󰢱 ' or '',
            source = vim.g.nerdfonts and ' ' or '',
            start = vim.g.nerdfonts and ' ' or '',
            task = vim.g.nerdfonts and '✔ ' or '',
            list = {
                '●',
                '➜',
                '★',
                '‒',
            },
        },
    },
    change_detection = {
        notify = false,
    },
    dev = {
        -- Directory where you store your local plugin projects
        path = '~/Projects',
        -- Plugins that match these patterns will use your local versions
        -- instead of being fetched from GitHub
        patterns = { 'tummetott' },
        -- Fallback to git when local plugin doesn't exist
        fallback = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },

}
