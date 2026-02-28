local M = {}

-- Jump to diagnostic. These are already default keymaps; however, they are
-- overridden to also show the diagnostic inside a floating window.
vim.keymap.set(
    'n',
    ']d',
    function() vim.diagnostic.jump({ count = 1, float = true }) end,
    { desc = 'Go to next diagnostic' }
)
vim.keymap.set(
    'n',
    '[d',
    function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = 'Go to previous diagnostic' }
)

-- Show signature help
vim.keymap.set(
    'n',
    'grs',
    function() vim.lsp.buf.signature_help() end,
    { desc = 'Show signature help' }
)

-- Highlight all occurrences of the word under the cursor.
vim.keymap.set(
    'n',
    '<leader><space>',
    function() vim.lsp.buf.document_highlight() end,
    { desc = 'Highlight word' }
)

-- Auto formatting
vim.keymap.set(
    'n',
    'grf',
    function() vim.lsp.buf.format { async = true } end,
    { desc = 'Auto formatting' }
)

-- List workspace folders
vim.keymap.set(
    'n',
    'grl',
    function()
        local folders = vim.lsp.buf.list_workspace_folders()
        table.sort(folders)
        vim.print(vim.fn.uniq(folders))
    end,
    { desc = 'List workspace folders' }
)

local function default_workspace_folder()
    local name = vim.api.nvim_buf_get_name(0)
    if name ~= '' then
        local dir = vim.fn.fnamemodify(name, ':~:h')
        if dir and dir ~= '' then
            return dir
        end
    end
    return vim.fn.fnamemodify(vim.uv.cwd(), ':~')
end

-- Add workspace folder
vim.keymap.set(
    'n',
    'gr+',
    function()
        vim.ui.input({
            prompt = 'Add workspace folder: ',
            default = default_workspace_folder(),
        }, function(input)
            if input == nil then
                return
            end
            input = vim.trim(input)
            if input == '' then
                return
            end
            vim.lsp.buf.add_workspace_folder(vim.fs.normalize(input))
        end)
    end,
    { desc = 'Add workspace folder' }
)

-- Remove workspace folder
vim.keymap.set(
    'n',
    'gr-',
    function()
        local folders = vim.lsp.buf.list_workspace_folders()
        table.sort(folders)
        folders = vim.fn.uniq(folders)
        if vim.tbl_isempty(folders) then
            vim.notify('No workspace folders to remove', vim.log.levels.INFO)
            return
        end

        vim.ui.select(folders, {
            prompt = 'Remove workspace folder:',
        }, function(choice)
            if choice == nil then
                return
            end

            -- We do not use vim.lsp.buf.remove_workspace_folder() here because
            -- it always shows an awefull built-in message.
            local bufnr = vim.api.nvim_get_current_buf()
            for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                client:_remove_workspace_folder(choice)
            end
            vim.notify('Worspace folder removed', vim.log.levels.INFO)
        end)
    end,
    { desc = 'Remove workspace folder' }
)

-- Some LSP-related keymaps override useful built-in Vim keymaps, so they should
-- only be defined after an LSP client attaches to the current buffer.
M.register_buffer_keymaps = function(client, bufnr)

    -- Goto definition
    if client.server_capabilities.definitionProvider then
        vim.keymap.set(
            'n',
            'gd',
            function()
                require('trouble').open('lsp_definitions')
            end,
            { desc = 'Go to definition', buffer = bufnr }
        )
    end

    -- Goto declaration. Mostly relevant in C/C++, e.g. when a function is
    -- declared in a header file. Not every language server implements this
    if client.server_capabilities.declarationProvider then
        vim.keymap.set(
            'n',
            'gD',
            function()
                require('trouble').open('lsp_declaration')
            end,
            { desc = 'Go to declaration', buffer = bufnr }
        )
    end

    -- Neovim automatically remaps 'K' to show LSP hover information whenever a
    -- language server attaches, replacing the default :Man behavior. We
    -- register it here in which-key for proper documentation.
    require('which-key').add({
        { 'K', desc = 'Show LSP hover info' },
    })
end

return M
