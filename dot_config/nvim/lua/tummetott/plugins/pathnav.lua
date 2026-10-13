return {
    'tummetott/pathnav.nvim',
    enabled = true,
    -- ISSUE: Currently not lazy loaded because of
    -- https://github.com/folke/lazy.nvim/issues/2136
    lazy = false,
    ---@type pathnav.ConfigOptions
    opts = {
        highlight = {
            hlgroup = 'PathnavReferenceText',
            clear_events = { 'CursorMoved' },
        },
        target_tabpage = {
            order = vim.api.nvim_list_tabpages,
            exclude = function(tab)
                return vim.t[tab].diffview_view_initialized ~= nil
            end,
        },
        target_window = {
            exclude = {
                current = false,
                filetypes = {
                    'trouble',
                },
                buftypes = {
                    'help',
                    'prompt',
                    'quickfix',
                    'terminal',
                },
                condition = nil,
            },
            prefer = {
                matching_file = true,
                last_target = false,
            },
            split = {
                direction = 'right',
                force = false,
            },
        },
    },
    keys = {
        {
            '<C-]>',
            function()
                if require('pathnav').open() then
                    return
                end
                -- Fallback to LSP definition, whenever a server offers one.
                local clients = vim.lsp.get_clients({
                    bufnr = 0,
                    method = 'textDocument/definition',
                })
                if not vim.tbl_isempty(clients) then
                    require('trouble').open('lsp_definitions')
                    return
                end
                -- Otherwise the built in tag jump, which carries help tags
                -- and ctags.
                vim.api.nvim_feedkeys(vim.keycode('<C-]>'), 'n', false)
            end,
            desc = 'Jump to path, definition or tag',
        },
        {
            'g<C-]>',
            function()
                require('pathnav').open({
                    jump = false,
                    highlight = true,
                    target_window = { split = { force = true } },
                })
            end,
            desc = 'Open path in new split',
        },
    },
    highlights = {
        PathnavReferenceText = { bg = 'darkest_gray' },
    },
}
