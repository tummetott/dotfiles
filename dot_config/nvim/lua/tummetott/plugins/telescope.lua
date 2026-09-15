local M = {}

table.insert(M, {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.nerdfonts }
    },
    init = function()
        require('which-key').add {
            { "<leader>f", group = "Find" },
        }
    end,
    config = function()
        local layout = require 'telescope.actions.layout'
        local actions = require 'telescope.actions'
        require('telescope').setup {
            defaults = {
                prompt_prefix = vim.g.nerdfonts and ' ' or '> ',
                selection_caret = vim.g.nerdfonts and ' ' or '> ',
                preview = {
                    hide_on_startup = true,
                },
                cycle_layout_list = { 'vertical', 'horizontal' },
                mappings = {
                    i = {
                        -- Open the preview window
                        ['<C-o>'] = layout.toggle_preview,
                        -- Telescope binds C-u, C-d, C-f and C-k to preview
                        -- scrolling, which shadows my insert mode line editing
                        -- and cursor movement. The arrow keys scroll the
                        -- preview instead.
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                        ['<C-f>'] = false,
                        ['<C-k>'] = false,
                        ['<Up>'] = actions.preview_scrolling_up,
                        ['<Down>'] = actions.preview_scrolling_down,
                        ['<Left>'] = actions.preview_scrolling_left,
                        ['<Right>'] = actions.preview_scrolling_right,
                        -- I prefer to open a file in a horizontal split with C-s instead of C-x
                        ['<C-s>'] = actions.select_horizontal,
                        ['<C-x>'] = false,
                        -- Copy fuzzy result to cmdline but don't execute it
                        ['<C-z>'] = actions.edit_command_line,
                        -- Open selected entries in trouble
                        ['<C-q>'] = require("trouble.sources.telescope").open,
                        -- Append selected entries to trouble
                        ['<C-y>'] = require("trouble.sources.telescope").add,
                        ['<esc>'] = actions.close,
                    },
                }
            },
            pickers = {
                buffers = {
                    ignore_current_buffer = true,
                    sort_lastused = true,
                    theme = 'dropdown',
                    mappings = {
                        i = {
                            ['<c-d>'] = actions.delete_buffer,
                        }
                    }
                },
                lsp_code_actions = {
                    theme = 'cursor',
                }
            },
        }
    end,
    cmd = 'Telescope',
    keys = {
        {
            '<Leader>ff',
            function() require 'telescope.builtin'.find_files() end,
            desc = 'File'
        },
        {
            '<Leader>fg',
            function() require 'telescope.builtin'.live_grep() end,
            desc = 'Grep',
        },
        {
            '<Leader>fw',
            function() require 'telescope.builtin'.grep_string() end,
            desc = 'Word under cursor',
        },
        {
            '<Leader>fb',
            function() require 'telescope.builtin'.buffers() end,
            desc = 'Buffer',
        },
        {
            '<Leader>fh',
            function() require 'telescope.builtin'.help_tags() end,
            desc = 'Help',
        },
        {
            '<Leader>fo',
            function() require 'telescope.builtin'.oldfiles() end,
            desc = 'Oldfile',
        },
        {
            '<Leader>fm',
            function() require 'telescope.builtin'.man_pages() end,
            desc = 'Man page',
        },
        {
            '<Leader>fs',
            function() require 'telescope.builtin'.spell_suggest() end,
            desc = 'Spell suggest',
        },
        {
            '<Leader>fc',
            function() require 'telescope.builtin'.colorscheme() end,
            desc = 'Colorscheme',
        },
        {
            '<Leader>fi',
            function() require 'telescope.builtin'.git_commits() end,
            desc = 'Git commit',
        },
        {
            '<Leader>fr',
            function() require 'telescope.builtin'.lsp_references() end,
            desc = 'LSP references',
        },
        {
            '<Leader>f/',
            function() require 'telescope.builtin'.search_history() end,
            desc = 'Search history',
        },
        {
            '<Leader>fd',
            function()
                require 'telescope.builtin'.find_files({
                    cwd = '~/.local/share/chezmoi/',
                    prompt_title = 'Dotfiles',
                })
            end,
            desc = 'Dotfile',
        },
        {
            '<Leader>fn',
            function()
                require 'telescope.builtin'.find_files({
                    cwd = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Perlite/',
                    prompt_title = 'Obsidian Notes',
                    find_command = {
                        'rg', '--files', '--iglob', '*.md',
                    },
                })
            end,
            desc = 'Obsidian Notes',
        },
        {
            '<Leader>fq',
            function() require 'telescope.builtin'.quickfixhistory() end,
            desc = 'Quickfix history',
        },
        {
            '<Leader>fa',
            function() require 'telescope.builtin'.autocommands() end,
            desc = 'Autocommands',
        },
        {
            '<Leader>fk',
            function() require 'telescope.builtin'.keymaps() end,
            desc = 'Keymaps',
        },
        {
            -- When inside cmdline, search the cmdline history with CTRL-/
            '<C-/>',
            function()
                if vim.fn.getcmdtype() == ':' then
                    require 'telescope.builtin'.command_history()
                end
            end,
            desc = 'Cmdline history',
            mode = 'c',
        },
    },
})

table.insert(M, {
    'nvim-telescope/telescope-fzf-native.nvim',
    enabled = true,
    build = 'make --silent',
    cond = vim.fn.executable('make') == 1,
    lazy = true,
    config = function()
        -- During bootstrap, this extension might not be built yet. Therefore,
        -- we wrap the require in a pcall
        pcall(function()
            require('telescope').load_extension('fzf')
        end)
    end,
})

table.insert(M, {
    'debugloop/telescope-undo.nvim',
    enabled = true,
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = {
        {
            '<leader>fu',
            function() require('telescope').extensions.undo.undo() end,
            desc = 'Undotree',
        }
    }
})

return M
