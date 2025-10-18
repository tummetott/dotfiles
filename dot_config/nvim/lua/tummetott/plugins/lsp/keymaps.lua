local M = {}

-- Jump to next diagnostic
vim.keymap.set(
    'n',
    ']d',
    function() vim.diagnostic.jump({ count = 1, float = true }) end,
    { desc = 'Go to next diagnostic' }
)

-- Jump to previous diagnostic
vim.keymap.set(
    'n',
    '[d',
    function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = 'Go to previous diagnostic' }
)

-- Goto type definition
vim.keymap.set(
    'n',
    '<Leader>lt',
    function()
        require('trouble').open('lsp_type_definitions')
    end,
    { desc = 'Go to type definition' }
)

-- Goto implementation. Useful in OOP languages like Java, TypeScript, or
-- C++ to find where an interface or abstract method is implemented.
vim.keymap.set(
    'n',
    '<Leader>li',
    function()
        require('trouble').open('lsp_implementations')
    end,
    { desc = 'Go to implementation' }
)

-- Rename
vim.keymap.set(
    'n',
    '<Leader>lr',
    function() vim.lsp.buf.rename() end,
    { desc = 'Rename' }
)

-- Show signature help
vim.keymap.set(
    'n',
    '<Leader>ls',
    function() vim.lsp.buf.signature_help() end,
    { desc = 'Show signature help' }
)

-- Highlight all occurences of word under the cursor
vim.keymap.set(
    'n',
    '<Leader>lh',
    function() vim.lsp.buf.document_highlight() end,
    { desc = 'Highlight word' }
)

-- Code action
vim.keymap.set(
    'n',
    '<Leader>la',
    function() vim.lsp.buf.code_action() end,
    { desc = 'Code action' }
)

-- Auto formatting
vim.keymap.set(
    'n',
    '<Leader>lf',
    function() vim.lsp.buf.format { async = true } end,
    { desc = 'Auto formatting' }
)

-- Send diagnostics to quickfix list
vim.keymap.set(
    'n',
    '<Leader>ld',
    function()
        require('trouble').open('diagnostics')
    end,
    { desc = 'Workspace diagnostics' }
)

-- Show references in quickfix list
vim.keymap.set(
    'n',
    'gr',
    function()
        require('trouble').open('lsp_references')
    end,
    { desc = 'Goto references' }
)

-- Add workspace folder
vim.keymap.set(
    'n',
    '<Leader>l+',
    function() vim.lsp.buf.add_workspace_folder() end,
    { desc = 'Add workspace folder' }
)

-- Remove workspace folder
vim.keymap.set(
    'n',
    '<Leader>l-',
    function() vim.lsp.buf.remove_workspace_folder() end,
    { desc = 'Remove workspace folder' }
)

vim.keymap.set(
    'n',
    '<Leader>ll',
    function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
    { desc = 'List workspace folders' }
)

-- Some LSP-related keymaps override useful built-in Vim keymaps, so they should
-- only be defined after an LSP client attaches to the current buffer.
M.register_buffer_keymaps = function(_, bufnr)
    -- Goto definition
    vim.keymap.set(
        'n',
        'gd',
        function()
            require('trouble').open('lsp_definitions')
        end,
        { desc = 'Go to definition', buffer = bufnr }
    )

    -- Goto declaration. Mostly relevant in C/C++, e.g. when a function is
    -- declared in a header file
    vim.keymap.set(
        'n',
        'gD',
        function()
            require('trouble').open('lsp_declaration')
        end,
        { desc = 'Go to declaration', buffer = bufnr }
    )

    -- Neovim automatically remaps 'K' to show LSP hover information whenever a
    -- language server attaches, replacing the default :Man behavior. We
    -- register it here in which-key for proper documentation.
    require 'which-key'.add {
        { 'K', desc = 'Show LSP hover info' },
    }
end

return M
