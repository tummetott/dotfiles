M = {}

-- Loading this module automatically registers all global LSP-related keymaps
local keymaps = require("tummetott.plugins.lsp.keymaps")
local signature = require("tummetott.plugins.lsp.signature")
local doc_hl_grp = vim.api.nvim_create_augroup("document_hl", {})

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

local function on_attach_handler(client, bufnr)
    -- Register only buffer-local keymaps that override useful built-in Vim
    -- commands
    keymaps.register_buffer_keymaps(client, bufnr)
    signature.setup(client, bufnr)

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = vim.lsp.buf.clear_references,
        group = doc_hl_grp,
        buffer = bufnr,
    })
end

local function get_capabilities()
    local ok, cmp = pcall(require, 'cmp_nvim_lsp')
    return ok and cmp.default_capabilities()
        or vim.lsp.protocol.make_client_capabilities()
end

-- Set default config for all servers
vim.lsp.config('*', {
    on_attach = on_attach_handler,
    capabilities = get_capabilities(),
})

-- Enable language servers
-- NOTE: They must all be installed with Mason
vim.lsp.enable({
    'lua_ls',
    'pyright',
    'clangd',
    'rust_analyzer',
    'efm', -- Also install 'shellcheck'
    'copilot',
})

-- lspconfig is still included even though we use the new vim.lsp.config API. It
-- now only provides the built-in server configuration files (under lsp/), which
-- Neovim automatically merges when a server is enabled.
table.insert(M, {
    enabled = true,
    'neovim/nvim-lspconfig',
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

-- lazydev.nvim provides better Lua development experience for Neovim configs.
-- It automatically adds Neovim’s runtime and common plugin libraries to lua_ls,
-- so you get proper completions and types without manually tweaking
-- workspace.library.
table.insert(M, {
    'folke/lazydev.nvim',
    enabled = true,
    ft = 'lua',
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    },
})

-- The java language server (jdtls) requires special startup logic and
-- per-project setup that can’t be handled by the generic LSP API. It manages
-- its own launch process, workspace folders, and debug/test integrations for
-- Java projects.
table.insert(M, {
    'mfussenegger/nvim-jdtls',
    enabled = true,
    ft = 'java',
    opts = {},
})

return M
