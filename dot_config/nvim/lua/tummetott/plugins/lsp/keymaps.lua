local M = {}

-- If installed, use trouble instead of the native qflist
local on_list_handler = function(options)
    vim.fn.setqflist({}, ' ', options)
    local ok, trouble = pcall(require, 'trouble')
    if ok then
        trouble.open('quickfix')
    else
        vim.api.nvim_command('cfirst')
    end
end

M.register = function(_, bufnr)
    -- Jump to next diagnostic
    vim.keymap.set(
        'n',
        ']d',
        function() vim.diagnostic.goto_next() end,
        { desc = 'Go to next diagnostic', buffer = bufnr }
    )

    -- Jump to previous diagnostic
    vim.keymap.set(
        'n',
        '[d',
        function() vim.diagnostic.goto_prev() end,
        { desc = 'Go to previous diagnostic', buffer = bufnr }
    )

    -- Hover information. NOTE: This keymap is not really necessary as 'K' does
    -- the same already.
    vim.keymap.set(
        'n',
        '<Leader><Leader>',
        function() vim.lsp.buf.hover() end,
        { desc = 'Show LSP hover info', buffer = bufnr }
    )

    -- Goto definition
    vim.keymap.set(
        'n',
        'gd',
        function()
            local ok, trouble = pcall(require, 'trouble')
            if ok then
                trouble.toggle('lsp_definitions')
            else
                vim.lsp.buf.definition()
            end
        end,
        { desc = 'Go to definition', buffer = bufnr }
    )

    -- Goto declaration
    vim.keymap.set(
        'n',
        'gD',
        function()
            vim.lsp.buf.declaration({ on_list = on_list_handler })
        end,
        { desc = 'Go to declaration', buffer = bufnr }
    )

    -- Goto type definition
    vim.keymap.set(
        'n',
        '<Leader>lt',
        function()
            local ok, trouble = pcall(require, 'trouble')
            if ok then
                trouble.toggle('lsp_type_definitions')
            else
                vim.lsp.buf.type_definition()
            end
        end,
        { desc = 'Go to type definition', buffer = bufnr }
    )

    -- Goto implementation
    vim.keymap.set(
        'n',
        '<Leader>li',
        function()
            vim.lsp.buf.implementation({ on_list = on_list_handler })
        end,
        { desc = 'Go to implementation', buffer = bufnr }
    )

    -- Rename
    vim.keymap.set(
        'n',
        '<Leader>lr',
        function() vim.lsp.buf.rename() end,
        { desc = 'Rename', buffer = bufnr }
    )

    -- Show signature help
    vim.keymap.set(
        'n',
        '<Leader>ls',
        function() vim.lsp.buf.signature_help() end,
        { desc = 'Show signature help', buffer = bufnr }
    )

    -- Highlight all occurences of word under the cursor
    vim.keymap.set(
        'n',
        '<Leader>lh',
        function() vim.lsp.buf.document_highlight() end,
        { desc = 'Highlight word', buffer = bufnr }
    )

    -- Code action
    vim.keymap.set(
        'n',
        '<Leader>la',
        function() vim.lsp.buf.code_action() end,
        { desc = 'Code action', buffer = bufnr }
    )

    -- Auto formatting
    vim.keymap.set(
        'n',
        '<Leader>lf',
        function() vim.lsp.buf.format { async = true } end,
        { desc = 'Auto formatting', buffer = bufnr }
    )

    -- Send diagnostics to quickfix list
    vim.keymap.set(
        'n',
        '<Leader>lw',
        function()
            local ok, trouble = pcall(require, 'trouble')
            if ok then
                trouble.open('workspace_diagnostics')
            else
                vim.diagnostic.setqflist()
            end
        end,
        { desc = 'Workspace diagnostics', buffer = bufnr }
    )

    -- Show references in quickfix list
    vim.keymap.set(
        'n',
        'gr',
        function()
            vim.lsp.buf.references(nil, { on_list = on_list_handler })
        end,
        { desc = 'Goto references', buffer = bufnr }
    )

    -- Add workspace folder
    vim.keymap.set(
        'n',
        '<Leader>l+',
        function() vim.lsp.buf.add_workspace_folder() end,
        { desc = 'Add workspace folder', buffer = bufnr }
    )

    -- Remove workspace folder
    vim.keymap.set(
        'n',
        '<Leader>l-',
        function() vim.lsp.buf.remove_workspace_folder() end,
        { desc = 'Remove workspace folder', buffer = bufnr }
    )

    vim.keymap.set(
        'n',
        '<Leader>ll',
        function() vim.print(vim.lsp.buf.list_workspace_folders()) end,
        { desc = 'List workspace folders', buffer = bufnr }
    )

    -- Add wich-key group label
    require 'which-key'.register({
        ['<leader>l'] = { name = 'Lsp' },
    }, { buffer = bufnr })
end

return M
