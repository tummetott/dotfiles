-- ISSUE: error in matchparen plugin when in lua block comments
-- ISSUE: dont autocomplete in cmdline search mode
return {
    'saghen/blink.pairs',
    enabled = true,
    version = '*', -- required with prebuilt binaries
    -- download prebuilt binaries from github releases
    dependencies = 'saghen/blink.download',

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
        mappings = {
            -- blink.pairs provides autopair functionallity by defining inster
            -- mode keymaps for all trigger chars. So the following should be
            -- enabled
            enabled = true,
            cmdline = true,
            disabled_filetypes = {},
            -- Extend default rules
            pairs = {},
        },
        highlights = {
            enabled = true,
            -- requires require('vim._extui').enable({}), otherwise has no effect
            cmdline = false,
            -- Rotating colors by nesting depth. These groups are not defined by
            -- default as I dont use this feature
            groups = {
                'BlinkPairsOrange',
                'BlinkPairsPurple',
                'BlinkPairsBlue',
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
        BlinkPairsUnmatched = { bg = 'red' }
    }
}
