-- Removes trailing whitespace from the given range, or the whole buffer when
-- no range is given. `keeppatterns` protects the last search pattern.
vim.api.nvim_create_user_command('TrimTrailingWhitespaces', function(ctx)
    local view = vim.fn.winsaveview()
    vim.cmd(string.format([[keeppatterns %d,%ds/\s\+$//e]], ctx.line1, ctx.line2))
    vim.fn.winrestview(view)
end, {
    range = '%',
    desc = 'Trim trailing whitespaces',
})

-- Converts the indentation of the range, or the whole buffer, to tabs or to a
-- width in spaces. The source width defaults to the effective 'shiftwidth',
-- which is wrong whenever the buffer's options disagree with the file, so a
-- second argument overrides it: `Reindent 2 4` rewrites 4 space indents to 2.
vim.api.nvim_create_user_command('Reindent', function(ctx)
    local function width_of(arg)
        local value = tonumber(arg)
        if value and value % 1 == 0 and value >= 1 and value <= 10 then
            return value
        end
    end

    local target = ctx.fargs[1]
    local width = width_of(target)
    if target ~= 'tab' and not width then
        vim.notify("Reindent: expected 'tab' or a width, got " .. target, vim.log.levels.ERROR)
        return
    end

    local from = vim.fn.shiftwidth()
    if ctx.fargs[2] then
        from = width_of(ctx.fargs[2])
        if not from then
            vim.notify('Reindent: expected a width, got ' .. ctx.fargs[2], vim.log.levels.ERROR)
            return
        end
    end

    local range = string.format('%d,%d', ctx.line1, ctx.line2)
    local view = vim.fn.winsaveview()

    vim.bo.tabstop = from
    vim.bo.expandtab = false
    vim.cmd(range .. 'retab! -indentonly')

    if width then
        vim.bo.tabstop = width
        vim.bo.expandtab = true
        vim.cmd(range .. 'retab -indentonly')
    end

    vim.fn.winrestview(view)
end, {
    nargs = '+',
    range = '%',
    complete = function(lead)
        return vim.tbl_filter(function(value)
            return value:find(lead, 1, true) == 1
        end, { 'tab', '2', '4', '8' })
    end,
    desc = 'Convert indentation to tabs or a space width',
})

-- Maps every common key to echo its own name, to find out which chord a
-- terminal actually delivers. The mappings live until the session ends.
vim.api.nvim_create_user_command('DebugKeymaps', function()
    local function map(lhs, desc)
        pcall(vim.keymap.set, 'n', lhs, function()
            vim.print(string.format('Pressed: %s', lhs))
        end, { desc = desc })
    end

    local keys = {
        -- letters and numbers
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        -- punctuation & symbols
        ';', ',', '.', '/', '-', '=', '[', ']', '`', "'", '~', '_', '+',
        -- navigation & control
        'Tab', 'CR', 'Enter', 'Esc', 'Bslash', 'Space',
        'Up', 'Down', 'Left', 'Right', 'Home', 'End', 'PageUp', 'PageDown',
    }

    for _, key in ipairs(keys) do
        map('<' .. key .. '>', key)
        map('<C-' .. key .. '>', 'Ctrl+' .. key)
        map('<A-' .. key .. '>', 'Alt+' .. key)
        map('<C-S-' .. key .. '>', 'Ctrl+Shift+' .. key)
    end
    for _, key in ipairs({ 'Tab', 'Left', 'Right', 'Up', 'Down', 'Home', 'End', 'PageUp', 'PageDown' }) do
        map('<S-' .. key .. '>', 'Shift+' .. key)
    end

    vim.notify('DebugKeymaps active — press any key to test.')
end, { desc = 'Register debug mappings for all common keys' })

-- Opens the snacks picker for the given source. Without a source it opens the
-- list of all pickers.
vim.api.nvim_create_user_command('Picker', function(ctx)
    Snacks.picker(ctx.args ~= '' and ctx.args or nil)
end, {
    nargs = '?',
    complete = function(lead)
        local sources = vim.tbl_keys(Snacks.picker.config.get().sources)
        table.sort(sources)
        return vim.tbl_filter(function(name)
            return name:find(lead, 1, true) == 1
        end, sources)
    end,
    desc = 'Open a snacks picker',
})

-- An empty spec lets lazy.nvim profile this configuration module.
return {}
