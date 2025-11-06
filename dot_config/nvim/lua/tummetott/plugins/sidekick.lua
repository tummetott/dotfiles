return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    -- config = function(_, opts)
    --     require('sidekick').setup(opts)
    --
    --     -- Send one NES update shortly after startup.
    --     -- Reason: Copilot's Next Edit Suggestions (NES) won't respond to the
    --     -- very first manual update call unless the LSP has already received a
    --     -- valid text synchronization event. This deferred update "warms up"
    --     -- Copilot so the first <C-CR> trigger works without requiring a manual
    --     -- edit beforehand.
    --     vim.defer_fn(function()
    --         pcall(function()
    --             require('sidekick.nes').update()
    --         end)
    --     end, 1000)
    -- end,
    opts = {
        nes = {
            enabled = true,
            trigger = {
                -- Enable automatic triggers
                events = {
                    'ModeChanged *:n',
                    'TextChanged',
                    'User SidekickNesDone',
                },
            },
        }
    },
    keys = {
        -- {
        --     '<c-cr>',
        --     function()
        --         -- Close the cmp window if a copilot suggestion is fetched
        --         local ok, cmp = pcall(require, 'cmp')
        --         if ok and cmp.visible() then
        --             cmp.close()
        --         end
        --         require('sidekick.nes').update()
        --     end,
        --     desc = 'Get a copilot suggestion',
        --     mode = { 'n', 'i' },
        -- },
        {
            '<cr>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    return '<cr>'
                end
            end,
            expr = true,
            -- <cr> in insert mode is defined by my completion plugin
            mode = { 'n', 'i' },
            desc = 'Apply Copilot Suggestion'
        },
        {
            '<c-y>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    return '<c-y>'
                end
            end,
            expr = true,
            mode = { 'n', 'i' },
            desc = 'Apply Copilot Suggestion'
        },
        {
            '<c-e>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').clear()
                else
                    return '<c-e>'
                end
            end,
            expr = true,
            desc = 'Clear Copilot Suggestion'
        },
        {
            '<c-.>',
            function() require('sidekick.cli').toggle({ filter = { installed = true } }) end,
            desc = 'Sidekick Toggle',
            mode = { 'n', 't', 'i', 'x' },
        },
        {
            '<leader>js',
            function() require('sidekick.cli').select() end,
            desc = 'Select CLI',
        },
        {
            '<leader>jd',
            function() require('sidekick.cli').close() end,
            desc = 'Detach a CLI Session',
        },
        {
            '<leader>jt',
            function() require('sidekick.cli').send({ msg = '{this}' }) end,
            mode = { 'x', 'n' },
            desc = 'Send This',
        },
        {
            '<leader>jf',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send File',
        },
        {
            '<leader>jv',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send Visual Selection',
        },
        {
            '<leader>jp',
            function() require('sidekick.cli').prompt() end,
            mode = { 'n', 'x' },
            desc = 'Sidekick Select Prompt',
        },
    },
}
