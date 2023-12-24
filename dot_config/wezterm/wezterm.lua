local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.font_size = 17.0
config.enable_tab_bar = false
-- The default term is 'xterm-256color'
config.term = 'wezterm'
config.enable_csi_u_key_encoding = true
config.keys = {
    {
        key = 'i',
        mods = 'CTRL',
        action = wezterm.action { SendString = '\x1b[555;0~\x1b[105;5u' }
    },
    {
        key = 'm',
        mods = 'CTRL',
        action = wezterm.action { SendString = '\x1b[555;0~\x1b[109;5u' },
    },
    {
        key = '/',
        mods = 'CTRL',
        action = wezterm.action { SendString = '\x1b[47;5u' },
    },
}

return config
