return {
    'saghen/blink.cmp',
    enabled = true,
    -- use a release tag to download pre-built binaries
    version = '1.*',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'moyiz/blink-emoji.nvim',
        {
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
        },
    },
    event = {
        'InsertEnter',
        'CmdlineEnter',
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            nerd_font_variant = 'mono',
        },
        completion = {
            keyword = {
                -- Fuzzy match on the text BEFORE the cursor
                range = 'prefix',
            },
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },
            menu = {
                auto_show = true,
                scrollbar = true,
                -- border = 'none',
                max_height = 30,
                draw = {
                    columns = vim.g.nerdfonts and {
                        { 'kind_icon' },
                        { 'label', 'label_description', gap = 1 },
                        { 'source_name' },
                    } or {
                        { 'label', 'label_description', gap = 1 },
                        { 'source_name' },
                    },
                    snippet_indicator = '',
                }
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500
            },
        },
        sources = {
            default = {
                'lsp',
                'path',
                'snippets',
                'buffer',
                'emoji',
            },
            providers = {
                lsp = {
                    -- Show buffer source even if the lsp source is active
                    fallbacks = {},
                },
                buffer = {
                    name = 'BUF',
                    min_keyword_length = 3,
                },
                path = {
                    name = 'PATH',
                },
                snippets = {
                    name = 'SNIP',
                },
                emoji = {
                    module = 'blink-emoji',
                    name = 'EMJI',
                    opts = {
                        insert = true, -- Insert emoji and not emoji name
                        trigger = { ':' },
                    },
                    -- Only show in certain files
                    -- should_show_items = function()
                    --     return vim.tbl_contains({
                    --         'gitcommit',
                    --         'markdown',
                    --         'txt',
                    --     }, vim.o.filetype)
                    -- end,
                },
            }
        },
        -- Each keymap may be a list of commands and/or functions. If the
        -- command/function returns false or nil, the next command/function will
        -- be run.
        keymap = { -- all insert mode mappings
            preset = 'default',
            ['<CR>'] = {
                -- function(cmp)
                --     local ok, autopairs = pcall(require, "nvim-autopairs.completion.cmp")
                --     local cb = ok and autopairs.on_confirm_done() or nil
                --     return cmp.accept({
                --         callback = cb,
                --     })
                -- end,
                'accept', -- returns false if comp menu is not selected
                function()
                    local ok, sidekick = pcall(require, 'sidekick.nes')
                    if ok then sidekick.apply() end
                end,
                'fallback',
            },
            ['<Tab>'] = {
                'snippet_forward',
                'fallback',
            },
            ['<S-Tab>'] = {
                'snippet_backward',
                'fallback',
            },
            ['<C-l>'] = {
                'snippet_forward',
                'fallback',
            },
            ['<C-h>'] = {
                'snippet_backward',
                'fallback',
            },
            ['<C-p>'] = {
                'select_prev',
                'show',
            },
            ['<C-n>'] = {
                'select_next',
                'show',
            },
        },
        cmdline = {
            keymap = {
                preset = 'inherit',
                ['<CR>'] = {
                    'accept_and_enter',
                    'fallback',
                },
                ['<C-p>'] = {
                    'fallback',
                },
                ['<C-n>'] = {
                    'fallback',
                },
                ['<Tab>'] = {
                    'select_next',
                    'fallback',
                },
                ['<S-Tab>'] = {
                    'select_prev',
                    'fallback',
                },
            },
            sources = { 'cmdline' },
            completion = {
                menu = {
                    auto_show = true,
                    draw = {
                        columns = {
                            { 'label' },
                        },
                    }
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
            },

        },
        fuzzy = {
            implementation = 'prefer_rust_with_warning',
            sorts = {
                'score',     -- Primary sort: by fuzzy matching score
                'sort_text', -- Secondary sort: by sortText field if scores are equal
                'label',     -- Tertiary sort: by label if still tied
            },
        },
        -- TODO: create ISSUE, request signature includes markdown body
        signature = {
            enabled = false,
        },
        snippets = {
            preset = 'luasnip',
        },
    },
    opts_extend = { 'sources.default' }
}
