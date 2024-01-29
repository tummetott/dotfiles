return {
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    opts = {
        indent = {
            char = '│',
        },
        scope = {
            enabled = false,
            show_start = false,
            show_end = false,
        },
    },
    config = function(_, opts)
        -- Disable indentation guides in diff mode
        vim.api.nvim_create_autocmd('OptionSet', {
            pattern = 'diff',
            group = vim.api.nvim_create_augroup('DisableIndentGuidesDiff', {}),
            callback = function()
                local wins = vim.api.nvim_list_wins()
                for _, win in ipairs(wins) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    local diff = vim.api.nvim_get_option_value('diff', { win = win })
                    require 'ibl'.setup_buffer(buf, { enabled = not diff })
                end
            end,
        })
        require('ibl').setup(opts)
    end,
    event = 'LazyFile',
    keys = {
        {
            'yoe',
            '<cmd>IBLToggle<CR>',
            desc = 'Toggle indentation guides',
        },
        {
            '[oe',
            '<cmd>IBLEnable<CR>',
            desc = 'Enable indentation guides',
        },
        {
            ']oe',
            '<cmd>IBLDisable<CR>',
            desc = 'Disable indentation guides',
        },
        {
            'yop',
            '<cmd>IBLToggleScope<cr>',
            desc = 'Toggle scope guides'
        },
        {
            '[op',
            '<cmd>IBLEnableScope<cr>',
            desc = 'Enable scope guides',
        },
        {
            ']op',
            '<cmd>IBLDisableScope<cr>',
            desc = 'Disable scope guides',
        },
    },
}
