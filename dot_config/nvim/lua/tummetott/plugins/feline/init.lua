-- Statusline and winbar plugin
return {
    'famiu/feline.nvim',
    enabled = true,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.nerdfonts,
    },
    event = 'VimEnter',
    init = function()
        vim.api.nvim_create_autocmd('SearchWrapped', {
            group = vim.api.nvim_create_augroup('feline_search_wrapped', {}),
            callback = function()
                vim.g.search_wrapped = true
            end
        })
    end,
    config = function()
        local statusline = require 'tummetott.plugins.feline.statusline'
        local winbar = require 'tummetott.plugins.feline.winbar'
        local providers = require 'tummetott.plugins.feline.provider'
        local colors = require 'tummetott.plugins.feline.colors'

        -- HACK: https://github.com/freddiehaddad/feline.nvim/issues/46
        require('feline.providers.lsp')

        require('feline').setup {
            components = statusline,
            custom_providers = providers,
            vi_mode_colors = {
                ['NORMAL'] = 'blue',
                ['INSERT'] = 'teal',
                ['COMMAND'] = 'purple',
                ['VISUAL'] = 'orange',
                ['LINES'] = 'orange',
                ['BLOCK'] = 'orange',
                ['REPLACE'] = 'red',
                ['ENTER'] = 'purple',
                ['TERM'] = 'purple',
            },
            force_inactive = {
                filetypes = {
                    'NvimTree',
                    'TelescopePrompt',
                    'help',
                    'lspinfo',
                    '^man$',
                    'Trouble',
                    'lazy',
                    'Outline',
                },
            },
            disable = {
                filetypes = { 'alpha' },
                buftypes = { 'terminal' },
            },
        }
        require('feline').winbar.setup {
            components = winbar,
            disable = {
                filetypes = {
                    'Outline',
                    'NvimTree',
                    'alpha',
                }
            }
        }
        colors.setup()
    end,
}
