-- TODO: remove once this is fixed: https://github.com/folke/trouble.nvim/issues/681
return {
    'folke/edgy.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        animate = { enabled = false },
        exit_when_last = true,
        close_when_all_hidden = false,
        fix_win_height = vim.fn.has('nvim-0.10.0') == 0,
        keys = {
            ['<C-=>'] = function(win)
                local vert = win.view.edgebar.vertical
                local dim = vert and "width" or "height"
                local max = vert and vim.o.columns or vim.o.lines
                local delta = math.floor(max * 0.2)

                local curr = win[dim]
                local new = math.min(curr + delta, max)

                vim.w[win.win]["edgy_" .. dim] = new
                require("edgy.layout").update()
            end,

            ['<C-->'] = function(win)
                local vert = win.view.edgebar.vertical
                local dim = vert and "width" or "height"
                local max = vert and vim.o.columns or vim.o.lines
                local delta = math.floor(max * 0.2)

                local curr = win[dim]
                local new = math.max(curr - delta, 10)

                vim.w[win.win]["edgy_" .. dim] = new
                require("edgy.layout").update()
            end,
        },
        icons = {
            closed = vim.g.nerdfonts and ' ' or '> ',
            open = vim.g.nerdfonts and ' ' or 'v ',
        },
        bottom = {
            {
                title = 'QUICKFIX',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'quickfix'
                end,
                ft = 'trouble',
            },
            {
                title = 'LOCLIST',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'loclist'
                end,
                ft = 'trouble',
            },
            {
                title = 'TELESCOPE',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'telescope'
                        or vim.w[win].trouble.mode == 'telescope_files'
                end,
                ft = 'trouble',
            },
            {
                title = 'DIAGNOSTICS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'diagnostics'
                end,
                ft = 'trouble',
            },
            {
                title = 'DEFINITIONS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'lsp_definitions'
                end,
                ft = 'trouble',
            },
            {
                title = 'TYPE DEFINITIONS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'lsp_type_definitions'
                end,
                ft = 'trouble',
            },
            {
                title = 'REFERENCES',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'lsp_references'
                end,
                ft = 'trouble',
            },
            {
                title = 'IMPLEMENTATIONS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'lsp_implementations'
                end,
                ft = 'trouble',
            },
            {
                title = 'DECLARATIONS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'lsp_declarations'
                end,
                ft = 'trouble',
            },
            {
                title = 'TODOS',
                filter = function(_, win)
                    return vim.w[win].trouble.mode == 'todo'
                end,
                ft = 'trouble',
            },
        },
    },
}
