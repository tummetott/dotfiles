return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    init = function()
        require('which-key').add {
            { '<Leader>j', group = 'Sidekick' }
        }
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
        -- HACK: workaround for https://github.com/folke/sidekick.nvim/issues/318
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
