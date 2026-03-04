local M = {}

-- Returns which dimension of the current window should be resized. The result
-- is either "vertical" or "horizontal", depending on how the window is arranged
-- in the current layout.
local function resize_dimension()
    local win = vim.api.nvim_get_current_win()
    local layout = vim.fn.winlayout()

    local function walk(node, parent)
        local kind = node[1]

        if kind == "leaf" then
            if node[2] == win then
                if parent == "row" then
                    return "vertical"
                elseif parent == "col" then
                    return "horizontal"
                end
            end
            return nil
        end

        for _, child in ipairs(node[2]) do
            local r = walk(child, kind)
            if r then
                return r
            end
        end
    end

    return walk(layout)
end

local function delta()
    local ui = vim.api.nvim_list_uis()[1]
    return {
        -- Expand / contract window by 20%
        width = math.floor(ui.width * 0.2),
        height = math.floor(ui.height * 0.2),
    }
end

function M.expand()
    local dim = resize_dimension()
    local d = delta()

    if dim == "vertical" then
        vim.cmd("vertical resize +" .. d.width)
    elseif dim == "horizontal" then
        vim.cmd("resize +" .. d.height)
    end
end

function M.contract()
    local dim = resize_dimension()
    local d = delta()

    if dim == "vertical" then
        vim.cmd("vertical resize -" .. d.width)
    elseif dim == "horizontal" then
        vim.cmd("resize -" .. d.height)
    end
end

return M
