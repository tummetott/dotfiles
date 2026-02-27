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

-- Enable language servers
-- NOTE: They must all be installed with Mason
vim.lsp.enable({
    'lua_ls',
    'pyright',
    'clangd',
    'rust_analyzer',
    'efm', -- Also install 'shellcheck'
    'copilot',
    'vtsls', -- typescript
    'gopls',
    'sourcekit', -- swift
})

-- Use the LspAttach event instead of overwriting vim.lsp.config's on_attach,
-- since lspconfig may define its own on_attach callbacks for certain servers.
-- This ensures those callbacks are extended rather than replaced.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Register buffer-local keymaps
        keymaps.register_buffer_keymaps(client, bufnr)

        -- Setup signature help
        signature.setup(client, bufnr)

        -- Clear references on cursor hold
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = vim.lsp.buf.clear_references,
            group = doc_hl_grp,
            buffer = bufnr,
        })
    end,
})

-- nvim-lspconfig provides the default configurations for most language servers.
-- Neovim merges these defaults with any additional settings defined via the new
-- LSP API 'vim.lsp.config()' and with any files located under the runtime path
-- in 'lsp/<server>.lua'. In short, lspconfig defines the base setup, while the
-- LSP API extend or override parts of that configuration.
table.insert(M, {
    enabled = true,
    'neovim/nvim-lspconfig',
    lazy = false,
    highlights = {
        -- Used for document highlight
        LspReferenceRead = { bg = 'dark_grey' },
        LspReferenceWrite = { bg = 'dark_grey' },
    },
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
