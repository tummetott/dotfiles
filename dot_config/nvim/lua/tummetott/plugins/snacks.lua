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

local ivy_win = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-l>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
            ['<c-l>'] = 'focus_preview',
        },
    },
    preview = {
        keys = {
            ['<c-h>'] = 'focus_input',
        },
    },
}

local dropdown_win = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-k>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
        },
    },
    preview = {
        keys = {
            ['<c-j>'] = 'focus_input',
        },
    },
}

local vertical_win = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
        },
    },
}

return {
    'folke/snacks.nvim',
    enabled = true,
    priority = 1000,
    lazy = false,
    init = function()
        require('which-key').add {
            { '<leader>f', group = 'Find' },
        }
    end,
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
            actions = {
                trouble_open = function(picker)
                    require('trouble.sources.snacks').open(picker, { type = 'smart' })
                end,
            },
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-q>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-o>'] = { 'trouble_open', mode = 'i' },
                        ['<c-a>'] = false,
                        ['<c-f>'] = false,
                        ['<c-b>'] = false,
                        ['<c-u>'] = false,
                        ['<c-d>'] = false,
                        ['<c-h>'] = false,
                        ['<c-j>'] = false,
                        ['<c-k>'] = false,
                        ['<c-l>'] = false,
                    },
                },
                preview = {
                    keys = {
                        ['<c-q>'] = 'toggle_preview',
                        ['<c-h>'] = '<nop>',
                        ['<c-j>'] = '<nop>',
                        ['<c-k>'] = '<nop>',
                        ['<c-l>'] = '<nop>',
                    },
                },
                list = {
                    keys = {
                        ['<c-q>'] = 'close',
                        ['<c-o>'] = 'trouble_open',
                        ['<c-h>'] = '<nop>',
                        ['<c-j>'] = '<nop>',
                        ['<c-k>'] = '<nop>',
                        ['<c-l>'] = '<nop>',
                    },
                },
            },
            layout = {
                layout = {
                    backdrop = false,
                }
            },
        },
        scratch = {
            enabled = true,
            win = {
                backdrop = false,
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
                focus_input = {
                    '<c-h>',
                    function()
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker:focus('input')
                        else
                            vim.cmd.wincmd({ 'h', count = vim.v.count1 })
                        end
                    end,
                    desc = 'Jump to left window',
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
        SnacksPickerDir = { fg = 'gray' },
        SnacksPickerMatch = { fg = 'blue' },
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
            '<leader>os',
            function() Snacks.scratch() end,
            desc = 'Scratch Buffer',
        },
        {
            '<Leader>ff',
            function()
                Snacks.picker.files({
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'File',
        },
        {
            '<Leader>fg',
            function()
                Snacks.picker.grep({
                    layout = {
                        preset = 'dropdown',
                        fullscreen = true,
                    },
                    win = dropdown_win,
                })
            end,
            desc = 'Grep',
        },
        {
            '<Leader>fd',
            function()
                Snacks.picker.files({
                    cwd = '~/.local/share/chezmoi',
                    title = 'Dotfiles',
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Dotfile',
        },
        {
            '<Leader>fn',
            function()
                Snacks.picker.files({
                    cwd = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Perlite',
                    title = 'Obsidian Notes',
                    ft = 'md',
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Obsidian Notes',
        },
        {
            '<Leader>fb',
            function()
                Snacks.picker.buffers({
                    layout = {
                        preset = 'vertical',
                        hidden = { 'preview' },
                    },
                    win = vertical_win,
                })
            end,
            desc = 'Buffer',
        },
        {
            '<Leader>fr',
            function()
                Snacks.picker.recent({
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Recent',
        },
        {
            '<Leader>gl',
            function()
                Snacks.picker.git_log({
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                        hidden = { 'preview' },
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Commit log',
        },
        {
            '<Leader>f/',
            function()
                Snacks.picker.search_history({
                    layout = {
                        preset = 'vertical',
                        hidden = { 'preview' },
                    },
                    win = vertical_win,
                })
            end,
            desc = 'Search history',
        },
        {
            -- When inside cmdline, search the cmdline history with CTRL-/
            '<Leader>f;',
            function()
                Snacks.picker.command_history({
                    layout = {
                        preset = 'vertical',
                        hidden = { 'preview' },
                    },
                    win = vertical_win,
                })
            end,
            desc = 'Cmdline history',
        },
        {
            '<leader>gi',
            function()
                Snacks.picker.gh_issue({
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Open GitHub issues',
        },
        {
            '<leader>gI',
            function()
                Snacks.picker.gh_issue({
                    state = 'all',
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'All GitHub issues',
        },
        {
            '<leader>gp',
            function()
                Snacks.picker.gh_pr({
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'Open GitHub pull requests',
        },
        {
            '<leader>gP',
            function()
                Snacks.picker.gh_pr({
                    state = 'all',
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                    },
                    win = ivy_win,
                })
            end,
            desc = 'All GitHub pull requests',
        },
    }
}
