local agent = require 'tummetott.utils.agent'

return {
    'tummetott/sidekick.nvim',
    enabled = true,
    branch = 'feat/zellij-external-panes',
    event = 'VeryLazy',
    init = function()
        require('which-key').add {
            {
                '<leader>l',
                mode = { 'n', 'x' },
                group = 'LLM',
                icon = vim.g.nerdfonts and '󰚩' or nil,
            },
        }
    end,
    opts = {
        nes = {
            enabled = false,
        },
        cli = {
            -- Enable this to run agents in zellij tabs
            mux = {
                enabled = false,
                backend = 'zellij',
                create = 'window',
            },
            tools = {
                cline = {
                    cmd = { 'cline', '--tui' },
                },
            },
            win = {
                config = agent.open_in_tab,
                keys = {
                    prompt = {
                        '<c-;>',
                        agent.send_prompt,
                        mode = 't',
                        desc = 'Insert Prompt',
                    },
                    stopinsert = false,
                    hide_ctrl_dot = false,
                    hide_n = false,
                    buffers = false,
                    normal_cr = false,
                    files = false,
                }
            },
        },
    },
    keys = {
        {
            '<c-.>',
            agent.toggle,
            desc = 'Sidekick Toggle',
            mode = { 'n', 't', 'i', 'x' },
        },
        {
            '<leader>oa',
            function() require('sidekick.cli').select({
                filter = { installed = true },
            }) end,
            desc = 'Agent',
        },
        {
            '<leader>lf',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send File Reference',
        },
        {
            '<leader>lr',
            function() require('sidekick.cli').send({ msg = '{line}' }) end,
            mode = { 'n', 'x' },
            desc = 'Send Line Reference',
        },
        {
            '<leader>lc',
            function()
                local line = vim.trim(vim.api.nvim_get_current_line())
                require('sidekick.cli').send({ text = { { { line } } } })
            end,
            mode = { 'n' },
            desc = 'Send Line Content',
        },
        {
            '<leader>lc',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send Content',
        },
        {
            '<leader>lC',
            function()
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                require('sidekick.cli').send({
                    text = vim.tbl_map(function(line) return { { line } } end, lines),
                })
            end,
            mode = { 'n' },
            desc = 'Send Buffer Content',
        },
    },
}
