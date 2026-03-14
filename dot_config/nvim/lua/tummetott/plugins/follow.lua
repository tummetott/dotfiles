return {
    'tummetott/follow.nvim',
    enabled = true,
    lazy = true,
    opts = {
        highlight = {
            hlgroup = 'LspReferenceText',
            clear_events = {
                'CursorHold',
                'CursorHoldI',
                -- 'CursorMoved',
            },
        },
        open = {
            exclude = {
                current_win = false,
                filetypes = {},
                buftypes = {
                    'help',
                    'nofile',
                    'prompt',
                    'quickfix',
                    'terminal',
                },
                condition = nil,
            },
        },
    },
    keys = {
        {
            '<c-]>',
            function()
                if not require('follow').follow() then
                    return '<C-]>'
                end
            end,
            expr = true,
            desc = 'Goto file or jump to definition',
        },
        {
            '<c-[>',
            function()
                local ok = require('follow').follow({
                    jump = false,
                    highlight = true,
                })
                if not ok then
                    vim.lsp.buf.document_highlight()
                end
            end,
            desc = 'Highlight reference',
        }
    }
}
