-- Composable keymaps for Snacks pickers.
-- Sources opt into named groups, which compose() merges over the
-- shared keymaps. Later groups take precedence.
local M = {}
local keymaps = {}
local prefix = '<C-,>'
local ignore = 'which_key_ignore'

-- The list window owns the `<c-,>` namespace while a picker is open, so every
-- global mapping under that prefix is shadowed per buffer.
local function clear_namespace(self)
    for _, map in ipairs(vim.api.nvim_get_keymap('n')) do
        if #map.lhs > #prefix and vim.startswith(map.lhs, prefix) then
            vim.keymap.set('n', map.lhs, function() end, {
                buffer = self.buf,
                desc = ignore,
            })
        end
    end
end

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
        -- A spec of only string keys merges into the Snacks default, keeping
        -- its action and mode and relabelling it for which-key. Two conditions
        -- apply, and missing either silently leaves a mapping without an
        -- action. The default has to be a table, since a bare string one like
        -- `<Esc>` is replaced rather than merged. And the key has to be spelled
        -- as Snacks spells it, which mixes `<c-` and `<C-`, because the merge
        -- runs on the literal strings
        ['<CR>'] = { desc = 'Open item' },
        ['<S-CR>'] = { desc = 'Open in picked window' },
        ['<Tab>'] = { desc = 'Select and move down' },
        ['<S-Tab>'] = { desc = 'Select and move up' },
        ['<Down>'] = { desc = 'Next item' },
        ['<Up>'] = { desc = 'Previous item' },
        ['<C-Down>'] = { desc = 'Next query' },
        ['<C-Up>'] = { desc = 'Previous query' },
        ['<c-n>'] = { desc = 'Next item' },
        ['<c-p>'] = { desc = 'Previous item' },
        ['<c-s>'] = { desc = 'Open in split' },
        ['<c-t>'] = { desc = 'Open in tab' },
        ['<c-v>'] = { desc = 'Open in vertical split' },
        ['<a-d>'] = false,
        ['<a-f>'] = false,
        ['<a-h>'] = false,
        ['<a-i>'] = false,
        ['<a-m>'] = false,
        ['<a-p>'] = false,
        ['<a-r>'] = false,
        ['<a-w>'] = false,
        ['<c-g>'] = false,
        ['<c-a>'] = false,
        ['<c-b>'] = false,
        ['<c-d>'] = false,
        ['<c-f>'] = false,
        ['<c-u>'] = false,
        ['<c-j>'] = false,
        ['<c-k>'] = false,
        ['<c-/>'] = { '<nop>', mode = { 'n', 'i' } },
    },
    list = {
        ['<c-q>'] = { 'close', desc = 'Close picker' },
        ['<c-,>p'] = { 'toggle_preview', desc = 'Preview window' },
        ['<c-,>m'] = { 'toggle_maximize', desc = 'Maximized layout' },
        ['<a-d>'] = false,
        ['<a-f>'] = false,
        ['<a-h>'] = false,
        ['<a-i>'] = false,
        ['<a-m>'] = false,
        ['<a-p>'] = false,
        ['<a-w>'] = false,
        ['<c-g>'] = false,
        ['<c-h>'] = '<nop>',
        ['<c-j>'] = '<nop>',
        ['<c-k>'] = '<nop>',
        ['<c-l>'] = '<nop>',
        ['<c-/>'] = '<nop>',
    },
    preview = {
        ['<c-q>'] = { 'toggle_preview', desc = 'Preview window' },
        ['<c-n>'] = { 'list_down', desc = 'Next item' },
        ['<c-p>'] = { 'list_up', desc = 'Previous item' },
        ['<a-w>'] = false,
        ['<c-h>'] = '<nop>',
        ['<c-j>'] = '<nop>',
        ['<c-k>'] = '<nop>',
        ['<c-l>'] = '<nop>',
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

    for _, config in pairs(win) do
        for key, spec in pairs(config.keys) do
            local nop = spec == '<nop>'
                or (type(spec) == 'table' and spec[1] == '<nop>')
            if nop then
                config.keys[key] = {
                    '<nop>',
                    desc = ignore,
                    mode = type(spec) == 'table' and spec.mode or nil,
                }
            end
        end
    end

    win.list.on_buf = clear_namespace
    return win
end

return M
