local M = {}
local active_tokens = {}
local timer
local timer_running = false

local function start_timer()
    if timer_running then return end
    timer = vim.uv.new_timer()
    timer_running = true
    timer:start(0, 150, vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'LspSpinner' })
        vim.cmd('redrawstatus')
    end))
end

local function stop_timer()
    if not timer_running then return end
    timer_running = false
    timer:close()
end

vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ctx)
        local token = ctx.data.params.token
        local kind = ctx.data.params.value.kind
        if kind == 'begin' then
            active_tokens[token] = true
        elseif kind == 'end' then
            active_tokens[token] = nil
        end
        -- If we have at least one active token
        if next(active_tokens) ~= nil then
            start_timer()
        else
            -- Delay 1.5 second before stopping the timer in case new tokens appear
            vim.defer_fn(function()
                if next(active_tokens) == nil then
                    stop_timer()
                    vim.api.nvim_exec_autocmds('User', { pattern = 'LspSpinner' })
                    vim.cmd('redrawstatus')
                end
            end, 1500)
        end
    end,
})

M.spinner_active = function()
    return timer_running
end

return M
