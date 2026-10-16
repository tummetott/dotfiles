local M = {}

-- NOTE: Dont overwrite vim.lsp.config's on_attach, since lspconfig may define
-- its own on_attach callbacks for certain server.
-- Use the LspAttach event instead

-- Loading global LSP-related keymaps
local keymaps = require("tummetott.plugins.lsp.keymaps")

-- Global options for all diagnostics
vim.diagnostic.config({
    virtual_text = false,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    signs = vim.g.nerdfonts and {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    } or true,
})

-- Enable language servers
-- NOTE: They must all be installed with Mason
vim.lsp.enable({
    'lua_ls',
    'pyright',
    'clangd',
    'rust_analyzer',
    'efm', -- Also install 'shellcheck'
    'vtsls', -- typescript
    'gopls',
    'sourcekit', -- swift lsp. Preinstalled on macos with xcode
    'solidity_ls', -- vscode-solidity-server
})

-- nvim-lspconfig is a collection of base configurations for most language
-- servers. A server's config is the deep merge of, in increasing priority:
-- - vim.lsp.config("*")
-- - lsp/<server>.lua
-- - lspconfig (which is just another lsp/<server>.lua but later in the rtp)
-- - after/lsp/<server>.lua
-- - vim.lsp.config("<server>")
table.insert(M, {
    enabled = true,
    'neovim/nvim-lspconfig',
    -- No lazy loading. Only config, nothing runs by default
    lazy = false,
})

-- mason.nvim is the plugin manager for language servers
table.insert(M, {
    'mason-org/mason.nvim',
    enabled = true,
    opts = {
        ui = {
            backdrop = 100
        }
    },
    cmd = {
        'Mason',
        'MasonInstall',
        'MasonUninstall',
        'MasonUpdate',
    },
})

table.insert(M, {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    enabled = true,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
        ensure_installed = {
            'lua-language-server', -- lua_ls
            'pyright',
            'clangd',
            'rust-analyzer', -- rust_analyzer
            'efm',
            'shellcheck', -- used by efm
            'vtsls', -- typescript
            'gopls',
            'vscode-solidity-server', -- solidity_ls
            -- sourcekit is preintalled on macOS
        },
    },
})

-- lazydev.nvim provides better Lua development experience for Neovim configs.
-- It automatically adds Neovim’s runtime and common plugin libraries to lua_ls,
-- so you get proper completions and types without manually tweaking
-- workspace.library.
table.insert(M, {
    'folke/lazydev.nvim',
    enabled = true,
    ft = 'lua',
    opts = {
        -- Disables root_dir detection. This is done manually in
        -- `after/lsp/lua_ls.lua` because it would otherwise add
        -- chezmoi's source AND target space.
        integrations = {
            lspconfig = false,
        },
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    },
})

-- The java language server (jdtls) requires special startup logic and
-- per-project setup that can’t be handled by the generic LSP API. It manages
-- its own launch process, workspace folders, and debug/test integrations for
-- Java projects. Its called via the ftplugin
table.insert(M, {
    'mfussenegger/nvim-jdtls',
    enabled = true,
    ft = 'java',
})

return M
