-- Resizes windows by a fixed share of the editor size, along whichever axis
-- the window shares with its siblings in the layout.
local M = {}

-- Share of the editor size one step grows or shrinks a window by
local step = 0.1

-- Windows in a row of the layout trade width, windows in a column height.
-- `size` names the dimension of the editor a step is taken from.
local axes = {
    row = {
        size = 'width',
        get = vim.api.nvim_win_get_width,
        set = vim.api.nvim_win_set_width,
    },
    col = {
        size = 'height',
        get = vim.api.nvim_win_get_height,
        set = vim.api.nvim_win_set_height,
    },
}

--- Window a resize applies to. A float anchored to a window, such as the
--- input or list of a snacks sidebar layout, resizes together with its anchor.
local function target()
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)
    return config.relative == 'win' and config.win or win
end

--- Axis along which `win` resizes, or nil for a window without siblings
---@param win integer
local function axis(win)
    -- Walks the tree of `vim.fn.winlayout()`, tracking the parent node kind
    local function find(node, parent)
        if node[1] == 'leaf' then
            return node[2] == win and axes[parent] or nil
        end
        for _, child in ipairs(node[2]) do
            local ret = find(child, node[1])
            if ret then
                return ret
            end
        end
    end
    return find(vim.fn.winlayout())
end

--- Grows the current window by `count` steps, shrinking it for negative counts
---@param count integer
function M.resize(count)
    local win = target()
    local ax = axis(win)
    if not ax then
        return
    end
    local ui = vim.api.nvim_list_uis()[1]
    ax.set(win, ax.get(win) + math.floor(ui[ax.size] * step) * count)
end

--- Grows the current window by the count of the keymap that triggers it
function M.expand()
    M.resize(vim.v.count1)
end

--- Shrinks the current window by the count of the keymap that triggers it
function M.contract()
    M.resize(-vim.v.count1)
end

return M
