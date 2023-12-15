---@diagnostic disable: missing-fields
M = {}

table.insert(M, {
    'hrsh7th/nvim-cmp',
    enabled = true,
    dependencies = {
        'onsails/lspkind-nvim',
    },
    lazy = true,
    config = function()
        local cmp = require('cmp')
        local mapping = require('cmp.config.mapping')

        -- Determine if Copilot is currently visible with an active suggestion
        local copilot_visible = function()
            return require 'tummetott.utils'.is_loaded('copilot.lua') and
                require 'copilot.suggestion'.is_visible()
        end

        cmp.setup {
            -- The order in which I specify sources defines the priority
            sources = cmp.config.sources({
                { name = 'luasnip' },
                { name = 'nvim_lsp' },
                { name = 'path' },
                {
                    name = 'buffer',
                    keyword_length = 3,
                    max_item_count = 10,
                },
                { name = 'emoji' },
            }),
            -- This section defines the look of the completion popup. The plugin
            -- lspkind adds nerdfonts and takes care about the formatting.
            formatting = {
                format = require('lspkind').cmp_format({
                    -- Don't write the type of completion, just show the icon
                    mode = 'symbol',
                    maxwidth = 50,
                    -- Show the completion source
                    menu = {
                        buffer = 'BUF',
                        nvim_lsp = 'LSP',
                        path = 'PATH',
                        luasnip = 'SNIP',
                        ['buffer-lines'] = 'LINE',
                        spell = 'SPELL',
                    },
                }),
                -- Don't show tilde char after snippet
                expandable_indicator = false,
            },
            completion = {
                completeopt = 'menu,menuone,noinsert,noselect'
            },
            window = {
                completion = {
                    winhighlight = 'CursorLine:Visual,Search:None',
                    border = 'rounded',
                },
                documentation = {
                    winhighlight = 'Error:None,Search:None',
                    border = 'rounded',
                },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = {
                ['<C-n>'] = mapping {
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        elseif copilot_visible() then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end,
                    c = mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                },
                ['<C-p>'] = mapping {
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                        elseif copilot_visible() then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end,
                    c = mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                },
                ['<Up>'] = mapping.scroll_docs(-4),
                ['<Down>'] = mapping.scroll_docs(4),
                ['<C-y>'] = mapping(mapping.confirm { select = true }, { 'i', 'c' }),
                ['<C-e>'] = mapping(mapping.abort(), { 'i', 'c' }),
                ['<C-d>'] = mapping(function(fallback)
                    if cmp.get_selected_entry() then
                        cmp.select_next_item { count = 5, behavior = cmp.SelectBehavior.Select }
                    else
                        fallback()
                    end
                end),
                ['<C-u>'] = mapping(function(fallback)
                    if cmp.get_selected_entry() then
                        cmp.select_prev_item { count = 5, behavior = cmp.SelectBehavior.Select }
                    else
                        fallback()
                    end
                end),
                ['<CR>'] = mapping(mapping.confirm { select = false }, { 'i' }),
                ['<TAB>'] = mapping {
                    i = mapping.confirm { select = false },
                    c = mapping.select_next_item { behavior = cmp.SelectBehavior.insert },
                },
                ['<S-TAB>'] = mapping(mapping.select_prev_item {
                    behavior = cmp.SelectBehavior.insert
                }, { 'c' }),
                ['<C-l>'] = mapping(function()
                    if require('luasnip').jumpable(1) then
                        require('luasnip').jump(1)
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = mapping(function()
                    if require('luasnip').jumpable(-1) then
                        require('luasnip').jump(-1)
                    end
                end, { 'i', 's' }),
                ['<C-x><C-l>'] = cmp.mapping.complete {
                    config = {
                        sources = {
                            {
                                name = 'buffer-lines',
                                option = { leading_whitespace = false },
                            }
                        },
                    }
                },
            },
        }
        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
            formatting = {
                -- Only show the completion itself, no icon, no completion source
                fields = { 'abbr' },
            },
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline' }
            })
        })
    end,
})

table.insert(M, {
    'hrsh7th/cmp-buffer',
    enabled = true,
    event = 'InsertEnter',
})

table.insert(M, {
    'hrsh7th/cmp-nvim-lsp',
    enabled = true,
    event = 'InsertEnter',
})

table.insert(M, {
    'hrsh7th/cmp-emoji',
    enabled = true,
    event = 'InsertEnter',
})

table.insert(M, {
    'saadparwaiz1/cmp_luasnip',
    enabled = true,
    event = 'InsertEnter',
})

table.insert(M, {
    'hrsh7th/cmp-path',
    enabled = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
})

table.insert(M, {
    'hrsh7th/cmp-cmdline',
    enabled = true,
    event = 'CmdlineEnter',
})

table.insert(M, {
    'amarakon/nvim-cmp-buffer-lines',
    enabled = true,
    event = 'InsertEnter',
})

return M
