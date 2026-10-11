local M = {}

M.prompts = {
    no_history = "You're narrating your own edit history instead of stating the current, settled truth. Write in present tense: keep the standing reason it has to be this way, drop anything about what it used to be, what changed, or why you changed it.",
    explain = "Describe this to a non-domain expert",
    tempfile = "Write your most recent response, properly formatted as markdown, to a new temporary file. Reply with only that file's path, no other text.",
    conversation = "Don't do any changes. We're just having a conversation.",
}

local last_agent_tab
local back_tab

local function has_agent(tab)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        if vim.w[win].sidekick_session_id then
            return true
        end
    end
    return false
end

-- Sidekick opens agents in a split or a float. This opens each in a tab page of
-- its own, and switches to one that is already showing rather than reopening
-- it.
function M.open()
    require('sidekick.cli').select {
        filter = { installed = true },
        -- Overwrite the default callback that runs after the picker selects an
        -- agent. `focus` executes `startinsert`. This is desired for new agents,
        -- but not for existing ones, in order to preserve the viewport. An
        -- existing agent is therefore reached directly, without attaching.
        cb = function(state)
            if not state then
                return
            end

            local origin = vim.api.nvim_get_current_tabpage()
            if not has_agent(origin) then
                back_tab = origin
            end

            local running = state.terminal and state.terminal.win
                and vim.api.nvim_win_is_valid(state.terminal.win)
            if running then
                -- If that agent is already running, switch to it.
                vim.api.nvim_set_current_win(state.terminal.win)
            else
                -- Otherwise, open a new tabpage, attach a new agent to it
                -- and make the new window that is created the only one.
                vim.cmd.tabnew()
                state = require('sidekick.cli.state').attach(state, {
                    show = true,
                    focus = true,
                })
                if not (state.terminal and state.terminal:is_open()) then
                    vim.cmd.tabclose()
                    return
                end
                vim.cmd.only()
            end

            last_agent_tab = vim.api.nvim_get_current_tabpage()
        end,
    }
end

-- Jumps between an agent and the tab page it was reached from. With several
-- agents running, it returns to the one left last, and falls back to the
-- picker when none is reachable.
function M.toggle()
    local current = vim.api.nvim_get_current_tabpage()

    -- Remember which agent is being left, so the next toggle returns to it.
    if has_agent(current) then
        last_agent_tab = current
        if back_tab and back_tab ~= current
            and vim.api.nvim_tabpage_is_valid(back_tab) then
            vim.api.nvim_set_current_tabpage(back_tab)
        else
            vim.cmd.tabprevious()
        end
        return
    end

    back_tab = current

    -- Returning to a valid agent, or opening the picker
    if last_agent_tab and vim.api.nvim_tabpage_is_valid(last_agent_tab)
        and has_agent(last_agent_tab) then
        vim.api.nvim_set_current_tabpage(last_agent_tab)
    else
        M.open()
    end
end

function M.send_prompt(terminal)
    local opts = { prompt = 'CLI prompt' }
    local names = vim.tbl_keys(M.prompts)
    vim.ui.select(names, opts, function(choice)
        if choice then
            require('sidekick.cli').send {
                text = { { { M.prompts[choice] } } },
                filter = { name = terminal.tool.name },
            }
        end
    end)
end

return M
