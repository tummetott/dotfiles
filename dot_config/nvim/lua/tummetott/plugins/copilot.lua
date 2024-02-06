local M = {}

table.insert(M, {
    'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = 'Copilot',
    opts = {
        panel = {
            enabled = false,
        },
        suggestion = {
            enabled = true,
            auto_trigger = false,
            debounce = 75,
            keymap = {
                -- Accept the whole suggestion
                accept = '<C-CR>',
                -- Disable the default accept line keymap
                accept_line = false,
                -- Once a copilot suggestion is visible, they can be cycled with
                -- CTRL-n / CTRL-p
                next = '<C-n>',
                prev = '<C-p>',
                dismiss = '<C-e>',
            },
        },
    },
    keys = {
        {
            -- When auto-trigger is disabled, copilot can be triggered manually with
            -- CTRL-\
            '<C-\\>',
            function()
                require('copilot.suggestion').next()
            end,
            desc = 'Get a copilot suggestion',
            mode = 'i',
        },
        {
            '<leader>p',
            function()
                require('copilot.suggestion').toggle_auto_trigger()
                if (vim.b.copilot_suggestion_auto_trigger) then
                    print('Enabled auto-trigger of copilot')
                else
                    print('Disabled auto-trigger of copilot')
                end
            end,
            desc = 'Toggle copilot auto-trigger',
        },
    }
})

return M
