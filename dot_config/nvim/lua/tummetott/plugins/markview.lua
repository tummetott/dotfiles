local heading = {
    style = 'label',
    icon = function(_, item)
        return item.marker .. ' '
    end,
    padding_left = ' ',
    padding_right = ' ',
    sign = '',
}

return {
    'OXY2DEV/markview.nvim',
    enabled = true,
    lazy = false,
    opts = function()
        local presets = require('markview.presets')
        return {
            markdown = {
                headings = {
                    shift_width = 0,
                    heading_1 = heading,
                    heading_2 = heading,
                    heading_3 = heading,
                    heading_4 = heading,
                    heading_5 = heading,
                    heading_6 = heading,
                },
                code_blocks = {
                    sign = false,
                },
                tables = {
                    parts = {
                        align_left = '─',
                        align_right = '─',
                        align_center = { '─', '─' },
                    },
                },
                horizontal_rules = presets.horizontal_rules.thin,
                block_quotes = presets.block_quotes.obsidian,
            },
            yaml = {
                properties = {
                    data_types = {
                        text = { text = '󰦨 ', hl = 'MarkviewIcon4' },
                    },
                },
            },
        }
    end,
    highlights = {
        MarkviewCode = { bg = 'darkest_gray' },
        MarkviewInlineCode = { link = 'MarkviewCode' },
        MarkviewHeading1 = { fg = 'blue', bg = 'darkest_gray' },
        MarkviewHeading2 = { link = 'MarkviewHeading1' },
        MarkviewHeading3 = { link = 'MarkviewHeading1' },
        MarkviewHeading4 = { link = 'MarkviewHeading1' },
        MarkviewHeading5 = { link = 'MarkviewHeading1' },
        MarkviewHeading6 = { link = 'MarkviewHeading1' },
        MarkviewPalette1 = { fg = 'foreground', bg = { darken = 'red', amount = 0.85 } },
        MarkviewPalette2 = { fg = 'foreground', bg = { darken = 'orange', amount = 0.85 } },
        MarkviewPalette3 = { fg = 'foreground', bg = { darken = 'yellow', amount = 0.85 } },
        MarkviewPalette4 = { fg = 'foreground', bg = { darken = 'green', amount = 0.85 } },
        MarkviewPalette5 = { fg = 'foreground', bg = { darken = 'blue', amount = 0.85 } },
        MarkviewPalette1Fg = { fg = 'red' },
        MarkviewPalette2Fg = { fg = 'orange' },
        MarkviewPalette3Fg = { fg = 'yellow' },
        MarkviewPalette4Fg = { fg = 'green' },
        MarkviewPalette5Fg = { fg = 'blue' },
        MarkviewPalette6Fg = { fg = 'purple' },
    }
}
