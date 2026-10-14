return {
    'tamton-aquib/duck.nvim',
    enabled = true,
    keys = {
        {
            '<Leader>+',
            function()
                -- Hatch a duck without winborder
                local winborder = vim.o.winborder
                vim.o.winborder = ''
                require('duck').hatch()
                vim.o.winborder = winborder
            end,
            desc = 'which_key_ignore',
        },
        {
            '<Leader>-',
            function() require('duck').cook() end,
            desc = 'which_key_ignore',
        },
    }
}
