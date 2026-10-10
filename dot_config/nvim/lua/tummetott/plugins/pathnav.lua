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
            'gf',
            function()
                require('pathnav').open()
            end,
            desc = 'Jump to file under cursor',
        },
        {
            '<C-]>',
            function()
                -- Jump to file if it is readable
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
            '<c-[>',
            function()
                local ok, result = pcall(function()
                    return require('pathnav').open({
                        jump = false,
                        highlight = true,
                    })
                end)
                if not ok or not result then
                    require('tummetott.utils.words').show()
                end
            end,
            desc = 'Highlight reference',
        },
    },
    highlights = {
        PathnavReferenceText = { bg = 'darkest_gray' },
    },
}
