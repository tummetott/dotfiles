local M = {}

local has_scrollbar = function()
    return require 'tummetott.utils'.is_loaded('nvim-scrollbar') and
        require 'scrollbar.config'.get().show
end

M.get_foldtext = function()
    local fs = vim.v.foldstart
    local fe = vim.v.foldend
    local win_id = vim.api.nvim_get_current_win()
    local win_width = vim.api.nvim_win_get_width(win_id)
    local gutter_with = vim.fn.getwininfo(win_id)[1].textoff
    local scrollbar_width = has_scrollbar() and 1 or 0
    local ending = string.format('%d LINES', fe - fs + 1)
    local ending_width = vim.fn.strwidth(ending)
    local text = vim.api.nvim_buf_get_lines(0, fs - 1, fs, false)[1]
    -- Close opening curly braces
    if string.find(text, '{$') then
        text = string.gsub(text, '$', '...}')
    end
    local text_width = vim.fn.strdisplaywidth(text)
    local fillers_width = win_width - gutter_with - scrollbar_width - ending_width - text_width - 3
    local fillers = string.rep('⋅', fillers_width)
    return string.format('%s %s %s ', text, fillers, ending)
end

return M
