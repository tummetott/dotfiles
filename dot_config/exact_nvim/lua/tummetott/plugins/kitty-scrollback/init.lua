return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    build = function()
        local source = vim.fn.stdpath('data') .. '/lazy/kitty-scrollback.nvim'
        local target = vim.env.XDG_CONFIG_HOME .. '/kitty'
        local command = string.format("ln -s '%s' '%s'", source, target)
        os.execute(command)
    end,
    cmd = {
        'KittyScrollbackGenerateKittens',
        'KittyScrollbackCheckHealth',
    },
    event = 'User KittyScrollbackLaunch',
    version = '*',
    config = true
}
