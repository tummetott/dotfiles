local cat = require 'tummetott.utils.dashboard'
local picker_win = require 'tummetott.utils.picker'
local previous_colorscheme

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
                        vim.g.nerdfonts and cat.nerd or cat.ascii,
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
                    require('trouble.sources.snacks')
                        .open(picker, { type = 'smart' })
                end,
                trouble_add = function(picker)
                    require('trouble.sources.snacks')
                        .open(picker, { type = 'smart', add = true })
                end,
            },
            sources = {
                files = {
                    hidden = true,
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                grep = {
                    hidden = true,
                    layout = { preset = 'dropdown', fullscreen = true },
                    win = picker_win.dropdown,
                },
                recent = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                git_log = {
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                        hidden = { 'preview' },
                    },
                    win = picker_win.ivy,
                },
                gh_issue = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                gh_pr = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                yank_history = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                undo = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_win.ivy,
                },
                buffers = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_win.vertical,
                },
                colorschemes = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_win.vertical,
                    on_change = function(_, item)
                        if item then
                            vim.cmd.colorscheme(item.text)
                        end
                    end,
                    confirm = function(picker)
                        previous_colorscheme = nil
                        picker:close()
                    end,
                    on_close = function()
                        if previous_colorscheme then
                            vim.cmd.colorscheme(previous_colorscheme)
                        end
                    end,
                },
                search_history = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_win.vertical,
                },
                command_history = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_win.vertical,
                },
            },
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-q>'] = { 'close', mode = { 'n', 'i' } },
                        ['<c-o>'] = { 'trouble_open', mode = 'i' },
                        ['<c-y>'] = { 'trouble_add', mode = 'i' },
                        ['<c-i>'] = { 'toggle_ignored', mode = 'i' },
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
                        ['<c-n>'] = 'list_down',
                        ['<c-p>'] = 'list_up',
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
                        ['<c-y>'] = 'trouble_add',
                        ['<c-i>'] = 'toggle_ignored',
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
        scroll = {
            enabled = true,
        },
        -- notifier = { enabled = true },
        -- quickfile = { enabled = true },
        -- scope = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- words = { enabled = true },
    },
    highlights = {
        SnacksPickerDir = { link = 'SnacksPickerFile' },
        SnacksPickerMatch = { fg = 'blue' },
        SnacksDashboardHeader = { fg = 'blue' },
        SnacksDashboardFooter = { fg = 'dark_gray' },
        SnacksIndentScope = { fg = 'dark_gray' },
        SnacksInputBorder = { link = 'FloatBorder' },
        SnacksDiffContext = { bg = 'background' },
        SnacksDiffAddLineNr = { link = 'LineNr' },
        SnacksDiffDeleteLineNr = { link = 'LineNr' },
        SnacksDiffContextLineNr = { link = 'LineNr' },
        SnacksDiffConflictLineNr = { link = 'LineNr' },
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
                Snacks.picker.files()
            end,
            desc = 'File',
        },
        {
            '<Leader>fg',
            function()
                Snacks.picker.grep()
            end,
            desc = 'Grep',
        },
        {
            '<Leader>fd',
            function()
                Snacks.picker.files({
                    cwd = '~/.local/share/chezmoi',
                    title = 'Dotfiles',
                })
            end,
            desc = 'Dotfile',
        },
        {
            '<Leader>fo',
            function()
                Snacks.picker.files({
                    cwd = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Perlite',
                    title = 'Obsidian Note',
                    ft = 'md',
                })
            end,
            desc = 'Obsidian Notes',
        },
        {
            '<Leader>fc',
            function()
                -- Captured here rather than in `on_show`, which snacks fires
                -- only after the first list item has already been applied
                previous_colorscheme = vim.g.colors_name
                Snacks.picker.colorschemes()
            end,
            desc = 'Colorscheme',
        },
        {
            '<Leader>fb',
            function()
                Snacks.picker.buffers()
            end,
            desc = 'Buffer',
        },
        {
            '<Leader>fr',
            function()
                Snacks.picker.recent()
            end,
            desc = 'Recent',
        },
        {
            '<Leader>fu',
            function()
                Snacks.picker.undo()
            end,
            desc = 'Undotree',
        },
        {
            '<Leader>gl',
            function()
                Snacks.picker.git_log()
            end,
            desc = 'Commit log',
        },
        {
            '<Leader>f/',
            function()
                Snacks.picker.search_history()
            end,
            desc = 'Search history',
        },
        {
            -- When inside cmdline, search the cmdline history with CTRL-/
            '<Leader>f:',
            function()
                Snacks.picker.command_history()
            end,
            desc = 'Cmdline history',
        },
        {
            '<leader>gi',
            function()
                Snacks.picker.gh_issue()
            end,
            desc = 'Open GitHub issues',
        },
        {
            '<leader>gI',
            function()
                Snacks.picker.gh_issue({
                    state = 'all',
                })
            end,
            desc = 'All GitHub issues',
        },
        {
            '<leader>gp',
            function()
                Snacks.picker.gh_pr()
            end,
            desc = 'Open GitHub pull requests',
        },
        {
            '<leader>gP',
            function()
                Snacks.picker.gh_pr({
                    state = 'all',
                })
            end,
            desc = 'All GitHub pull requests',
        },
    }
}
