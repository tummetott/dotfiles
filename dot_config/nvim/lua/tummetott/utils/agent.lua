local M = {}

M.prompts = {
    no_history = "You're narrating your own edit history instead of stating the current, settled truth. Write in present tense: keep the standing reason it has to be this way, drop anything about what it used to be, what changed, or why you changed it.",
    explain = "Describe this to a non-domain expert",
    tempfile = "Write your most recent response, properly formatted as markdown, to a new temporary file. Reply with only that file's path, no other text.",
    conversation = "Don't do any changes. We're just having a conversation.",
}

---@type { agent?: integer, back?: integer }
local tabs = {}

---@param tab? integer
---@return integer?
local function valid(tab)
    return tab and vim.api.nvim_tabpage_is_valid(tab) and tab or nil
end

--- Whether the tab page shows a sidekick agent.
---@param tab integer
---@return boolean
function M.is_agent_tab(tab)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        if vim.w[win].sidekick_session_id then
            return true
        end
    end
    return false
end

--- The tab page an agent returns to.
---@return integer?
function M.get_back_tab()
    return valid(tabs.back)
end

-- Every tab switch records the tab being left: an agent tab as the agent to
-- return to, any other tab as the place an agent returns to. Diffview tabs
-- are never a place to return to.
vim.api.nvim_create_autocmd('TabLeave', {
    group = vim.api.nvim_create_augroup('AgentTabTracking', { clear = true }),
    callback = function()
        local tab = vim.api.nvim_get_current_tabpage()
        if M.is_agent_tab(tab) then
            tabs.agent = tab
        elseif vim.t[tab].diffview_view_initialized == nil then
            tabs.back = tab
        end
    end,
})

--- Hook for sidekick's `cli.win.config`, which runs for each new terminal.
--- Sidekick opens every agent window through `open_win`, whether from the
--- picker, from sending text, or from its own commands. Wrapping it places
--- each agent in a tab page of its own.
---@param terminal sidekick.cli.Terminal
function M.open_in_tab(terminal)
    local open_win = terminal.open_win
    function terminal:open_win()
        if self:is_open() or not self.buf then
            return
        end
        vim.cmd.tabnew()
        local placeholder = vim.api.nvim_get_current_win()
        vim.bo.bufhidden = 'wipe'
        open_win(self)
        vim.api.nvim_win_close(placeholder, true)
    end
end

--- Jumps between an agent and the tab page it was reached from. With several
--- agents running, it returns to the one left last, and falls back to the
--- picker when none is reachable.
function M.toggle()
    local current = vim.api.nvim_get_current_tabpage()

    if M.is_agent_tab(current) then
        local tab = M.get_back_tab()
        if tab and tab ~= current then
            vim.api.nvim_set_current_tabpage(tab)
        else
            vim.cmd.tabprevious()
        end
        return
    end

    local agent = valid(tabs.agent)
    if agent and M.is_agent_tab(agent) then
        vim.api.nvim_set_current_tabpage(agent)
    else
        require('sidekick.cli').select { filter = { installed = true } }
    end
end

--- Picks one of `M.prompts` and sends it to the agent of the terminal.
---@param terminal sidekick.cli.Terminal
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
