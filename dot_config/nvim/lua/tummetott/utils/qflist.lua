local M = {}

local function qf_api()
    local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    if not info or info.quickfix ~= 1 then
        return
    end

    if info.loclist == 1 then
        return {
            get = function(what) return vim.fn.getloclist(info.winid, what) end,
            set = function(what) vim.fn.setloclist(info.winid, {}, "r", what) end,
        }
    end

    return {
        get = function(what) return vim.fn.getqflist(what) end,
        set = function(what) vim.fn.setqflist({}, "r", what) end,
    }
end

function M.delete_qf_entries(first, last)
    local api = qf_api()
    if not api then
        return
    end

    local list = api.get({ id = 0, items = 0, title = 0, context = 0 })
    local items = list.items or {}
    first, last = math.min(first, last), math.max(first, last)

    for i = last, first, -1 do
        table.remove(items, i)
    end

    api.set({
        id = list.id,
        idx = #items == 0 and 0 or math.min(first, #items),
        items = items,
        title = list.title,
        context = list.context,
    })
end

return M
