local M = {}

-- Provides a smart "go to file under cursor" helper. Attempts to resolve
-- line-broken file references (as commonly produced by LLM output) and jump to
-- the referenced file and line.

-- Find a regular editing window in the current tabpage.
-- This skips terminal/help/quickfix/prompt/nofile buffers.
local function find_edit_window()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
            return win
        end
    end
end

-- Parse a filepath starting at the WORD under the cursor.
-- Supports:
--   <path>
--   <path>:<line>
--   <path>:<line>-<range>
local function resolve_filepath_at_cursor(buf)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row 1-based, col 0-based

    -- 1. Get current line
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
    if not line then return nil end

    -- 2. Find WORD start in current line
    local before = line:sub(1, col + 1)
    local word_start = before:find("%S+$")
    if not word_start then
        return nil
    end

    -- 3. Cut everything before WORD start
    local text = line:sub(word_start)

    -- 4. Append subsequent lines to reconstruct a wrapped filepath.
    -- Wrapping is assumed to end at the first whitespace.
    local cur_row = row
    while not text:find("%s") do
        local next_line = vim.api.nvim_buf_get_lines(buf, cur_row, cur_row + 1, false)[1]
        if not next_line or next_line == "" then
            break
        end
        -- Strip leading whitespace from wrapped lines; continuation lines may
        -- be arbitrarily indented.
        text = text .. next_line:gsub("^%s+", "")
        cur_row = cur_row + 1
    end

    -- 5. Clamp again to a single WORD (cut everything after it)
    local word = text:match("^(%S+)")
    if not word then
        return nil
    end

    -- 6. Probe for a <path>:<line> suffix and return early if matched
    local path, lnum = word:match("^([%w%._%-/@~%+]+):(%d+)")
    if path then
        return path, tonumber(lnum)
    end

    -- 7. Extract a standalone filepath prefix (no line number). Allows '~'
    -- suffixes commonly used for backup files.
    path = word:match("^[%w%._%-/@~%+]+[%w~]")
    if path then
        return path
    end

    -- NOTE: This is a heuristic approach and has edge cases. It cannot
    -- always distinguish wrapped file paths from prose. Example:
    --   src/index.ts.
    --   Some text here ...
    -- In practice this is rare, as LLM output tends to introduce line
    -- breaks or whitespac frequently.

    return nil
end

--- Jump to a file reference under the cursor.
---
--- Attempts to resolve a (possibly line-wrapped) filepath at the cursor and
--- open it in a suitable window, optionally jumping to a line number.
--- Falls back to the default <C-]> behavior if no file reference can be resolved.
---
---@param buf integer Buffer handle used to read text under the cursor
---@return nil
function M.goto_file_at_cursor(buf)
    local path, lnum = resolve_filepath_at_cursor(buf)

    -- 1. If no readable path, fall back to default behavior
    if not path or vim.fn.filereadable(path) ~= 1 then
        return vim.cmd("normal! <C-]>")
    end

    -- 2. Try to reuse an existing regular window
    local target_win = find_edit_window()

    -- 3. If none exists, open a new window (left of the LLM buffer)
    if not target_win then
        vim.cmd("leftabove vsplit")
        target_win = vim.api.nvim_get_current_win()
    else
        vim.api.nvim_set_current_win(target_win)
    end

    vim.cmd("edit " .. vim.fn.fnameescape(path))

    if lnum then
        vim.api.nvim_win_set_cursor(target_win, { lnum, 0 })
        vim.cmd("normal! zz")
    end
end

return M
