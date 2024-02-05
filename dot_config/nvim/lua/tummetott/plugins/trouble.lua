-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists
return {
    'folke/trouble.nvim',
    enabled = true,
    init = function()
        require('tummetott.utils').which_key_register {
            ['<leader>t'] = { name = 'Trouble' }
        }
    end,
    opts = {
        -- Values are: workspace_diagnostics, document_diagnostics, quickfix,
        -- lsp_references, loclist
        mode = 'quickfix',
        -- Group results by file
        group = true,
        -- Add an extra new line on top of the list
        padding = true,
        icons = vim.g.nerdfonts,
        action_keys = {
            -- Close the list
            close = 'q',
            -- Cancel the preview and get back to your last window / buffer
            cancel = '<esc>',
            -- Jump to the diagnostis
            jump = '<cr>',
            -- Jump to the diagnostic and close the list
            jump_close = { 'o' },
            -- Toggle auto_preview
            toggle_preview = 'P',
            -- Preview the diagnostic location
            preview = 'p',
        },
        -- Add an indent guide below the fold icons
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = false,
        auto_fold = false,
        -- For the given modes, automatically jump if there is only a single
        -- result
        auto_jump = { 'lsp_definitions' },
        -- Enabling this will use the signs defined in your lsp client
        use_diagnostic_signs = true,
        -- This is the fallback sign
        signs = {
            other = vim.g.nerdfonts and '' or '*'
        },
        fold_open = vim.g.nerdfonts and '' or 'v',
        fold_closed = vim.g.nerdfonts and '' or '>',
    },
    cmd = {
        'Trouble',
        'TroubleToggle',
    },
    keys = {
        {
            '<tab>',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.next({skip_groups = true, jump = true})
                end
            end,
            desc = 'Next Trouble entry',
        },
        {
            '<s-tab>',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.previous({skip_groups = true, jump = true})
                end
            end,
        },
        {
            '<Leader>tt',
            function() require('trouble').toggle() end,
            desc = 'toggle trouble',
        },
        {
            '<Leader>tq',
            function() require('trouble').toggle('quickfix') end,
            desc = 'toggle quickfix list',
        },
        {
            '<Leader>tl',
            function() require('trouble').toggle('loclist') end,
            desc = 'toggle location list',
        },
        {
            '[c',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.previous({ skip_groups = true, jump = true })
                else
                    vim.cmd('silent! cprevious')
                end
            end,
            desc = 'Previous Trouble entry',
        },
        {
            ']c',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.next({ skip_groups = true, jump = true })
                else
                    vim.cmd('silent! cnext')
                end
            end,
            desc = 'Next Trouble entry',
        },
        {
            '[C',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.first({ skip_groups = true, jump = true })
                end
            end,
            desc = 'First Trouble entry',
        },
        {
            ']C',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.last({ skip_groups = true, jump = true })
                end
            end,
            desc = 'Last Trouble entry',
        },
    },
}
