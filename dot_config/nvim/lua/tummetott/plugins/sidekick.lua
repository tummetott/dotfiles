return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    init = function()
        require('which-key').add {
            { "<Leader>j", group = "Sidekick" }
        }
    end,
    config = function(_, opts)
        require('sidekick').setup(opts)

        -- Send one NES update shortly after startup.
        -- Reason: Copilot's Next Edit Suggestions (NES) won't respond to the
        -- very first manual update call unless the LSP has already received a
        -- valid text synchronization event. This deferred update "warms up"
        -- Copilot so the first <C-,> trigger works without requiring a manual
        -- edit beforehand.
        vim.defer_fn(function()
            pcall(function()
                require('sidekick.nes').update()
            end)
        end, 1000)
    end,
    opts = {
        nes = {
            enabled = true,
            trigger = {
                -- Trigger 'next suggestion' when i accepted a previous
                -- suggestion
                events = {
                    'User SidekickNesDone',
                },
            },
        },
        cli = {
            win = {
                keys = {
                    prompt = {
                        '<c-o>',
                        'prompt',
                        mode = 't',
                        desc = 'insert prompt or context',
                    },
                }
            },
            -- FIX: Removed the deprecated "--enable web_search" flag, that
            -- sidekick adds automatically 
            tools = {
                codex = { cmd = { "codex" } },
            }
        },
    },
    keys = {
        {
            '<c-,>',
            function()
                -- Close the blink window if a copilot suggestion is fetched
                local ok, blink = pcall(require, 'blink.cmp')
                if ok and blink.is_menu_visible() then
                    blink.cancel()
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
            mode = { 'n' }, -- Insert mode mapping in blink.nvim
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
            '<c-f>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    vim.api.nvim_input('<Right>')
                end
            end,
            mode = 'i',
            desc = 'Apply Suggestion or Move Right'
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
            mode = 'n', -- Insert mode mapping in blink.cmp
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
        -- Enable <C-n>/<C-p> navigation for Codex selection menus by
        -- translating them to arrow keys in terminal mode. This overrides
        -- default nvim terminal-mode behavior globally; verify no other
        -- terminal workflows rely on these keys.
        {
            '<c-n>',
            '<down>',
            mode = 't',
            desc = 'Down',
        },
        {
            '<c-p>',
            '<up>',
            mode = 't',
            desc = 'Up',
        },
    },
}
