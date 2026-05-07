return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    init = function()
        require('which-key').add {
            { '<Leader>j', group = 'Sidekick' }
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

        -- Codex hardcodes <C-n>/<C-p> to navigate between questions in plan
        -- mode. These mappings repurpose them for list navigation instead.
        -- ISSUE: https://github.com/openai/codex/issues/3049
        -- vim.api.nvim_create_autocmd('FileType', {
        --     pattern = 'sidekick_terminal',
        --     callback = function(args)
        --         vim.keymap.set('t', "<C-n>", "<Down>", {
        --             buffer = args.buf,
        --             desc = 'Next Item',
        --         })
        --         vim.keymap.set('t', "<C-p>", "<Up>", {
        --             buffer = args.buf,
        --             desc = 'Previous Item',
        --         })
        --     end,
        -- })
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
            picker = 'telescope',
            win = {
                keys = {
                    prompt = {
                        '<c-o>',
                        'prompt',
                        mode = 't',
                        desc = 'insert prompt or context',
                    },
                    buffers = {
                        '<leader>fb',
                        'buffers',
                        mode = 'n',
                        desc = 'open buffer picker',
                    },
                    files = {
                        '<leader>ff',
                        'files',
                        mode = 'n',
                        desc = 'open file picker',
                    },
                    stopinsert = false,
                    hide_n = false,
                }
            },
            prompts = {
                contained = 'Describe the current system state in a fully self-contained way, without referencing history or changes.',
                explain = 'Describe this to a non-domain expert',
            },
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
        -- HACK: workaround for this issue: https://github.com/folke/sidekick.nvim/issues/318
        {
            '<c-.>',
            function()
                local Cli = require('sidekick.cli')
                local State = require('sidekick.cli.state')

                if not next(State.get({ attached = true, terminal = true })) then
                    Cli.focus({ filter = { installed = true } })
                    return
                end

                State.with(function(state)
                    local t = state.terminal
                    if not t then
                        return
                    end
                    if t:is_open() then
                        t:hide()
                        return
                    end
                    t:show()
                    vim.api.nvim_set_current_win(t.win)
                end, {
                    filter = { attached = true, terminal = true },
                    focus = false,
                })
            end,
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
            function() require('sidekick.cli').send({ msg = '{line}' }) end,
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
