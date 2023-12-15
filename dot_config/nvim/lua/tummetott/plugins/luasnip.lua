return {
    'L3MON4D3/LuaSnip',
    enabled = true,
    dependencies = 'rafamadriz/friendly-snippets',
    lazy = true,
    config = function()
        local ls = require('luasnip')
        local s = ls.snippet
        local sn = ls.snippet_node
        local isn = ls.indent_snippet_node
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local r = ls.restore_node
        local events = require('luasnip.util.events')
        local ai = require('luasnip.nodes.absolute_indexer')
        local fmt = require('luasnip.extras.fmt').fmt
        local rep = require('luasnip.extras').rep

        -- Config for luasnips
        ls.config.set_config({
            -- When true, jump back to a snipped even if you moved outside of the selection
            history = true,
            -- Define events when the snippets get updated. We want to have dynamic
            -- snippets so I choose to update them whenever the text changed
            updateevents = 'TextChanged,TextchangedI',
        })

        -- Load friendly snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        ls.add_snippets('sh', {
            s('ifhas', fmt('if command -v {} 1>/dev/null 2>&1 ; then\n    {}\nfi', {i(1, 'command'), i(0)})),
        })

        ls.add_snippets('lua', {
            s('keymap', fmt( "vim.keymap.set(\n    '{}',\n    '{}',\n    {},\n    {{ desc = '{}' }}\n)", {
                i(1, 'mode'),
                i(2, 'key-combo'),
                i(3, 'mapping'),
                i(0, 'description')
            }))
        })

        ls.add_snippets('lua', {
            s('hl', fmt("hl = {{ fg = '{}', bg = '{}' }},", {
                i(1, 'color'),
                i(0, 'color')
            }))
        })
    end
}
