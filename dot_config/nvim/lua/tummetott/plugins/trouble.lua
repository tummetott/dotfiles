-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists
return {
    'folke/trouble.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            { "<leader>t", group = "Trouble" },
        }
    end,
    opts = {
        auto_close = true,    -- auto close when there are no items
        auto_open = false,    -- auto open when there are items
        auto_preview = false, -- automatically open preview when on an item
        auto_refresh = true,  -- auto refresh when open
        restore = true,       -- restores the last location in the list when opening
        focus = false,        -- Focus the window when opened
        follow = false,       -- Follow the current item
        indent_guides = true, -- show indent guides
        max_items = 200,      -- limit number of items that can be displayed per section
        multiline = true,     -- render multi-line messages
        pinned = false,       -- When pinned, the opened trouble window will be bound to the current buffer
        win = {},             -- window options for the results window. Can be a split or a floating window.
        -- Window options for the preview window. Can be a split, floating window,
        -- or `main` to show the preview in the main editor window.
        preview = { type = 'main' },
        -- Key mappings can be set to the name of a builtin action,
        -- or you can define your own custom action.
        keys = {
            ['?'] = 'help',
            r = 'refresh',
            R = 'toggle_refresh',
            q = 'close',
            o = 'jump_close',
            ['<esc>'] = 'cancel',
            ['<cr>'] = 'jump',
            ['<2-leftmouse>'] = 'jump',
            ['<c-s>'] = 'jump_split',
            ['<c-v>'] = 'jump_vsplit',
            ['}'] = 'next',
            [']]'] = 'next',
            ['{'] = 'prev',
            ['[['] = 'prev',
            dd = "delete",
            d = { action = "delete", mode = "v" },
            i = 'inspect',
            p = 'preview',
            P = 'toggle_preview',
            ['<c-n>'] = 'next',
            ['<c-p>'] = 'prev',
        },
        modes = {
            telescope = {
                sort = { "filename", "pos" },
                title = false,
                groups = {
                    { "filename", format = "{file_icon}{filename} {count}" },
                },
            },
            telescope_files = {
                sort = { "filename", "pos" },
                title = false,
                format = "{file_icon}{filename}",
            },
            quickfix = {
                sort = { "pos", "filename", "severity", "message" },
                groups = {
                    { "filename", format = "{file_icon}{filename} {count}" },
                },
                format = "{text:ts} {pos}",
            },
            loclist = {
                sort = { "pos", "filename", "severity", "message" },
                groups = {
                    { "filename", format = "{file_icon}{filename} {count}" },
                },
                format = "{text:ts} {pos}",
            },
            todo = {
                sort = { "pos", "filename", "severity", "message" },
                groups = {
                    { "filename", format = "{file_icon}{filename} {count}" },
                },
                format = "{todo_icon}{text} {pos}",
            },
            diagnostics = {
                groups = {
                    { "filename", format = "{file_icon}{basename} {count}" },
                },
                sort = { "severity", "filename", "pos", "message" },
                format = "{severity_icon}{message:md} {item.source} {code} {pos}",
            },
            -- Base settings for:
            -- lsp_definitions, lsp_references, lsp_implementations
            -- lsp_type_definitions, lsp_declarations, lsp_command
            lsp_base = {
                groups = {
                    { "filename", format = "{file_icon}{filename} {count}" },
                },
            },
            lsp_definitions = {
                title = false,
            },
            lsp_type_definitions = {
                title = false,
            },
            lsp_references = {
                title = false,
                params = {
                    include_declaration = false,
                },
            },
            lsp_implementations = {
                title = false,
            },
            lsp_declarations = {
                title = false,
            },
            lsp_document_symbols = {
                desc = 'Document symbols',
                mode = 'lsp_document_symbols',
                focus = false,
                win = { position = 'right' },
                filter = {
                    -- remove Package since luals uses it for control flow structures
                    ['not'] = { ft = 'lua', kind = 'Package' },
                    any = {
                        -- all symbol kinds for help / markdown files
                        ft = { 'help', 'markdown' },
                        -- default set of symbol kinds
                        kind = {
                            'Class',
                            'Constructor',
                            'Enum',
                            'Field',
                            'Function',
                            'Interface',
                            'Method',
                            'Module',
                            'Namespace',
                            'Package',
                            'Property',
                            'Struct',
                            'Trait',
                        },
                    },
                },
            },
        },
        icons = {
            indent        = {
                top         = '│ ',
                middle      = '├╴',
                last        = '└╴',
                fold_open   = ' ',
                fold_closed = ' ',
                ws          = '  ',
            },
            folder_closed = ' ',
            folder_open   = ' ',
            kinds         = {
                Array         = ' ',
                Boolean       = '󰨙 ',
                Class         = ' ',
                Constant      = '󰏿 ',
                Constructor   = ' ',
                Enum          = ' ',
                EnumMember    = ' ',
                Event         = ' ',
                Field         = ' ',
                File          = ' ',
                Function      = '󰊕 ',
                Interface     = ' ',
                Key           = ' ',
                Method        = '󰊕 ',
                Module        = ' ',
                Namespace     = '󰦮 ',
                Null          = ' ',
                Number        = '󰎠 ',
                Object        = ' ',
                Operator      = ' ',
                Package       = ' ',
                Property      = ' ',
                String        = ' ',
                Struct        = '󰆼 ',
                TypeParameter = ' ',
                Variable      = '󰀫 ',
            },
        },
    },
    cmd = { 'Trouble' },
    keys = {
        {
            '<Leader>tq',
            function() require('trouble').toggle('quickfix') end,
            desc = 'Toggle quickfix list',
        },
        {
            '<Leader>tl',
            function() require('trouble').toggle('loclist') end,
            desc = 'Toggle location list',
        },
        {
            '<Leader>tt',
            function() require('trouble').toggle('telescope') end,
            desc = 'Toggle telescope list',
        },
        {
            '<Leader>ts',
            function() require('trouble').toggle('lsp_document_symbols') end,
            desc = 'Toggle symbols',
        },
        {
            '<tab>',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.next({ jump = true })
                end
            end,
            desc = 'Next Trouble entry',
        },
        {
            '<s-tab>',
            function()
                local trouble = require('trouble')
                if trouble.is_open() then
                    trouble.prev({ jump = true })
                end
            end,
            desc = 'Previous Trouble entry',
        },
        {
            '[c',
            function()
                local trouble = require('trouble')
                if trouble.is_open({ mode = 'quickfix' }) then
                    trouble.prev({ jump = true })
                else
                    vim.cmd('silent! cprevious')
                end
            end,
            desc = 'Previous Trouble entry',
        },
        {
            ']c',
            function()
                local trouble = require('trouble')
                if trouble.is_open({ mode = 'quickfix' }) then
                    trouble.next({ jump = true })
                else
                    vim.cmd('silent! cnext')
                end
            end,
            desc = 'Next Trouble entry',
        },
        {
            '[C',
            function()
                local trouble = require('trouble')
                if trouble.is_open({ mode = 'quickfix' }) then
                    trouble.first({ jump = true })
                end
            end,
            desc = 'First Trouble entry',
        },
        {
            ']C',
            function()
                local trouble = require('trouble')
                if trouble.is_open({ mode = 'quickfix' }) then
                    trouble.last({ jump = true })
                end
            end,
            desc = 'Last Trouble entry',
        },
    },
    highlights = {
        TroubleIndent = { link = 'NonText' },
        TroubleIndentFoldOpen = { fg = 'grey' },
        TroubleIndentFoldClosed = { link = 'TroubleIndentFoldOpen' },
        TroubleCount = { fg = 'foreground', bg = 'darkest_grey', bold = false },
    }
}
