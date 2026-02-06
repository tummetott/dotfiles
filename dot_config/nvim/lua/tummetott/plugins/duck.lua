return {
    'tamton-aquib/duck.nvim',
    enabled = true,
    keys = {
        {
            '<Leader>=',
            function() require('duck').hatch() end,
            desc = 'More ducks!',
        },
        {
            '<Leader>-',
            function() require('duck').cook() end,
            desc = 'Less ducks!',
        },
    }
}
