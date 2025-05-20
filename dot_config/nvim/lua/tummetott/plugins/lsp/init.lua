M = {}

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

-- Configs for all language-servers
vim.lsp.config('*', {
    on_attach = function(client, bufnr)
        -- Setup my LSP keymaps
        require('tummetott.plugins.lsp.keymaps').register(client, bufnr)
        -- Show signature help automatically
        require('tummetott.plugins.lsp.signature').setup(client, bufnr)
        -- Autocmd to reset document highlights as soon as the cursor holds
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = vim.lsp.buf.clear_references,
            group = vim.api.nvim_create_augroup('document_hl', { clear = true }),
            buffer = bufnr,
        })
    end,
    capabilities = (function()
        local loaded, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        if loaded then
            return cmp_nvim_lsp.default_capabilities()
        end
    end)(),
})

table.insert(M, {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    },
})

table.insert(M, {
    'mason-org/mason-lspconfig.nvim',
    enabled = true,
    opts = {
        ensure_installed = { 'lua_ls' },
        automatic_enable = {
            exclude = {
                'jdtls',
            }
        }
    },
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'neovim/nvim-lspconfig',
    },
    event = 'LazyFile',
})

-- The java language server has a separate plugin which is loaded by ftplugin
table.insert(M, {
    'mfussenegger/nvim-jdtls',
    enabled = true,
    lazy = true,
    ft = 'java',
})

return M
