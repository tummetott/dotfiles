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

        -- Find a non-terminal window in the current tabpage (code window)
        local function find_window_nr()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "" then
                    return win
                end
            end
        end

        -- Parse a file reference starting at the WORD under the cursor.
        -- Supports:
        --   <path>
        --   <path>:<line>
        --   <path>:<line>-<range>
        -- Always jumps to the start line if present.
        local function parse_location(buf)
            local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row 1-based, col 0-based
            local total = vim.api.nvim_buf_line_count(buf)

            -- 1. Get current line
            local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

            -- 2. Find WORD boundaries in current line
            local before = line:sub(1, col + 1)
            local word_start = before:find("%S+$")
            if not word_start then
                return nil
            end

            -- 3. Cut everything before WORD start
            local text = line:sub(word_start)

            -- 4. Append next four lines to handle wrapping
            local stop = math.min(row + 4, total)
            local next_lines = vim.api.nvim_buf_get_lines(buf, row, stop, false)
            for _, l in ipairs(next_lines) do
                -- strip all leading whitespace from wrapped lines
                text = text .. l:gsub("^%s+", "")
            end

            -- 5. Clamp again to a single WORD (cut everything after it)
            local word = text:match("^(%S+)")
            if not word then
                return nil
            end

            -- 6. Extract path and optional starting line
            local path, lnum = word:match("^([%w%._%-%/]+):(%d+)")
            if path then
                return path, tonumber(lnum)
            end

            -- 7. Path only (no line)
            -- Strip trailing non-path characters (e.g. commas)
            local clean_path = word:match("^([%w%._%-%/]+)")
            if clean_path and vim.fn.filereadable(clean_path) == 1 then
                return clean_path, nil
            end

            return nil
        end

        local function jump_to_location(buf)
            local path, lnum = parse_location(buf)
            local target_win = path and vim.fn.filereadable(path) == 1 and find_window_nr()

            if not target_win then
                return vim.cmd("normal! <C-]>")
            end

            vim.api.nvim_set_current_win(target_win)
            vim.cmd("edit " .. vim.fn.fnameescape(path))

            if lnum then
                vim.api.nvim_win_set_cursor(target_win, { lnum, 0 })
                vim.cmd("normal! zz")
            end
        end

        -- Enable only in terminal buffers (Sidekick output)
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
