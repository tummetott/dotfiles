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
            {
                '<leader>f',
                group = 'Find',
                icon = vim.g.nerdfonts and '󰍉' or nil,
            },
            {
                '<leader><space>',
                desc = 'Show References',
                icon = vim.g.nerdfonts and '󰉄' or nil,
            },
        }
    end,
    config = function(_, opts)
        require('snacks').setup(opts)

        -- HACK: Hides the framed hunk context above each hunk in diff
        -- previews. The picker forwards no options to the diff renderer.
        local diff = require('snacks.picker.util.diff')
        local render = diff.render
        diff.render = function(buf, ns, lines, render_opts)
            render_opts = vim.tbl_extend('force', render_opts or {}, { hunk_header = false })
            return render(buf, ns, lines, render_opts)
        end

        local indent = Snacks.toggle.indent()
        indent.opts.name = 'indent guides'
        indent:map('<c-,>e')
    end,
    opts = {
        styles = {
            float = { backdrop = false },
            zoom_indicator = {
                text = ' 󰊓 Zoom ',
                row = 0,
                -- Last column
                col = function(self) return vim.o.columns - self.opts.width end,
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
        image = {
            -- ISSUE: currently not supported in zellij.
            -- https://github.com/zellij-org/zellij/issues/5530
            enabled = true,
        },
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
            -- Sources without a layout of their own open in ivy
            layout = { preset = 'ivy' },
            -- Default layout is ivy, so the default win needs ivy keymaps
            win = picker_keymaps.compose { 'ivy' },
            -- Ivy always opens fullscreen. Set on the preset, since fullscreen in the
            -- fallback layout would also reach sources that bring their own preset.
            layouts = { ivy = { fullscreen = true } },
            sources = {
                files = {
                    hidden = true,
                    exclude = { '.DS_Store' },
                    layout = { preset = 'ivy' },
                    win = picker_keymaps.compose {
                        'ivy', 'hidden', 'ignored', 'symlinks', 'live', 'trouble',
                    },
                },
                grep = {
                    hidden = true,
                    -- Drop the column number from the rendered entry.
                    format = function(item, picker)
                        local pos = item.pos
                        if pos then
                            item.pos = { pos[1], 0 }
                        end
                        local chunks = Snacks.picker.format.file(item, picker)
                        item.pos = pos
                        -- Drop the treesitter highlighting of the grepped line.
                        -- Its colours compete with the match highlight.
                        for i = #chunks, 1, -1 do
                            if chunks[i].hl_group and chunks[i].hl_group ~= 'SnacksPickerMatch' then
                                table.remove(chunks, i)
                            end
                        end
                        return chunks
                    end,
                    layout = { preset = 'dropdown', fullscreen = true },
                    win = picker_keymaps.compose {
                        'dropdown', 'hidden', 'ignored', 'symlinks', 'regex',
                        'live', 'trouble',
                    },
                },
                recent = {
                    layout = { preset = 'ivy' },
                    win = picker_keymaps.compose { 'ivy', 'trouble' },
                },
                git_log = {
                    layout = { preset = 'ivy' },
                    win = picker_keymaps.compose { 'ivy', 'live' },
                },
                gh_issue = {
                    layout = { preset = 'ivy' },
                    win = picker_keymaps.compose { 'ivy', 'state', 'live' },
                },
                gh_pr = {
                    layout = { preset = 'ivy' },
                    win = picker_keymaps.compose { 'ivy', 'state', 'live' },
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
                spelling = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_keymaps.compose { 'vertical' },
                },
                icons = {
                    layout = { preset = 'vertical', hidden = { 'preview' } },
                    win = picker_keymaps.compose { 'vertical' },
                },
                explorer = {
                    hidden = true,
                    exclude = { '.DS_Store' },
                    diagnostics = false,
                    formatters = { file = { git_status_hl = false } },
                    win = picker_keymaps.compose {
                        'sidebar', 'hidden', 'ignored', 'live',
                    },
                },
            },
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
                confirm = 'jump',
                -- Don't use a sidekick tab as jump target
                jump = function(picker, item, action)
                    local agent = require 'tummetott.utils.agent'
                    if agent.is_agent_tab(vim.api.nvim_win_get_tabpage(picker.main)) then
                        local tab = agent.get_back_tab()
                        if tab then
                            picker.main = vim.api.nvim_tabpage_get_win(tab)
                        end
                    end
                    require('snacks.picker.actions').jump(picker, item, action)
                end,
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
        },
        scratch = {
            enabled = true,
            win = {
                on_win = function(win)
                    -- Close scratch float when not focused
                    vim.api.nvim_create_autocmd('WinLeave', {
                        group = win.augroup,
                        callback = function()
                            vim.schedule(function()
                                if win:valid()
                                    and vim.api.nvim_get_current_win() ~= win.win then
                                    win:hide()
                                end
                            end)
                        end,
                        once = true,
                    })
                    -- Don't zoom scratch buffers
                    if vim.bo[win.buf].filetype ~= 'lua' then
                        vim.keymap.set('n', '<cr>', '<cr>', {
                            buffer = win.buf,
                            remap = false,
                        })
                    end
                end,
            },
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
                    desc = 'Jump to Left Window',
                },
                list_down = {
                    '<c-n>',
                    function()
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker.list:move(vim.v.count1)
                        end
                    end,
                    desc = 'Next Item',
                },
                list_up = {
                    '<c-p>',
                    function()
                        local picker = Snacks.picker.get()[1]
                        if picker then
                            picker.list:move(-vim.v.count1)
                        end
                    end,
                    desc = 'Previous Item',
                },
            },
        },
        gitbrowse = {
            notify = false,
            remote_patterns = {
                { 'ssh%.gitlab%.srlabs%.de'           , 'gitlab.srlabs.de' },
                -- Upstream defaults, which snacks replaces rather than
                -- merges as soon as this list is given.
                { '^(https?://.*)%.git$'              , '%1' },
                { '^git@(.+):(.+)%.git$'              , 'https://%1/%2' },
                { '^git@(.+):(.+)$'                   , 'https://%1/%2' },
                { '^git@(.+)/(.+)$'                   , 'https://%1/%2' },
                { '^org%-%d+@(.+):(.+)%.git$'         , 'https://%1/%2' },
                { '^ssh://git@(.*)$'                  , 'https://%1' },
                { '^ssh://([^:/]+)(:%d+)/(.*)$'       , 'https://%1/%3' },
                { '^ssh://([^/]+)/(.*)$'              , 'https://%1/%2' },
                { 'ssh%.dev%.azure%.com/v3/(.*)/(.*)$', 'dev.azure.com/%1/_git/%2' },
                { '^https://%w*@(.*)'                 , 'https://%1' },
                { '^git@(.*)'                         , 'https://%1' },
                { ':%d+'                              , '' },
                { '%.git$'                            , '' },
            },
            url_patterns = {
                ['gitlab%.srlabs%.de'] = {
                    branch = '/tree/{branch}',
                    commit = '/commit/{commit}',
                    file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
                    permalink = '/blob/{commit}/{file}#L{line_start}-L{line_end}',
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
                    ii = { desc = 'Inner Scope' },
                    ai = { desc = 'Full Scope' },
                },
                jump = {
                    ['[i'] = { desc = 'Top Edge of Scope' },
                    [']i'] = { desc = 'Bottom Edge of Scope' },
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
        -- SnacksPickerDirectory = { fg = 'purple' },
        SnacksPickerRow = { link = 'LineNr' },
        SnacksPickerMatch = { fg = 'yellow' },
        SnacksPickerToggle = { fg = 'gray' },
        SnacksPickerPathHidden = { link = 'SnacksPickerFile' },
        SnacksPickerPathIgnored = { fg = 'gray' },
        SnacksPickerGitStatusIgnored = { fg = 'gray' },
        SnacksPickerGitStatusModified = { fg = 'orange' },
        SnacksPickerGitStatusUntracked = { fg = 'dark_gray' },
        SnacksPickerGitStatusStaged = { fg = 'green' },
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
            function()
                if vim.fn.winnr('$') > 1 then
                    Snacks.toggle.zoom():toggle()
                end
            end,
            desc = 'Zoom Window',
        },
        {
            '<c-cr>',
            function() Snacks.terminal.toggle() end,
            mode = { 'n', 't' },
            desc = 'Toggle Terminal',
        },
        {
            '<c-s>',
            function() Snacks.explorer() end,
            desc = 'File Tree',
        },
        {
            '<leader>os',
            function() Snacks.scratch() end,
            desc = 'Scratch Buffer',
        },
        {
            '<Leader>ff',
            function() Snacks.picker.files() end,
            desc = 'File',
        },
        {
            '<Leader>fg',
            function() Snacks.picker.grep() end,
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
            '<Leader>fn',
            function()
                Snacks.picker.files({
                    cwd = '~/.local/share/chezmoi/dot_config/nvim',
                    title = 'Nvim config',
                })
            end,
            desc = 'Nvim Config',
        },
        {
            '<Leader>fN',
            function()
                Snacks.picker.files({
                    cwd = '~/.local/share/nvim/lazy',
                    title = 'Nvim plugins',
                })
            end,
            desc = 'Nvim Plugins',
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
            function() Snacks.picker.buffers() end,
            desc = 'Buffer',
        },
        {
            '<Leader>fr',
            function() Snacks.picker.recent() end,
            desc = 'Recent',
        },
        {
            ']]',
            function()
                require('tummetott.utils.words').jump(vim.v.count1)
            end,
            desc = 'Next Reference Under Cursor',
        },
        {
            '[[',
            function()
                require('tummetott.utils.words').jump(-vim.v.count1)
            end,
            desc = 'Previous Reference Under Cursor',
        },
        {
            '<leader><space>',
            function()
                require('tummetott.utils.words').show()
            end,
            desc = 'Show References',
        },
        {
            '<Leader>fu',
            function() Snacks.picker.undo() end,
            desc = 'Undotree',
        },
        {
            '<Leader>ol',
            function() Snacks.picker.git_log() end,
            desc = 'Git Log',
        },
        {
            '<Leader>f/',
            function() Snacks.picker.search_history() end,
            desc = 'Search History',
        },
        {
            '<Leader>f:',
            function() Snacks.picker.command_history() end,
            desc = 'Cmdline History',
        },
        {
            '<c-/>',
            function()
                local cmdtype, line = vim.fn.getcmdtype(), vim.fn.getcmdline()
                local source = (cmdtype == '/' or cmdtype == '?')
                    and 'search_history' or 'command_history'
                vim.schedule(function()
                    Snacks.picker[source]({ pattern = line })
                end)
                return '<c-c>'
            end,
            mode = 'c',
            expr = true,
            desc = 'Cmdline or Search History',
        },
        {
            'z=',
            function() Snacks.picker.spelling() end,
            desc = 'Spelling Suggestions',
        },
        {
            '<leader>fi',
            function() Snacks.picker.icons() end,
            desc = 'Icon',
        },
        {
            '<leader>fj',
            function() Snacks.picker.jumps() end,
            desc = 'Jumplist',
        },
        {
            '<leader>fp',
            function() Snacks.picker.projects() end,
            desc = 'Project',
        },
        {
            '<leader>oi',
            function() Snacks.picker.gh_issue() end,
            desc = 'Git Issues',
        },
        -- GitHub only. Previews each PR and offers actions such as checkout,
        -- review, comment, and merge.
        {
            '<leader>op',
            function() Snacks.picker.gh_pr() end,
            desc = 'Git PRs',
        },
        -- GitHub and GitLab. Checks out the selected PR directly.
        {
            '<leader>gp',
            function() require('tummetott.utils.pr').checkout() end,
            desc = 'Checkout PR',
        },
        {
            '<leader>yp',
            function()
                local from, to = vim.fn.line('v'), vim.fn.line('.')
                from, to = math.min(from, to), math.max(from, to)
                -- Visual mode is left before the flash, since the selection
                -- highlight would otherwise cover it.
                vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'nx', false)
                vim.hl.range(0, vim.api.nvim_create_namespace('GitPermalink'),
                    'YankyYanked', { from - 1, 0 }, { to - 1, 0 },
                    { regtype = 'V', timeout = 200 })
                Snacks.gitbrowse {
                    what = 'permalink',
                    line_start = from,
                    line_end = to,
                    open = function(url) vim.fn.setreg('+', url) end,
                }
            end,
            mode = { 'n', 'v' },
            desc = 'Permalink',
        },
        {
            '<leader>ob',
            function() Snacks.gitbrowse { what = 'permalink' } end,
            mode = { 'n', 'v' },
            desc = 'Permalink in Browser',
        },
    }
}
