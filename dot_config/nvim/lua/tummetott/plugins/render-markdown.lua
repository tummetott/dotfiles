return {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    ft = 'markdown',
    opts = {
        heading = {
            sign = false,
            -- The marker itself serves as the icon
            icons = function(ctx) return ('#'):rep(ctx.level) .. ' ' end,
            position = 'inline',
            width = 'block',
            left_pad = 1,
            right_pad = 1,
            -- A single entry applies to every level
            backgrounds = { 'RenderMarkdownH1Bg' },
            foregrounds = { 'RenderMarkdownH1' },
        },
        code = {
            sign = false,
            position = 'right',
            right_pad = 0.999, -- hack to right align to the screen
            -- One colour for every language label, whatever the icon provider sets
            highlight_language = 'RenderMarkdownCodeFallback',
        },
        pipe_table = {
            alignment_indicator = '─',
        },
    },
    highlights = {
        RenderMarkdownCode = { bg = 'darkest_gray' },
        RenderMarkdownCodeFallback = { fg = 'bright_gray' },
        RenderMarkdownH1 = { fg = 'blue' },
        RenderMarkdownH1Bg = { fg = 'blue', bg = 'darkest_gray' },
    },
}
