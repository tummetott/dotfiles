local M = {}
local active_tokens = {}
local timer

local schedule_stop = Snacks.util.debounce(function()
    if next(active_tokens) or not timer then return end

    Snacks.util.stop(timer)
    timer = nil
    vim.cmd('redrawstatus')
end, { ms = 1500 })

vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ctx)
        local token = ctx.data.params.token
        local kind = ctx.data.params.value.kind

        if kind == 'begin' then
            active_tokens[token] = true
        elseif kind == 'end' then
            active_tokens[token] = nil
        end

        if not next(active_tokens) then
            schedule_stop()
        elseif not timer then
            timer = vim.uv.new_timer()
            timer:start(0, 150, vim.schedule_wrap(function()
                vim.cmd('redrawstatus')
            end))
        end
    end,
})

function M.spinner_active()
    return timer ~= nil
end

return M
