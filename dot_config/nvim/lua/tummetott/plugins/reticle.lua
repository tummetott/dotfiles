local function echo_toggle(label, enabled)
    vim.api.nvim_echo({
        { label .. ' ', 'Normal' },
        { enabled and 'enabled' or 'disabled', enabled and 'DiagnosticOk' or 'DiagnosticWarn' },
    }, false, {})
end

return {
    'tummetott/reticle.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        on_startup = {
            cursorline = true,
        },
        follow = {
            cursorline = true,
            cursorcolumn = true,
        },
        disable_in_insert = true,
        disable_in_diff = true,
        always_highlight_number = true,
        on_focus = {
            cursorline = { 'help' },
        },
        ignore = {
            cursorline = {
                'FTerm',
                'NvimSeparator',
                'NvimTree',
                'TelescopePrompt',
                'trouble',
                'snacks_dashboard',
                'DiffviewFileHistory',
                'DiffviewFiles',
            },
        },
    },
    keys = {
        {
            '<leader>yc',
            function()
                local reticle = require 'reticle'
                reticle.toggle_cursorline()
                echo_toggle('Cursorline', reticle.has_cursorline())
            end,
            desc = 'Toggle cursorline',
        },
        {
            '<leader>yu',
            function()
                local reticle = require 'reticle'
                reticle.toggle_cursorcolumn()
                echo_toggle('Cursorcolumn', reticle.has_cursorcolumn())
            end,
            desc = 'Toggle cursorcolumn',
        },
        {
            '<leader>yx',
            function()
                local reticle = require 'reticle'
                reticle.toggle_cursorcross()
                echo_toggle('Cursorcross', reticle.has_cursorcross())
            end,
            desc = 'Toggle cursorcross',
        },
    }
}
