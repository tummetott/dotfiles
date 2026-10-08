local cat1 = [[
⠀⡀⠀⠀⠀⢠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠈⣿⢶⣦⡏⠙⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢀⣴⣿⣿⣿⣿⣾⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣿⡿⢛⣿⣿⣿⣿⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢀⣿⣷⣿⣿⣿⣿⠃⣾⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠺⠿⠿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣠⣄⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣷⣆⠀⠀⠀⠀
⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⠏⣾⣿⣿⣿⣿⣿⡀⠀⠀⠀
⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⡟⣰⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
⠀⠀⠀⠀⠻⣿⣿⣿⣿⢏⣴⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀
⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⢣⣿⡿⢟⣿⣿⣿⠀⠀
⠀⠀⠀⠀⠀⠀⢹⣷⣽⢻⣿⣿⠃⠞⣫⣴⣿⣿⣿⣿⡟⠀
⠀⠀⠀⠀⠀⢳⣄⠙⠇⢸⣿⠃⣠⣾⣿⣿⣿⣿⣿⣿⡇⠀
⠀⠀⠀⠀⠀⠀⢿⣷⣤⣈⠛⠀⢿⣿⣿⣿⣿⣿⣿⠟⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡉⠛⢿⣿⣶⣤⣈⣉⣉⣉⣉⣉⣰⣿⠄
⠀⠀⠀⠀⠀⠀⠏⢴⣷⡦⠌⠙⠻⢿⡿⠿⠿⠿⠿⠿⠃⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

local cat2 = [[
   ,_     _
   |\\_,-~/
   / _  _ |    ,--.
  (  @  @ )   / ,-'
   \  _T_/-._( (
   /         `. \
  |         _  \ |
   \ \ ,  /      |
    || |-_\__   /
   ((_/`(____,-'
]]

return {
    'folke/snacks.nvim',
    enabled = true,
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = {
            enabled = true,
            notify = false,
        },
        dashboard = {
            enabled = true,
            sections = {
                {
                    text = {
                        vim.g.nerdfonts and cat1 or cat2,
                        align = 'center',
                        hl = 'SnacksDashboardHeader',
                    }
                },
                {
                    text = {
                        (function()
                            local v = vim.version()
                            return string.format('NVIM v%d.%d.%d', v.major, v.minor, v.patch)
                        end)(),
                        align = 'center',
                        hl = 'SnacksDashboardFooter',
                    }
                },
                {
                    key = 'i',
                    action = '<CMD>enew <BAR> startinsert <CR>',
                    hidden = true
                },
                -- ISSUE: https://github.com/folke/snacks.nvim/issues/1678
                {
                    key = '<cr>',
                    action = '<CMD>enew<CR>',
                    hidden = true
                },
                {
                    key = '<c-q>',
                    action = function()
                        if require('dismiss').has_dismissable_win() then
                            require('dismiss').dismiss()
                        else
                            vim.cmd('quit')
                        end
                    end,
                    hidden = true
                }
            },
        },
        -- explorer = { enabled = true },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
            scope = {
                enabled = false,
            },
            filter = function(buf, win)
                return vim.g.snacks_indent ~= false and
                    vim.b[buf].snacks_indent ~= false and
                    vim.bo[buf].buftype == '' and
                    vim.wo[win].diff == false
            end
        },
        input = {
            enabled = true,
            win = {
                keys = {
                    i_esc = {
                        '<esc>',
                        { 'cmp_close', 'cancel' },
                        mode = 'i',
                        expr = true,
                    },
                },
            },
        },
        picker = {
            enabled = true,
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-l>'] = { 'focus_preview', mode = 'i' },
                    },
                },
                preview = {
                    keys = {
                        ['<c-q>'] = 'toggle_preview',
                        ['<c-n>'] = 'list_down',
                        ['<c-p>'] = 'list_up',
                    },
                },
            },
            layout = {
                layout = {
                    backdrop = false,
                }
            },
        },
        terminal = {
            enabled = true,
            win = {
                position = 'bottom',
                height = 0.8,
                -- Snacks names the terminal job in the winbar unless the
                -- window brings its own, so heirline's is handed over here
                wo = {
                    winbar = "%{%v:lua.require'heirline'.eval_winbar()%}",
                },
            },
        },
        gh = {
            enabled = true,
            keys = {
                -- HACK: https://github.com/folke/snacks.nvim/issues/2970
                select = {
                    '<cr>',
                    function(item)
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker:action('gh_actions')
                        else
                            require('snacks.gh.actions').actions.gh_actions
                                .action(item, { items = { item } })
                        end
                    end,
                    desc = 'Select Action',
                },
                list_down = {
                    '<c-n>',
                    function()
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker.list:move(vim.v.count1)
                        end
                    end,
                    desc = 'Next item',
                },
                list_up = {
                    '<c-p>',
                    function()
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker.list:move(-vim.v.count1)
                        end
                    end,
                    desc = 'Previous item',
                },
            },
        },
        -- notifier = { enabled = true },
        -- quickfile = { enabled = true },
        -- scope = { enabled = true },
        -- scroll = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- words = { enabled = true },
    },
    highlights = {
        SnacksDashboardHeader = { fg = 'blue' },
        SnacksDashboardFooter = { fg = 'dark_gray' },
        SnacksIndentScope = { fg = 'dark_gray' },
        SnacksInputBorder = { link = 'FloatBorder' },
    },
    keys = {
        {
            '<leader><space>e',
            function()
                local enabled = vim.b[0].snacks_indent == false
                vim.b[0].snacks_indent = enabled
                vim.cmd('redraw!')
                require 'tummetott.utils'.echo_toggle('Indent lines', enabled)
            end,
            desc = 'Indent lines',
        },
        {
            '<c-cr>',
            function() Snacks.terminal.toggle() end,
            mode = { 'n', 't' },
            desc = 'Toggle terminal',
        },
        {
            '<leader>gi',
            function() Snacks.picker.gh_issue() end,
            desc = 'Open GitHub issues',
        },
        {
            '<leader>gI',
            function() Snacks.picker.gh_issue({ state = 'all' }) end,
            desc = 'All GitHub issues',
        },
        {
            '<leader>gp',
            function() Snacks.picker.gh_pr() end,
            desc = 'Open GitHub pull requests',
        },
        {
            '<leader>gP',
            function() Snacks.picker.gh_pr({ state = 'all' }) end,
            desc = 'All GitHub pull requests',
        },
    }
}
