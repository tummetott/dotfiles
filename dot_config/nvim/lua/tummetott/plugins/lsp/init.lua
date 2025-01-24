M = {}

table.insert(M, {
    'neovim/nvim-lspconfig',
    enabled = true,
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'j-hui/fidget.nvim',
        'mfussenegger/nvim-jdtls',
    },
    config = function()
        require('neodev').setup()
        require('tummetott.plugins.lsp.ui')
        require('mason-lspconfig').setup {
            ensure_installed = { 'lua_ls' },
            handlers = {
                -- This function simplifies the process of configuring language
                -- servers installed via Mason. Instead of manually adding each
                -- server to your Neovim setup, this function automates the
                -- setup for any installed server that doesn't have a dedicated
                -- configuration handler.
                function(server)
                    -- Load the configuration for the server if it exists, otherwise
                    -- use the base configuration.
                    local configs = require('tummetott.plugins.lsp.configs')
                    local config = configs[server] or configs['base']
                    -- Setup the server with the configuration.
                    require('lspconfig')[server].setup(config)
                end,
                ---
                -- Next come dedicated handler for specific servers.
                -- See ':h mason-lspconfig-dynamic-server-setup'
                ---
                -- Deactivated for now in favour for jdtls
                ['java_language_server'] = function() end,
                -- Don't let lspconfig manage jdtls, we use the plugin 'nvim-jdtls'.
                -- It offers additional features.
                ['jdtls'] = function()
                    local conf = require('tummetott.plugins.lsp.configs')
                    local group = vim.api.nvim_create_augroup('java_lsp', { clear = true })
                    vim.api.nvim_create_autocmd('FileType', {
                        group = group,
                        pattern = 'java',
                        desc = 'Start jdtls',
                        callback = function()
                            require('jdtls').start_or_attach(conf['jdtls'])
                        end,
                    })
                end
            }
        }
    end,
    cmd = {
        'LspStart',
        'LspStop',
        'LspRestart',
        'LspInfo',
        'LspLog',
        'LspInstall',
        'LspUninstall',
    },
    event = 'LazyFile',
})

-- Package manager for language servers, linters, fomatters and DAP servers
table.insert(M, {
    'williamboman/mason.nvim',
    enabled = true,
    opts = {
        ui = { border = 'rounded' },
    },
    cmd = {
        'Mason',
        'MasonUpdate',
        'MasonInstall',
        'MasonUninstall',
        'MasonUninstallAll',
        'MasonLog',
    }
})

-- Fancy LSP load progress
table.insert(M, {
    'j-hui/fidget.nvim',
    enabled = true,
    event = 'VeryLazy',
    opts = {
        progress = {
            display = {
                done_icon = vim.g.nerdfonts and '' or 'OK',
            }
        },
    }
})

return M
