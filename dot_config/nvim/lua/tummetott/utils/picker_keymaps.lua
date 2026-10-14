-- Composable keymaps for Snacks pickers.
-- Sources opt into named groups, which compose() merges over the
-- shared keymaps. Later groups take precedence.
local M = {}
local keymaps = {}

-- Helper to define one set of keys for both the input and the list window
local function input_and_list(keys)
    local input = vim.deepcopy(keys)
    for _, spec in pairs(input) do
        spec.mode = 'i'
    end
    return { input = input, list = keys }
end

-- Snacks defines default keymaps for picker windows.
-- `false` disables a default Snacks mapping, allowing an underlying mapping
-- to take effect. `<nop>` explicitly consumes the key instead.
keymaps.shared = {
    input = {
        ['<Esc>'] = { 'close', desc = 'Close picker', mode = { 'n', 'i' } },
        ['<c-q>'] = { 'close', desc = 'Close picker', mode = { 'n', 'i' } },
        ['<c-,>p'] = { 'toggle_preview', desc = 'Preview window', mode = 'i' },
        ['<c-,>m'] = { 'toggle_maximize', desc = 'Maximized layout', mode = 'i' },
        ['<c-g>'] = false,
        ['<c-a>'] = false,
        ['<c-b>'] = false,
        ['<c-d>'] = false,
        ['<c-f>'] = false,
        ['<c-u>'] = false,
        ['<c-j>'] = false,
        ['<c-k>'] = false,
        ['<c-/>'] = { '<nop>', mode = 'i' },
    },
    list = {
        ['<c-q>'] = { 'close', desc = 'Close picker' },
        ['<c-,>p'] = { 'toggle_preview', desc = 'Preview window' },
        ['<c-,>m'] = { 'toggle_maximize', desc = 'Maximized layout' },
        ['<c-g>'] = false,
        -- Consume global keymaps that would act on the list buffer. Presets and
        -- toggle groups rebind some of these keys.
        ['<c-h>'] = { '<nop>' },
        ['<c-j>'] = { '<nop>' },
        ['<c-k>'] = { '<nop>' },
        ['<c-l>'] = { '<nop>' },
        ['<c-/>'] = { '<nop>' },
        ['<c-,>b'] = { '<nop>' },
        ['<c-,>d'] = { '<nop>' },
        ['<c-,>e'] = { '<nop>' },
        ['<c-,>g'] = { '<nop>' },
        ['<c-,>h'] = { '<nop>' },
        ['<c-,>l'] = { '<nop>' },
        ['<c-,>n'] = { '<nop>' },
        ['<c-,>r'] = { '<nop>' },
        ['<c-,>c'] = { '<nop>' },
        ['<c-,>s'] = { '<nop>' },
        ['<c-,>t'] = { '<nop>' },
        ['<c-,>v'] = { '<nop>' },
        ['<c-,>w'] = { '<nop>' },
    },
    preview = {
        ['<c-q>'] = { 'toggle_preview', desc = 'Preview window' },
        ['<c-n>'] = { 'list_down', desc = 'Next item' },
        ['<c-p>'] = { 'list_up', desc = 'Previous item' },
        ['<c-h>'] = { '<nop>' },
        ['<c-j>'] = { '<nop>' },
        ['<c-k>'] = { '<nop>' },
        ['<c-l>'] = { '<nop>' },
    },
}

-- Preset ivy: Input on top, list below it, preview to the right of the list
keymaps.ivy = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus list', mode = 'i' },
        ['<c-l>'] = { 'focus_preview', desc = 'Focus preview', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus input' },
        ['<c-l>'] = { 'focus_preview', desc = 'Focus preview' },
    },
    preview = {
        ['<c-h>'] = { 'focus_input', desc = 'Focus input' },
    },
}

-- Preset dropdown: Preview on top, input below it, list at the bottom
keymaps.dropdown = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus list', mode = 'i' },
        ['<c-k>'] = { 'focus_preview', desc = 'Focus preview', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus input' },
    },
    preview = {
        ['<c-j>'] = { 'focus_input', desc = 'Focus input' },
    },
}

-- Preset vertical: Input on top, list below it, preview at the bottom
keymaps.vertical = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus list', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus input' },
        ['<c-j>'] = { 'focus_preview', desc = 'Focus preview' },
    },
    preview = {
        ['<c-k>'] = { 'focus_list', desc = 'Focus list' },
    },
}

keymaps.trouble = input_and_list {
    ['<c-o>'] = { 'trouble_open', desc = 'Open in trouble' },
    ['<c-y>'] = { 'trouble_add', desc = 'Add to trouble' },
}

-- Toggle keymaps
keymaps.hidden = input_and_list {
    ['<c-,>h'] = { 'toggle_hidden', desc = 'Hidden files' },
}
keymaps.ignored = input_and_list {
    ['<c-,>i'] = { 'toggle_ignored', desc = 'Gitignored files' },
}
keymaps.follow = input_and_list {
    ['<c-,>f'] = { 'toggle_follow', desc = 'Follow symlinks' },
}
keymaps.regex = input_and_list {
    ['<c-,>r'] = { 'toggle_regex', desc = 'Regex search' },
}
keymaps.modified = input_and_list {
    ['<c-,>o'] = { 'toggle_modified', desc = 'Only modified buffers' },
}
keymaps.state = input_and_list {
    ['<c-,>c'] = { 'gh_toggle_state', desc = 'Closed issues and PRs' },
}
keymaps.live = input_and_list {
    ['<c-,>l'] = { 'toggle_live', desc = 'Live search' },
}

function M.compose(names)
    names = names or {}

    local preset
    for _, name in ipairs(names) do
        if not keymaps[name] then
            error('unknown picker keymaps: ' .. name)
        end
        if vim.tbl_contains({ 'ivy', 'dropdown', 'vertical' }, name) then
            if preset then
                error(('picker names two presets: %s and %s')
                    :format(preset, name))
            end
            preset = name
        end
    end

    local win = {}
    for _, name in ipairs(vim.list_extend({ 'shared' }, names)) do
        for window, keys in pairs(keymaps[name]) do
            win[window] = win[window] or { keys = {} }
            win[window].keys = vim.tbl_extend('force', win[window].keys, keys)
        end
    end

    -- Global which-key specs, such as the ones snacks toggles register,
    -- take precedence over the description of a buffer-local keymap.
    -- Specs for the list buffer, registered after them, restore the
    -- picker's own labels and hide the consumed keys.
    local list_keys = win.list.keys
    win.list.on_buf = function(self)
        local specs = {}
        for lhs, spec in pairs(list_keys) do
            if spec then
                specs[#specs + 1] = {
                    lhs,
                    buffer = self.buf,
                    mode = spec.mode or 'n',
                    desc = spec.desc,
                    hidden = spec[1] == '<nop>' or nil,
                }
            end
        end
        require('which-key').add(specs)
    end
    return win
end

return M
