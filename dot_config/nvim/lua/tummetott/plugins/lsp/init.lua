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

-- Servers installed with Mason are enabled by mason-lspconfig. Only servers
-- outside Mason are enabled here.
vim.lsp.enable({
    'sourcekit' -- swift lsp. Preinstalled on macos with xcode
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

-- mason-lspconfig enables every language server installed with Mason,
-- including ones installed by hand through :Mason
table.insert(M, {
    'mason-org/mason-lspconfig.nvim',
    enabled = true,
    dependencies = {
        'mason-org/mason.nvim',
        'neovim/nvim-lspconfig',
    },
    opts = {
        automatic_enable = {
            -- nvim-jdtls starts jdtls from after/ftplugin/java.lua
            exclude = { 'jdtls' },
        },
    },
})

-- Mason packages to install automatically. `toolchain` names an executable
-- the package needs to build or run; machines without it skip the package.
local tools = {
    { 'lua-language-server' },
    { 'pyright', toolchain = 'npm' },
    { 'clangd' },
    { 'rust-analyzer', toolchain = 'cargo' },
    { 'efm' },
    { 'shellcheck' }, -- used by efm
    { 'vtsls', toolchain = 'npm' }, -- typescript
    { 'gopls', toolchain = 'go' },
    { 'vscode-solidity-server', toolchain = 'npm' },
}

--- Installs a tool only where Mason ships a build for this platform and its
--- toolchain exists, so unsupported machines start without install errors.
---@param tool { [1]: string, toolchain?: string }
local function ensure(tool)
    return {
        tool[1],
        condition = function()
            if tool.toolchain and vim.fn.executable(tool.toolchain) == 0 then
                return false
            end
            return require('mason-registry').get_package(tool[1]):is_installable()
        end,
    }
end

table.insert(M, {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    enabled = true,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
        ensure_installed = vim.tbl_map(ensure, tools),
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
