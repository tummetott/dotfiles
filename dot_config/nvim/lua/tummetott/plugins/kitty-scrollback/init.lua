return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    cmd = {
        'KittyScrollbackGenerateKittens',
        'KittyScrollbackCheckHealth',
    },
    event = 'User KittyScrollbackLaunch',
    version = '*',
    config = true
}
