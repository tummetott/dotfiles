return {
    'Issafalcon/lsp-overloads.nvim',
    enabled = true,
    lazy = false,
    opts = {
        ui = {
            border = 'rounded',
            close_events = {
                'CursorMoved',
                'CursorMovedI',
                'BufHidden',
                'InsertLeave',
            },
        },
        keymaps = {
            next_signature = '<c-j>',
            previous_signature = '<c-k>',
            next_parameter = '<c-l>',
            previous_parameter = '<c-h>',
            close_signature = '<c-e>'
        },
        display_automatically = true
    }
}
