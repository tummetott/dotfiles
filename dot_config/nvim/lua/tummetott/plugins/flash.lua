return {
    'folke/flash.nvim',
    enabled = true,
    event = 'LazySearch',
    opts = {
        modes = {
            char = { enabled = false },
            search = { enabled = false },
        },
        label = {
            current = true,
            before = false,
            after = true,
        },
        prompt = {
            prefix = {
                { vim.g.nerdfonts and '⚡' or '# ', 'FlashPromptIcon' },
            },
        }
    },
    config = function(_, opts)
        require('flash').setup(opts)

        -- When flash search is disabled by default, ensure it remains turned
        -- off for every search, even when enabling it on demand with a keymap.
        if not opts.modes.search.enabled then
            vim.api.nvim_create_autocmd('CmdlineEnter', {
                group = vim.api.nvim_create_augroup('FlashSearchDisable', {}),
                pattern = { '/', '\\?' },
                callback = function()
                    require 'flash'.toggle(false)
                end,
            })
        end
    end,
    keys = {
        {
            'r',
            function() require('flash').remote() end,
            mode = 'o',
            desc = 'Remote Flash',
        },
        {
            'R',
            function() require('flash').treesitter_search() end,
            mode = { 'o', 'x' },
            desc = 'Treesitter Search',
        },
        {
            '<c-j>',
            function() require('flash').toggle() end,
            mode = { 'c' },
            desc = 'Toggle Flash Search',
        },
    },
    highlights = {
        FlashLabel = { fg = 'background', bg = 'yellow', bold = true },
    }
}
