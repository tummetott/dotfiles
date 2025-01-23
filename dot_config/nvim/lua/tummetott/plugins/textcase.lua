return {
    'johmsalas/text-case.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            { "<leader>c", group = "Case" },
        }
    end,
    keys = {
        -- All normal mode keymaps use the LSP to rename a symbol
        {
            '<leader>cs',
            function() require('textcase').lsp_rename('to_snake_case') end,
            desc = 'to_snake_case',
        },
        {
            '<leader>cc',
            function() require('textcase').lsp_rename('to_camel_case') end,
            desc = 'toCamelCase',
        },
        {
            '<leader>cd',
            function() require('textcase').lsp_rename('to_dash_case') end,
            desc = 'to-dash-case',
        },
        {
            '<leader>cn',
            function() require('textcase').lsp_rename('to_constant_case') end,
            desc = 'TO_CONSTANT_CASE',
        },
        {
            '<leader>cp',
            function() require('textcase').lsp_rename('to_pascal_case') end,
            desc = 'ToPascalCase',
        },
        -- The following visual mode keymaps exclusively modify the case of the
        -- selected text without invoking LSP-related actions.
        {
            '<leader>cs',
            ":lua require('textcase').current_word('to_snake_case')<cr>",
            mode = 'x',
            desc = 'to_snake_case',
        },
        {
            '<leader>cc',
            ":lua require('textcase').current_word('to_camel_case')<cr>",
            mode = 'x',
            desc = 'toCamelCase',
        },
        {
            '<leader>cd',
            ":lua require('textcase').current_word('to_dash_case')<cr>",
            mode = 'x',
            desc = 'to-dash-case',
        },
        {
            '<leader>cn',
            ":lua require('textcase').current_word('to_constant_case')<cr>",
            mode = 'x',
            desc = 'TO_CONSTANT_CASE',
        },
        {
            '<leader>cp',
            ":lua require('textcase').current_word('to_pascal_case')<cr>",
            mode = 'x',
            desc = 'ToPascalCase',
        },
        {
            '<leader>c.',
            ":lua require('textcase').current_word('to_dot_case')<cr>",
            mode = 'x',
            desc = 'to.dot.case',
        },
        {
            '<leader>c/',
            ":lua require('textcase').current_word('to_path_case')<cr>",
            mode = 'x',
            desc = 'to/path/case',
        },
    }
}
