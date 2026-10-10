-- Window keys for the snacks picker
local M = {}

local toggles = {
    i = { 'toggle_ignored', 'Gitignored files' },
    r = { 'toggle_regex', 'Regex search' },
    f = { 'toggle_follow', 'Follow symlinks' },
    c = { 'gh_toggle_state', 'Closed issues and PRs' },
    h = { 'toggle_hidden', 'Hidden files' },
    l = { 'toggle_live', 'Live search' },
    p = { 'toggle_preview', 'Preview window' },
    m = { 'toggle_maximize', 'Maximized layout' },
    o = { 'toggle_modified', 'Only modified buffers' },
}

-- Builds the prefixed toggle mappings for one picker window.
function M.toggles(mode)
    local keys = {}
    for key, toggle in pairs(toggles) do
        keys['<c-;>' .. key] = {
            toggle[1],
            desc = toggle[2],
            mode = mode,
        }
    end
    return keys
end

-- Input on top, list below it, preview to the right of the list
M.ivy = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-l>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
            ['<c-l>'] = 'focus_preview',
        },
    },
    preview = {
        keys = {
            ['<c-h>'] = 'focus_input',
        },
    },
}

-- Preview on top, input below it, list at the bottom
M.dropdown = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
            ['<c-k>'] = { 'focus_preview', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
        },
    },
    preview = {
        keys = {
            ['<c-j>'] = 'focus_input',
        },
    },
}

-- Input on top, list below it. Preview on the bottom
M.vertical = {
    input = {
        keys = {
            ['<c-j>'] = { 'focus_list', mode = 'i' },
        },
    },
    list = {
        keys = {
            ['<c-k>'] = 'focus_input',
            ['<c-j>'] = { 'focus_preview' },
        },
    },
    preview = {
        keys = {
            ['<c-k>'] = 'focus_list',
        },
    },
}

return M
