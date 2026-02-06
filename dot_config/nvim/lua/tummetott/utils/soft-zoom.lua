local M = {}

local restore_cmd = nil

function M.toggle()
    if restore_cmd then
        vim.cmd(restore_cmd)
        restore_cmd = nil
        return
    end

    restore_cmd = vim.fn.winrestcmd()

    local win = vim.api.nvim_get_current_win()
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    if width > height then
        -- horizontal split (help, man)
        vim.cmd("resize +8")
    else
        -- vertical split (nvimtree, trouble)
        vim.cmd("vertical resize +20")
    end
end

return M
