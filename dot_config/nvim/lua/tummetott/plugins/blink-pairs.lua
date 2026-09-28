return {
    'saghen/blink.pairs',
    enabled = true,
    event = 'VeryLazy',
    version = '*', -- required with prebuilt binaries
    -- download prebuilt binaries from github releases
    dependencies = 'saghen/blink.lib',
    build = function()
        require('blink.pairs').download():pwait(60000)
    end,

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
        mappings = {
            -- blink.pairs provides autopair functionallity by defining inster
            -- mode keymaps for all trigger chars. So the following should be
            -- enabled
            enabled = true,
            cmdline = true,
            disabled_filetypes = {
                'TelescopePrompt',
            },
            -- Extend default rules
            pairs = {},
            -- The default <C-b> and <C-S-b> wrap mappings shadow the readline
            -- style cursor movement keymaps. I dont use the feature anyways
            wrap = {
                ['<C-b>'] = false,
                ['<C-S-b>'] = false,
            },
        },
        highlights = {
            enabled = true,
            -- needs the plugin's vim._extui integration, absent in nvim 0.12
            cmdline = false,
            -- Swap in the commented groups to enable rainbow
            groups = {
                'BlinkPairs',
                -- 'BlinkPairsOrange',
                -- 'BlinkPairsPurple',
                -- 'BlinkPairsBlue',
            },
            unmatched_group = 'BlinkPairsUnmatched',

            -- highlights matching pairs under the cursor
            matchparen = {
                enabled = true,
                -- known issue where typing won't update matchparen highlight, disabled by default
                cmdline = false,
                -- also include pairs not on top of the cursor, but surrounding the cursor
                include_surrounding = false,
                group = 'BlinkPairsMatchParen',
                priority = 250,
            },
        },
        debug = false,
    },
    highlights = {
        BlinkPairsUnmatched = { bg = 'red' },
    }
}
