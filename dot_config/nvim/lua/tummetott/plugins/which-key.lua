return {
    'folke/which-key.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
            },
            presets = {
                operators = true,
                motions = false,
                nav = false,
            },
        },
        key_labels = {
            ['<NL>'] = '<C-J>',
            ['<C-_>'] = '<C-/>',
            ['<C-Bslash>'] = '<C-\\>',
            ['<c-w>'] = '<C-W>',
            ['<leader>'] = '<LEADER>',
        },
        window = {
            border = 'rounded',
            padding = { 1, 1, 1, 1 },
        },
        icons = {
            breadcrumb = vim.g.nerdfonts and '»' or '>>',
            separator = vim.g.nerdfonts and '➜' or '->',
            group = '+',
        },
        show_help = false,
    },
    config = function(_, opts)
        local wk = require('which-key')
        wk.setup(opts)

        -- Build-in commands are already documented. However, some descriptions
        -- are missing.
        wk.register {
            z = {
                j = 'Go to next fold',
                k = 'Go to previous fold',
            },
            g = {
                v = 'Select last selected text',
            },
            ['&'] = 'Repeat substitute on current line',
            ['<C-O>'] = 'Older position in jump list',
            ['<C-I>'] = 'Newer position in jump list',
        }
        -- Register all labels from the queue
        local queue = require('tummetott.utils').which_key_queue
        if queue and queue ~= {} then
            wk.register(queue)
            queue = {}
        end
    end
}
