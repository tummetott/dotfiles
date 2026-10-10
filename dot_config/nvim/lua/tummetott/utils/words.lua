-- LSP reference highlights stay out of sight until they are asked for.
-- `snacks.words` offers no option for revealing them on demand, so the three
-- LSP reference groups link to a cleared group and are linked back to a visible
-- one on request. The extmarks `snacks.words` maintains are untouched by this,
-- so navigation always has the full set of references to walk.
local M = {}

local groups = {
    'LspReferenceText',
    'LspReferenceRead',
    'LspReferenceWrite',
}

-- Cursor position the current reveal started at, and nil while hidden
local anchor

local function link(target)
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { link = target })
    end
end

function M.hide()
    if not anchor then
        return
    end
    anchor = nil
    link 'LspReferenceHidden'
end

-- Reveals the references of the word under the cursor.
function M.show()
    anchor = vim.api.nvim_win_get_cursor(0)
    link 'LspReferenceVisible'
end

-- Moves `count` references forward, negative counts backwards, and reveals the
-- whole set of references at the destination.
function M.jump(count)
    Snacks.words.jump(count, true)
    M.show()
end

local augroup = vim.api.nvim_create_augroup('ReferenceHighlight', { clear = true })

vim.api.nvim_create_autocmd('CursorMoved', {
    group = augroup,
    callback = function()
        if not anchor then
            return
        end
        local cursor = vim.api.nvim_win_get_cursor(0)
        if cursor[1] ~= anchor[1] or cursor[2] ~= anchor[2] then
            M.hide()
        end
    end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
    group = augroup,
    callback = M.hide,
})

return M
