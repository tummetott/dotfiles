local cat = require 'tummetott.utils.dashboard'
local picker_keymaps = require 'tummetott.utils.picker_keymaps'
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
        styles = {
            float = {
                backdrop = false,
            },
        },
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
            -- Badges in the picker title, naming each option that is active.
            toggles = {
                follow = '+symlinks',
                hidden = '+hidden',
                ignored = '+ignored',
                modified = 'only-modified',
                regex = { icon = 'no-regex', value = false },
                state = { icon = '+closed', value = 'all' },
            },
            actions = {
                trouble_open = function(picker)
                    require('trouble.sources.snacks')
                        .open(picker, { type = 'smart' })
                end,
                trouble_add = function(picker)
                    require('trouble.sources.snacks')
                        .open(picker, { type = 'smart', add = true })
                end,
                -- Toggles the GitHub pickers between open and all issues / PRs
                gh_toggle_state = function(picker)
                    if not picker.opts.source:find('^gh_') then
                        return
                    end
                    picker.opts.state =
                        picker.opts.state == 'all' and 'open' or 'all'
                    picker.list:set_target()
                    picker:find()
                end,
            },
            sources = {
                files = {
                    hidden = true,
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose {
                        'ivy', 'hidden', 'ignored', 'follow', 'live', 'trouble',
                    },
                },
                grep = {
                    hidden = true,
                    layout = { preset = 'dropdown', fullscreen = true },
                    win = picker_keymaps.compose {
                        'dropdown', 'hidden', 'ignored', 'follow', 'regex',
                        'live', 'trouble',
                    },
                },
                recent = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose { 'ivy', 'trouble' },
                },
                git_log = {
                    layout = {
                        preset = 'ivy',
                        fullscreen = true,
                        hidden = { 'preview' },
                    },
                    win = picker_keymaps.compose { 'ivy', 'live' },
                },
                gh_issue = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose { 'ivy', 'state', 'live' },
                },
                gh_pr = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose { 'ivy', 'state', 'live' },
                },
                yank_history = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose { 'ivy' },
                },
                undo = {
                    layout = { preset = 'ivy', fullscreen = true },
                    win = picker_keymaps.compose { 'ivy' },
                },
                buffers = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_keymaps.compose { 'vertical', 'modified', 'trouble' },
                },
                colorschemes = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_keymaps.compose { 'vertical' },
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
                    win = picker_keymaps.compose { 'vertical' },
                },
                command_history = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_keymaps.compose { 'vertical' },
                },
            },
            -- Named groups carry the shared keys along, so this is what
            -- reaches the pickers that have no entry above
            win = picker_keymaps.compose {},
        },
        scratch = {
            enabled = true,
        },
        zen = {
            enabled = true,
        },
        toggle = {
            notify = false,
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
        scope = {
            enabled = true,
            keys = {
                textobject = {
                    ii = { desc = 'Inner scope' },
                    ai = { desc = 'Full scope' },
                },
                jump = {
                    ['[i'] = { desc = 'Top edge of scope' },
                    [']i'] = { desc = 'Bottom edge of scope' },
                },
            },
        },
        statuscolumn = {
            enabled = true,
        },
        words = {
            enabled = true,
            modes = { 'n' },
        },
        -- notifier = { enabled = true },
        -- quickfile = { enabled = true },
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
        LspReferenceHidden = {},
        LspReferenceVisible = { bg = 'dark_gray' },
        LspReferenceText = { link = 'LspReferenceHidden' },
        LspReferenceRead = { link = 'LspReferenceHidden' },
        LspReferenceWrite = { link = 'LspReferenceHidden' },
    },
    keys = {
        {
            '<cr>',
            function() Snacks.toggle.zoom():toggle() end,
            desc = 'Zoom window',
        },
        {
            '<c-,>e',
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
            ']]',
            function()
                require('tummetott.utils.words').jump(vim.v.count1)
            end,
            desc = 'Next reference under cursor',
        },
        {
            '[[',
            function()
                require('tummetott.utils.words').jump(-vim.v.count1)
            end,
            desc = 'Previous reference under cursor',
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
            '<leader>gp',
            function()
                Snacks.picker.gh_pr()
            end,
            desc = 'Open GitHub pull requests',
        },
    }
}
