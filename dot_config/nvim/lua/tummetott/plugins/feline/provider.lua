local M = {}

local has_diffview = function()
    return require 'tummetott.utils'.is_loaded('diffview.nvim') and
        require 'diffview.lib'.get_current_view()
end

local diffview_winbar_text = function()
    local view = require('diffview.lib').get_current_view()
    local bufnr = vim.api.nvim_get_current_buf()
    local rev_label = ''
    local path = ''
    for _, file in ipairs(view.cur_entry and view.cur_entry.layout:files() or {}) do
        if file:is_valid() and file.bufnr == bufnr then
            path = string.format('%s/%s', view.adapter.ctx.toplevel, file.path)
            local rev = file.rev
            if rev.type == 1 then
                rev_label = 'LOCAL'
            elseif rev.type == 2 then
                local head = vim.trim(vim.fn.system(
                    { 'git', 'rev-parse', '--revs-only', 'HEAD' }))
                if head == rev.commit then
                    rev_label = 'HEAD'
                else
                    rev_label = string.format('%s', rev.commit:sub(1, 7))
                end
            elseif rev.type == 3 then
                rev_label = ({
                    [0] = 'INDEX',
                    [1] = 'MERGE COMMON ANCESTOR',
                    [2] = 'MERGE OURS',
                    [3] = 'MERGE THEIRS',
                })[rev.stage] or ''
            end
        end
    end
    local icon = vim.g.nerdfonts and '󱞳' or '@'
    return string.format('%s %s %s', path, icon, rev_label)
end

M.buff_name = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local ft = vim.bo.filetype

    if bufname == '' then
        return '[No File]'
    elseif bufname == 'diffview://null' then
        return '[Empty Diffview]'
    end

    if ft == 'oil' then
        local path = string.match(bufname, '^oil://(.*)')
        path = vim.fn.fnamemodify(path, ':~')
        local icon = vim.g.nerdfonts
            and { str = ' ', hl = { fg = '#e68805' } } or nil
        return path, icon
    end

    if has_diffview() then
        bufname = diffview_winbar_text()
    end

    -- Trim the full file path relative to our cwd
    local path = vim.fn.fnamemodify(bufname, ':~:.')

    if not vim.g.nerdfonts then
        return path
    end

    -- Get icon and icon color
    local icon_str, icon_color = require('nvim-web-devicons').get_icon_color(
        vim.fn.expand('%:t'), nil, { default = true })
    local icon = { str = icon_str .. ' ', hl = { fg = icon_color } }

    return path, icon
end

M.help_file = function()
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    local icon = vim.g.nerdfonts and '󰈙 ' or nil
    return bufname, icon
end

M.buff_modified = function()
    local modified_icon = ''
    if vim.bo.modified then
        modified_icon = vim.g.nerdfonts and '●' or '*'
    elseif vim.bo.readonly or not vim.bo.modifiable then
        modified_icon = vim.g.nerdfonts and '' or '#'
    end
    return modified_icon
end

M.trailing = false
M.trailing_whitespace = function()
    M.trailing = vim.fn.search('\\s$', 'nwc') ~= 0
    local icon = vim.g.nerdfonts and '󱁐 ' or nil
    return M.trailing and 'TW' or '', icon
end

M.mixed = false
M.indent = function()
    M.mixed = false
    local spaces = vim.fn.search('^\t* \t*', 'nwc') ~= 0
    local tabs = vim.fn.search('^ *\t *', 'nwc') ~= 0
    local indent = ''
    if (spaces and tabs) then
        indent = 'Mix'
        M.mixed = true
    elseif spaces then
        indent = 'Spaces'
    elseif tabs then
        indent = 'Tab'
    end
    local icon = vim.g.nerdfonts and '󰉶 ' or 'INDENT: '
    return indent, icon
end

M.filetype = function()
    local ft = vim.bo.filetype
    local icon
    if vim.g.nerdfonts then
        local opts = { default = true }
        icon, _ = require('nvim-web-devicons').get_icon(nil, ft, opts)
        icon = icon .. ' '
    else
        icon = 'FT: '
    end
    return ft, icon
end

M.bufname_by_filetype = function()
    local ft = vim.bo.filetype
    ft = ft == 'TelescopePrompt' and 'Telescope' or ft
    return ft:upper()
end

M.conda_environment = function()
    local env = os.getenv('CONDA_DEFAULT_ENV')
    local icon = vim.g.nerdfonts and '󰆧 ' or 'CONDA: '
    return env or '', icon
end

M.columns = function()
    local col = vim.fn.col('.')
    local cols = vim.fn.col('$')
    local icon = vim.g.nerdfonts and ' ' or 'CN: '
    return string.format('%2d/%2d', col, cols), icon
end

M.lines = function()
    local line = vim.fn.line('.')
    local lines = vim.fn.line('$')
    local icon = vim.g.nerdfonts and ' ' or 'LN: '
    return string.format('%3d/%3d', line, lines), icon
end

M.searchcount = function()
    local search = vim.fn.searchcount { maxcount = 999, timeout = 250 }
    if vim.tbl_isempty(search) or search.incomplete == 1 then
        return ''
    end
    local total = search.total
    local flag = ''
    if search.incomplete == 2 then
        total = search.maxcount
        flag = '+'
    end
    local count = string.format('%d/%d%s', search.current, total, flag)
    local icon = vim.g.nerdfonts and ' ' or 'SEARCH: '
    return count, icon
end

M.lsp_attached = function()
    local servers = {}
    for _, lsp in pairs(vim.lsp.get_clients()) do
        table.insert(servers, lsp.name)
    end
    if vim.tbl_isempty(servers) then
        return ''
    end
    local str = ''
    for i, v in ipairs(servers) do
        str = str .. v
        if i < #servers then
            str = str .. ', '
        end
    end
    local icon = vim.g.nerdfonts and ' ' or 'LSP: '
    return str, icon
end

M.git_conflict = function()
    local conflicts = vim.fn.search('^[<>|]\\{7} \\|=\\{7}$', 'nwc')
    local str = conflicts > 0 and 'CONFLICT' or ''
    local icon = vim.g.nerdfonts and  ' ' or 'GIT '
    return str, icon
end

return M
