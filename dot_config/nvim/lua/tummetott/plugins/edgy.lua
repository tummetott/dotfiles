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
            ['<c-q>'] = false,
        },
        icons = {
            closed = vim.g.nerdfonts and ' ' or '> ',
            open = vim.g.nerdfonts and ' ' or 'v ',
        },
        bottom = {
            {
                title = 'HELP',
                ft = 'help',
                size = { height = 0.4 },
                wo = {
                    scrolloff = 1,
                },
                -- only show help buffers
                filter = function(buf)
                    return vim.bo[buf].buftype == 'help'
                end,
            },
            -- {
            --     title = 'TERMINAL',
            --     ft = '',
            --     filter = function(buf, win)
            --         return vim.bo[buf].buftype == 'terminal'
            --     end
            -- },
            {
                title = 'NATIVE QUICKFIX',
                filter = function(_, win)
                    return vim.fn.getwininfo(win)[1]['loclist'] ~= 1
                end,
                ft = 'qf',
            },
            {
                title = 'NATIVE LOCLIST',
                filter = function(_, win)
                    return vim.fn.getwininfo(win)[1]['loclist'] == 1
                end,
                ft = 'qf',
            },
            -- TODO: make PR to add buf and win to the title function call
            -- {
            --     title = function(_, win)
            --         local mode = vim.w[win].trouble.mode
            --         return mode == 'quickfix' and 'QUICKFIX'
            --             or mode == 'loclist' and 'LOCLIST'
            --             or mode == 'telescope' and 'TELESCOPE'
            --             or mode == 'telescope_files' and 'TELESCOPE'
            --             or mode == 'diagnostics' and 'DIAGNOSTICS'
            --             or mode == 'lsp_definitions' and 'DEFINITIONS'
            --             or mode == 'lsp_type_definitions' and 'TYPE DEFINITIONS'
            --             or mode == 'lsp_references' and 'REFERENCES'
            --             or mode == 'lsp_implementations' and 'IMPLEMENTATIONS'
            --             or mode == 'lsp_declarations' and 'DECLARATIONS'
            --             or mode == 'todo' and 'TODOS'
            --             or 'TROUBLE'
            --     end,
            --     ft = 'trouble',
            -- },
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
            {
                title = 'DIFFVIEW FILES',
                ft = 'DiffviewFiles',
            },
            {
                title = 'DIFFVIEW HISTORY',
                ft = 'DiffviewFileHistory',
                filter = function(buf)
                    local bufname = vim.fn.bufname(buf)
                    local match = 'DiffviewFileHistoryPanel'
                    if bufname then
                        return bufname:sub(-#match) == match
                    end
                end,
            },
            {
                title = 'DIFFVIEW HISTORY OPTIONS',
                ft = 'DiffviewFileHistory',
                filter = function(buf)
                    local bufname = vim.fn.bufname(buf)
                    local match = 'DiffviewFHOptionPanel'
                    if bufname then
                        return bufname:sub(-#match) == match
                    end
                end,
            },
            {
                title = 'MANPAGE',
                ft = 'man',
            },
        },
        left = {
            {
                ft = 'NvimTree',
                wo = {
                    winbar = false
                },
                open = 'NvimTreeOpen',
            },
        },
    },
    keys = {
        { -- Enlarge the edgy window by a hard coded factor
            '<c-;>',
            function()
                local win, cursor
                local ids = vim.api.nvim_list_wins()
                for _, id in ipairs(ids) do
                    win = require('edgy').get_win(id)
                    if win then break end
                end
                if not win then return end
                local cur_win = vim.api.nvim_get_current_win()
                if cur_win == win.win then
                    cursor = vim.api.nvim_win_get_cursor(win.win)
                end
                local vert = win.view.edgebar.vertical
                local dim = vert and 'width' or 'height'
                local max = vert and vim.o.columns or vim.o.lines
                local curr = win[dim]
                -- Hardcoded factors to determine how much the window should be
                -- enlarged
                local factor = vert and 0.4 or 0.7
                if curr < math.floor(max * factor) then
                    local new = math.floor(max * factor)
                    vim.w[win.win]['edgy_' .. dim] = new
                    require('edgy.layout').update()
                else
                    win.view.edgebar:equalize()
                end
                if cursor then
                    vim.api.nvim_win_set_cursor(win.win, cursor)
                end
            end,
            desc = 'Enlarge or shrink edgy window',
        },
        {
            '<c-q>',
            function() require('edgy').close() end,
            desc = 'Close edgy window',
        }
    },
}
