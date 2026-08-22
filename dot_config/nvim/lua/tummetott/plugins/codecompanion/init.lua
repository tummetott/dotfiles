-- Remembers each CLI buffer's window size across toggle hide/show cycles.
local cli_sizes = {}

-- Named CLI prompt snippets, picked via `vim.ui.select`.
local cli_prompts = {
    no_history = [[You're still narrating your own edit history instead of stating the current, settled truth. Rewrite this in present tense: keep the standing reason it has to be this way, drop anything about what it used to be, what changed, or why you changed it.]],
    explain = 'Describe this to a non-domain expert',
    tempfile = [[Write your most recent response, properly formatted as markdown, to a new temporary file. Reply with only that file's path, no other text.]],
}

-- Hides any visible CLI window, then focuses (or creates) the given agent's
-- session, so only one CLI pane is ever visible at a time.
local function switch_cli(agent)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'codecompanion_cli' then
            vim.api.nvim_win_hide(win)
        end
    end
    local cli = require('codecompanion.interactions.cli')
    local instance = cli.find_by_agent(agent) or cli.create({ agent = agent })
    instance.ui:open(cli_sizes[instance.bufnr])
    instance:focus()
end

return {
    'olimorris/codecompanion.nvim',
    enabled = true,
    -- Allows any 19.x release, blocks major version bumps.
    version = '^19.0.0',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    cmd = {
        'CodeCompanion',
        'CodeCompanionChat',
        'CodeCompanionCodeReview',
        'CodeCompanionCmd',
        'CodeCompanionCLI',
        'CodeCompanionActions',
    },
    init = function()
        require('which-key').add {
            { '<Leader>l', mode = { 'n', 'x' }, group = 'LLM' },
        }

        local cli_group = vim.api.nvim_create_augroup('codecompanion_cli_mode', { clear = true })
        local left_in_terminal_mode = {}

        -- Remembers whether the CLI buffer was in terminal mode right before losing focus.
        vim.api.nvim_create_autocmd('WinLeave', {
            group = cli_group,
            callback = function(args)
                if vim.bo[args.buf].filetype == 'codecompanion_cli' then
                    left_in_terminal_mode[args.buf] = vim.fn.mode() == 't'
                end
            end,
        })

        -- Restores terminal mode only if it was active when the buffer lost focus.
        vim.api.nvim_create_autocmd('BufEnter', {
            group = cli_group,
            callback = function(args)
                if vim.bo[args.buf].filetype == 'codecompanion_cli' and left_in_terminal_mode[args.buf] ~= false then
                    vim.cmd.startinsert()
                end
            end,
        })

        -- Captures the CLI window's size right before it closes (hide destroys the window).
        vim.api.nvim_create_autocmd('WinClosed', {
            group = cli_group,
            callback = function(args)
                if vim.bo[args.buf].filetype ~= 'codecompanion_cli' then
                    return
                end
                local win = tonumber(args.match)
                if not win or not vim.api.nvim_win_is_valid(win) then
                    return
                end
                cli_sizes[args.buf] = {
                    width = vim.api.nvim_win_get_width(win),
                    height = vim.api.nvim_win_get_height(win),
                }
            end,
        })

        -- Leaves visual mode once an inline edit has replaced the selection.
        vim.api.nvim_create_autocmd('User', {
            pattern = 'CodeCompanionInlineFinished',
            callback = function()
                vim.cmd('normal! <Esc>')
            end,
        })
    end,
    opts = {
        adapters = {
            http = {
                -- Needs apple-on-device API. See:
                -- https://github.com/gety-ai/apple-on-device-openai
                apple_on_device = function()
                    return require('codecompanion.adapters').extend('openai_compatible', {
                        formatted_name = 'Apple On-Device',
                        env = {
                            api_key = 'not-needed',
                            url = 'http://127.0.0.1:11535',
                            chat_url = '/v1/chat/completions',
                            models_endpoint = '/v1/models',
                        },
                        schema = {
                            model = {
                                default = 'apple-on-device',
                            },
                        },
                    })
                end,
            },
        },
        display = {
            diff = {
                enabled = false,
            },
            cli = {
                window = {
                    opts = {
                        number = false,
                        relativenumber = false,
                        signcolumn = 'no',
                    },
                },
            },
        },
        interactions = {
            cli = {
                agent = 'codex',
                opts = {
                    -- manually done by the autocmds above
                    auto_insert = false,
                },
                agents = {
                    claude_code = {
                        cmd = 'claude',
                        args = {},
                        description = 'Claude Code',
                    },
                    codex = {
                        cmd = 'codex',
                        args = {},
                        description = 'Codex',
                    },
                    opencode = {
                        cmd = 'opencode',
                        args = {},
                        description = 'OpenCode',
                    },
                },
                keymaps = {
                    win_left = {
                        modes = { n = '<C-h>', t = '<C-h>' },
                        callback = function()
                            vim.cmd.wincmd('h')
                        end,
                        description = 'Jump window left',
                    },
                    win_down = {
                        modes = { n = '<C-j>', t = '<C-j>' },
                        callback = function()
                            vim.cmd.wincmd('j')
                        end,
                        description = 'Jump window down',
                    },
                    win_up = {
                        modes = { n = '<C-k>', t = '<C-k>' },
                        callback = function()
                            vim.cmd.wincmd('k')
                        end,
                        description = 'Jump window up',
                    },
                    win_right = {
                        modes = { n = '<C-l>', t = '<C-l>' },
                        callback = function()
                            vim.cmd.wincmd('l')
                        end,
                        description = 'Jump window right',
                    },
                    prompt_picker = {
                        modes = { n = '<C-;>', t = '<C-;>' },
                        callback = function()
                            vim.ui.select(vim.tbl_keys(cli_prompts), { prompt = 'CLI prompt' }, function(choice)
                                if choice then
                                    require('codecompanion').cli(cli_prompts[choice], { submit = false, focus = true })
                                end
                            end)
                        end,
                        description = 'Insert prompt',
                    },
                },
            },
            chat = {
                adapter = {
                    name = 'openrouter',
                    model = 'openai/gpt-5.6-terra',
                },
            },
            inline = {
                adapter = {
                    name = 'openrouter',
                    model = 'openai/gpt-4.1-nano',
                },
            },
        },
        prompt_library = {
            markdown = {
                dirs = {
                    vim.fn.stdpath('config') .. '/lua/tummetott/plugins/codecompanion/prompts',
                },
            },
        },
    },
    keys = {
        {
            '<C-.>',
            function()
                local cli = require('codecompanion.interactions.cli')
                local instance = cli.last_cli()
                if not instance then
                    require('codecompanion').toggle_cli()
                    return
                end
                if instance.ui:is_visible_non_curtab() then
                    instance.ui:hide()
                end
                if instance.ui:is_visible() then
                    instance.ui:hide()
                else
                    instance.ui:open(cli_sizes[instance.bufnr])
                end
            end,
            mode = { 'n', 't', 'i', 'x' },
            desc = 'Toggle CLI',
        },
        {
            '<leader>lc',
            function()
                switch_cli('claude_code')
            end,
            desc = 'Claude Code',
        },
        {
            '<leader>lx',
            function()
                switch_cli('codex')
            end,
            desc = 'Codex',
        },
        {
            '<leader>lo',
            function()
                switch_cli('opencode')
            end,
            desc = 'OpenCode',
        },
        {
            '<leader>lp',
            function()
                require('codecompanion').prompt('polish')
            end,
            mode = 'v',
            desc = 'Polish text',
        },
        {
            '<leader>lr',
            function()
                require('codecompanion').cli('#{buffer}', { submit = false, focus = true })
            end,
            desc = 'Send reference',
        },
        {
            '<leader>lr',
            function()
                local start_line = math.min(vim.fn.line('v'), vim.fn.line('.'))
                local end_line = math.max(vim.fn.line('v'), vim.fn.line('.'))
                local range = start_line == end_line and start_line or start_line .. '-' .. end_line
                require('codecompanion').cli('#{buffer}:' .. range, { submit = false, focus = true })
            end,
            mode = 'x',
            desc = 'Send reference',
        },
        -- TODO: improve once
        -- https://github.com/olimorris/codecompanion.nvim/discussions/3311 is
        -- resolved
        {
            '<leader>lt',
            function()
                require('codecompanion').cli('#{this}', { submit = false, focus = true })
            end,
            mode = { 'n', 'x' },
            desc = 'Send text',
        },
    }
}
