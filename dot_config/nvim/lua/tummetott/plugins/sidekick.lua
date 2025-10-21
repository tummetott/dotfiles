return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function(_, opts)
        require('sidekick').setup(opts)

        -- Send one NES update shortly after startup.
        -- Reason: Copilot's Next Edit Suggestions (NES) won't respond to the
        -- very first manual update call unless the LSP has already received a
        -- valid text synchronization event. This deferred update "warms up"
        -- Copilot so the first <C-CR> trigger works without requiring a manual
        -- edit beforehand.
        vim.defer_fn(function()
            pcall(function()
                require('sidekick.nes').update()
            end)
        end, 1000)
    end,
    opts = {
        -- add any options here
        -- cli = {
        --     mux = {
        --         backend = "zellij",
        --         enabled = true,
        --     },
        -- },
        nes = {
            enabled = true,
            trigger = {
                -- Disable some automatic triggers
                events = {
                    -- 'ModeChanged *:n',
                    -- 'TextChanged',
                    'User SidekickNesDone',
                },
            },
        }
    },
    keys = {
        {
            '<c-cr>',
            function()
                -- Close the cmp window if a copilot suggestion is fetched
                local ok, cmp = pcall(require, 'cmp')
                if ok and cmp.visible() then
                    cmp.close()
                end
                require('sidekick.nes').update()
            end,
            desc = 'Get a copilot suggestion',
            mode = { 'n', 'i' },
        },
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
            function() require('sidekick.cli').toggle() end,
            desc = 'Sidekick Toggle',
            mode = { 'n', 't', 'i', 'x' },
        },
        {
            '<leader>aa',
            function() require('sidekick.cli').toggle() end,
            desc = 'Sidekick Toggle CLI',
        },
        {
            '<leader>as',
            function() require('sidekick.cli').select() end,
            -- Or to select only installed tools:
            -- require("sidekick.cli").select({ filter = { installed = true } })
            desc = 'Select CLI',
        },
        {
            '<leader>ad',
            function() require('sidekick.cli').close() end,
            desc = 'Detach a CLI Session',
        },
        {
            '<leader>at',
            function() require('sidekick.cli').send({ msg = '{this}' }) end,
            mode = { 'x', 'n' },
            desc = 'Send This',
        },
        {
            '<leader>af',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send File',
        },
        {
            '<leader>av',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send Visual Selection',
        },
        {
            '<leader>ap',
            function() require('sidekick.cli').prompt() end,
            mode = { 'n', 'x' },
            desc = 'Sidekick Select Prompt',
        },
        -- Example of a keybinding to open Claude directly
        -- {
        --     '<leader>ac',
        --     function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end,
        --     desc = 'Sidekick Toggle Claude',
        -- },
    },
}
