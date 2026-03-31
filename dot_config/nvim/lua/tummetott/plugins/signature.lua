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
    },
    config = function(_, opts)
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end

                if client.server_capabilities.signatureHelpProvider then
                    require('lsp-overloads').setup(client, opts)
                end
            end,
        })
    end,
}
