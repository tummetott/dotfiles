local cli_prompts = {
    no_history = [[You're still narrating your own edit history instead of stating the current, settled truth. Rewrite this in present tense: keep the standing reason it has to be this way, drop anything about what it used to be, what changed, or why you changed it.]],
    explain = 'Describe this to a non-domain expert',
    tempfile = [[Write your most recent response, properly formatted as markdown, to a new temporary file. Reply with only that file's path, no other text.]],
}

return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    init = function()
        require('which-key').add {
            { '<leader>l', mode = { 'n', 'x' }, group = 'LLM' },
        }
    end,
    opts = {
        nes = {
            enabled = false,
        },
        cli = {
            picker = 'telescope',
            win = {
                keys = {
                    prompt = {
                        '<c-;>',
                        function()
                            vim.ui.select(vim.tbl_keys(cli_prompts), { prompt = 'CLI prompt' }, function(choice)
                                if choice then
                                    require('sidekick.cli').send({ msg = cli_prompts[choice] })
                                end
                            end)
                        end,
                        mode = 't',
                        desc = 'insert prompt',
                    },
                    stopinsert = false,
                    hide_n = false,
                    buffers = false,
                    normal_cr = false,
                    files = false,
                }
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
            '<leader>lc',
            function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end,
            desc = 'Claude Code',
        },
        {
            '<leader>lx',
            function() require('sidekick.cli').toggle({ name = 'codex', focus = true }) end,
            desc = 'Codex',
        },
        {
            '<leader>lo',
            function() require('sidekick.cli').toggle({ name = 'opencode', focus = true }) end,
            desc = 'OpenCode',
        },
        {
            '<leader>lr',
            function() require('sidekick.cli').send({ msg = '{line}' }) end,
            mode = { 'x' },
            desc = 'Send reference',
        },
        {
            '<leader>lr',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send reference',
        },
        {
            '<leader>lt',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send text',
        },
    },
}
