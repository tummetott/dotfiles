-- Increment and decrement numbers / dates / case / semver etc
return {
    'monaqa/dial.nvim',
    enabled = true,
    config = function()
        local augend = require('dial.augend')
        require('dial.config').augends:register_group {
            default = {
                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.integer.alias.octal,
                augend.integer.alias.binary,
                augend.date.alias['%Y/%m/%d'],
                augend.constant.alias.de_weekday,
                augend.constant.alias.de_weekday_full,
                augend.constant.alias.bool,
                augend.semver.alias.semver,
                augend.constant.new {
                    elements = { 'and', 'or' },
                    word = true,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { 'on', 'off' },
                    word = true,
                    cyclic = true,
                }
            },
        }
    end,
    keys = {
        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'normal')
            end,
            desc = 'Increment'
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'normal')
            end,
            desc = 'Decrement',
        },
        -- The g-prefixed normal mode commands differ in behavior only when
        -- repeated with '.'
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gnormal')
            end,
            desc = 'Sequential increment',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gnormal')
            end,
            desc = 'Sequential decrement',
        },
        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'visual')
            end,
            mode = 'x',
            desc = 'Increment'
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'visual')
            end,
            mode = 'x',
            desc = 'Decrement',
        },
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gvisual')
            end,
            mode = 'x',
            desc = 'Sequential increment',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gvisual')
            end,
            mode = 'x',
            desc = 'Sequential decrement',
        },
    }
}
