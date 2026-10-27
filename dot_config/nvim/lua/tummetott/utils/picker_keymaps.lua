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
        ['<Esc>'] = { 'close', desc = 'Close Picker', mode = { 'n', 'i' } },
        ['<c-q>'] = { 'close', desc = 'Close Picker', mode = { 'n', 'i' } },
        ['<c-,>p'] = { 'toggle_preview', desc = 'Preview Window', mode = 'i' },
        ['<c-,>m'] = { 'toggle_maximize', desc = 'Maximized Layout', mode = 'i' },
        ['<c-g>'] = false,
        ['<c-a>'] = false,
        ['<c-b>'] = false,
        ['<c-d>'] = false,
        ['<c-f>'] = false,
        ['<c-u>'] = false,
        ['<c-j>'] = false,
        ['<c-k>'] = false,
        ['<c-l>'] = false,
        ['<c-/>'] = { '<nop>', mode = 'i' },
        ['<a-d>'] = false,
        ['<a-f>'] = false,
        ['<a-h>'] = false,
        ['<a-i>'] = false,
        ['<a-r>'] = false,
        ['<a-m>'] = false,
        ['<a-p>'] = false,
        ['<a-w>'] = false,
    },
    list = {
        ['<c-q>'] = { 'close', desc = 'Close Picker' },
        ['<c-,>p'] = { 'toggle_preview', desc = 'Preview Window' },
        ['<c-,>m'] = { 'toggle_maximize', desc = 'Maximized Layout' },
        -- Only show local keymaps in the which-key window
        ['g?'] = {
            function() require('which-key').show({ global = false, expand = false }) end,
            desc = 'Show Keymaps',
        },
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
        ['<c-,>f'] = { '<nop>' },
        ['<c-,>s'] = { '<nop>' },
        ['<c-,>t'] = { '<nop>' },
        ['<c-,>v'] = { '<nop>' },
        ['<c-,>w'] = { '<nop>' },
        -- Alt defaults, the <c-,> toggles cover them
        ['<a-d>'] = false,
        ['<a-f>'] = false,
        ['<a-h>'] = false,
        ['<a-i>'] = false,
        ['<a-m>'] = false,
        ['<a-p>'] = false,
        ['<a-w>'] = false,
    },
    preview = {
        ['<c-q>'] = { 'toggle_preview', desc = 'Preview Window' },
        ['<c-n>'] = { 'list_down', desc = 'Next Item' },
        ['<c-p>'] = { 'list_up', desc = 'Previous Item' },
        ['<c-h>'] = { '<nop>' },
        ['<c-j>'] = { '<nop>' },
        ['<c-k>'] = { '<nop>' },
        ['<c-l>'] = { '<nop>' },
        ['<a-w>'] = false,
    },
}

-- Preset ivy: Input on top, list below it, preview to the right of the list
keymaps.ivy = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus List', mode = 'i' },
        ['<c-l>'] = { 'focus_preview', desc = 'Focus Preview', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus Input' },
        ['<c-l>'] = { 'focus_preview', desc = 'Focus Preview' },
    },
    preview = {
        ['<c-h>'] = { 'focus_input', desc = 'Focus Input' },
    },
}

-- Preset default: It arranges the windows like ivy, so it shares the same keys.
keymaps.default = keymaps.ivy

-- Preset dropdown: Preview on top, input below it, list at the bottom
keymaps.dropdown = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus List', mode = 'i' },
        ['<c-k>'] = { 'focus_preview', desc = 'Focus Preview', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus Input' },
    },
    preview = {
        ['<c-j>'] = { 'focus_input', desc = 'Focus Input' },
    },
}

-- Preset vertical: Input on top, list below it, preview at the bottom
keymaps.vertical = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus List', mode = 'i' },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus Input' },
        ['<c-j>'] = { 'focus_preview', desc = 'Focus Preview' },
    },
    preview = {
        ['<c-k>'] = { 'focus_list', desc = 'Focus List' },
    },
}

-- Preset sidebar: Input on top, list below it. Only used for the explorer
keymaps.sidebar = {
    input = {
        ['<c-j>'] = { 'focus_list', desc = 'Focus List', mode = 'i' },
        ['<c-l>'] = {
            function()
                vim.cmd.stopinsert()
                vim.cmd.wincmd('l')
            end,
            desc = 'Jump to Right Window',
            mode = 'i',
        },
        ['<c-s>'] = { 'close', desc = 'Close File Tree', mode = 'i' },
        ['<c-=>'] = {
            function() require('tummetott.utils.winsize').expand() end,
            desc = 'Expand Window',
            mode = 'i',
        },
        ['<c-->'] = {
            function() require('tummetott.utils.winsize').contract() end,
            desc = 'Contract Window',
            mode = 'i',
        },
    },
    list = {
        ['<c-k>'] = { 'focus_input', desc = 'Focus Input' },
        ['<c-s>'] = { 'close', desc = 'Close File Tree' },
        ['<c-h>'] = { '<nop>' },
        ['<c-j>'] = { '<nop>' },
        ['<c-l>'] = false,
        -- Explorer defaults, the <c-,> toggles cover them
        ['H'] = false,
        ['I'] = false,
        ['P'] = false,
    },
}

keymaps.trouble = input_and_list {
    ['<c-o>'] = { 'trouble_open', desc = 'Open in Trouble' },
    ['<c-y>'] = { 'trouble_add', desc = 'Add to Trouble' },
}

-- Toggle keymaps
keymaps.hidden = input_and_list {
    ['<c-,>h'] = { 'toggle_hidden', desc = 'Hidden Files' },
}
keymaps.ignored = input_and_list {
    ['<c-,>i'] = { 'toggle_ignored', desc = 'Gitignored Files' },
}
keymaps.symlinks = input_and_list {
    ['<c-,>s'] = { 'toggle_follow', desc = 'Symlinks' },
}
keymaps.regex = input_and_list {
    ['<c-,>r'] = { 'toggle_regex', desc = 'Regex Search' },
}
keymaps.modified = input_and_list {
    ['<c-,>o'] = { 'toggle_modified', desc = 'Only Modified Buffers' },
}
keymaps.state = input_and_list {
    ['<c-,>c'] = { 'gh_toggle_state', desc = 'Closed Issues and PRs' },
}
keymaps.live = input_and_list {
    ['<c-,>l'] = { 'toggle_live', desc = 'Live Search' },
}

function M.compose(names)
    names = names or {}

    local preset
    for _, name in ipairs(names) do
        if not keymaps[name] then
            error('unknown picker keymaps: ' .. name)
        end
        if vim.tbl_contains({
            'ivy',
            'default',
            'dropdown',
            'vertical',
            'sidebar',
        }, name) then
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
