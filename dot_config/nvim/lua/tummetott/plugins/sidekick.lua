return {
    'folke/sidekick.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function(_, opts)
        require('sidekick').setup(opts)

        -- Send one NES update shortly after startup.
        -- Reason: Copilot's Next Edit Suggestions (NES) won't respond to the
        -- very first manual update call unless the LSP has already received a
        -- valid text synchronization event. This deferred update "warms up"
        -- Copilot so the first <C-,> trigger works without requiring a manual
        -- edit beforehand.
        vim.defer_fn(function()
            pcall(function()
                require('sidekick.nes').update()
            end)
        end, 1000)

        -- Find a non-terminal window in the current tabpage (your code window)
        local function find_window_nr()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "" then
                    return win
                end
            end
        end

        local function parse_location(buf)
            local row = vim.api.nvim_win_get_cursor(0)[1] -- 1-based
            local total = vim.api.nvim_buf_line_count(buf)

            -- current line + next two lines (because of possible line wrap)
            local stop = math.min(row + 2, total)
            local lines = vim.api.nvim_buf_get_lines(buf, row - 1, stop, false)

            -- Cut of the first two characters of wrapped lines. they are always
            -- padding
            for i = 2, #lines do
                lines[i] = lines[i]:sub(3)
            end

            local text = table.concat(lines, "")
            local path, lnum = text:match("([%w%._%-%/]+):(%d+)")
            if not path or not lnum then
                return nil
            end

            return path, tonumber(lnum)
        end

        local function jump_to_location(buf)
            local path, lnum = parse_location(buf)
            local jump = path
                and lnum
                and vim.fn.filereadable(path) == 1
                and find_window_nr()

            if not jump then
                return vim.cmd("normal! <C-]>")
            end

            vim.api.nvim_set_current_win(jump)
            vim.cmd("edit " .. vim.fn.fnameescape(path))
            vim.api.nvim_win_set_cursor(jump, { lnum, 0 })
            vim.cmd("normal! zz")
        end

        vim.api.nvim_create_autocmd("TermOpen", {
            callback = function(ctx)
                vim.keymap.set(
                    "n",
                    "<C-]>",
                    function() jump_to_location(ctx.buf) end,
                    { buffer = ctx.buf }
                )
            end,
        })
    end,
    opts = {
        nes = {
            enabled = true,
            trigger = {
                -- Trigger 'next suggestion' when i accepted a previous
                -- suggestion
                events = {
                    'User SidekickNesDone',
                },
            },
        },
        cli = {
            win = {
                keys = {
                    prompt = {
                        '<c-o>',
                        'prompt',
                        mode = 't',
                        desc = 'insert prompt or context',
                    },
                }
            }
        },
    },
    keys = {
        {
            '<c-,>',
            function()
                -- Close the blink window if a copilot suggestion is fetched
                local ok, blink = pcall(require, 'blink.cmp')
                if ok and blink.is_menu_visible() then
                    blink.cancel()
                end
                require('sidekick.nes').update()
            end,
            desc = 'Get a copilot suggestion',
            mode = { 'n', 'i' },
        },
        {
            '<cr>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    return '<cr>'
                end
            end,
            expr = true,
            mode = { 'n' }, -- Insert mode mapping in blink.nvim
            desc = 'Apply Copilot Suggestion'
        },
        {
            '<c-y>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    return '<c-y>'
                end
            end,
            expr = true,
            mode = { 'n', 'i' },
            desc = 'Apply Copilot Suggestion'
        },
        {
            '<c-f>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').apply()
                else
                    vim.api.nvim_input('<Right>')
                end
            end,
            mode = 'i',
            desc = 'Apply Suggestion or Move Right'
        },
        {
            '<c-e>',
            function()
                if require('sidekick.nes').have() then
                    require('sidekick.nes').clear()
                else
                    return '<c-e>'
                end
            end,
            expr = true,
            mode = 'n', -- Insert mode mapping in blink.cmp
            desc = 'Clear Copilot Suggestion'
        },
        {
            '<c-.>',
            function() require('sidekick.cli').toggle({ filter = { installed = true } }) end,
            desc = 'Sidekick Toggle',
            mode = { 'n', 't', 'i', 'x' },
        },
        {
            '<leader>js',
            function() require('sidekick.cli').select() end,
            desc = 'Select CLI',
        },
        {
            '<leader>jd',
            function() require('sidekick.cli').close() end,
            desc = 'Detach a CLI Session',
        },
        {
            '<leader>jt',
            function() require('sidekick.cli').send({ msg = '{this}' }) end,
            mode = { 'x', 'n' },
            desc = 'Send This',
        },
        {
            '<leader>jf',
            function() require('sidekick.cli').send({ msg = '{file}' }) end,
            desc = 'Send File',
        },
        {
            '<leader>jv',
            function() require('sidekick.cli').send({ msg = '{selection}' }) end,
            mode = { 'x' },
            desc = 'Send Visual Selection',
        },
        {
            '<leader>jp',
            function() require('sidekick.cli').prompt() end,
            mode = { 'n', 'x' },
            desc = 'Sidekick Select Prompt',
        },
        -- Enable <C-n>/<C-p> navigation for Codex selection menus by
        -- translating them to arrow keys in terminal mode. This overrides
        -- default nvim terminal-mode behavior globally; verify no other
        -- terminal workflows rely on these keys.
        {
            '<c-n>',
            '<down>',
            mode = 't',
            desc = 'Down',
        },
        {
            '<c-p>',
            '<up>',
            mode = 't',
            desc = 'Up',
        },
    },
}
