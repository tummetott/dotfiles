local agent = require 'tummetott.utils.agent'

return {
    'folke/sidekick.nvim',
    enabled = true,
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
            win = {
                keys = {
                    prompt = {
                        '<c-;>',
                        agent.send_prompt,
                        mode = 't',
                        desc = 'insert prompt',
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
            agent.open,
            desc = 'Agent',
        },
        {
            '<leader>lf',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send file reference',
        },
        {
            '<leader>lr',
            function() require('sidekick.cli').send({ msg = '{line}' }) end,
            mode = { 'n', 'x' },
            desc = 'Send line reference',
        },
        {
            '<leader>lc',
            function()
                local line = vim.trim(vim.api.nvim_get_current_line())
                require('sidekick.cli').send({ text = { { { line } } } })
            end,
            mode = { 'n' },
            desc = 'Send line content',
        },
        {
            '<leader>lc',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send content',
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
            desc = 'Send buffer content',
        },
    },
}
