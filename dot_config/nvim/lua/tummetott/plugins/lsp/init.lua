M = {}

table.insert(M, {
    'neovim/nvim-lspconfig',
    enabled = true,
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim',
        'j-hui/fidget.nvim',
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
                    local conf =
                        require('tummetott.plugins.lsp.config').get_config(server)
                    require('lspconfig')[server].setup(conf)
                end,
                -- Next would come dedicated handler for specific servers.
                -- See ':h mason-lspconfig-dynamic-server-setup'
                ['java_language_server'] = function ()
                    -- Don't use it for now
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
