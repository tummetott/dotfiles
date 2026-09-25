vim.pack.add { "https://github.com/folke/lazy.nvim" }

require('lazy').setup {
    spec = {
        -- Setup manages non-plugin configuration: options, events, autocmds,
        -- and keymaps. Import it through lazy so the overall startup time can
        -- be measured realiably by lazy.
        { import = 'tummetott.core.setup' },
        -- Each plugin specification is organized in a separate file. Here we
        -- define the path to the parent directory
        { import = 'tummetott.plugins' },
    },
    ui = {
        wrap = false,
        border = 'rounded',
        backdrop = 100,
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
    headless = {
        -- Headless syncs (e.g. the Homebrew postinstall hook) should be as
        -- silent as possible
        colors = false,
        process = false,
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
                'matchparen', -- handled by blink.pairs
            },
        },
    },
}
