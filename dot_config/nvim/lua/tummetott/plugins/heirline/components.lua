local M = {}
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local spinner = require('tummetott.plugins.heirline.spinner')

M.align = { provider = '%=' }

M.left_moon = {
    { provider = '', hl = { fg = 'bg', bg = 'base' } },
    { provider = ' ' }
}

M.right_moon = {
    { provider = ' ' },
    { provider = '', hl = { fg = 'bg', bg = 'base' } }
}

M.mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        mode_names = {
            ['n']     = 'NORMAL',
            ['no']    = 'O-PENDING',
            ['nov']   = 'O-PENDING',
            ['noV']   = 'O-PENDING',
            ['no\22'] = 'O-PENDING',
            ['niI']   = 'NORMAL',
            ['niR']   = 'NORMAL',
            ['niV']   = 'NORMAL',
            ['nt']    = 'NORMAL',
            ['ntT']   = 'NORMAL',
            ['v']     = 'VISUAL',
            ['vs']    = 'VISUAL',
            ['V']     = 'V-LINE',
            ['Vs']    = 'V-LINE',
            ['\22']   = 'V-BLOCK',
            ['\22s']  = 'V-BLOCK',
            ['s']     = 'SELECT',
            ['S']     = 'S-LINE',
            ['\19']   = 'S-BLOCK',
            ['i']     = 'INSERT',
            ['ic']    = 'INSERT',
            ['ix']    = 'INSERT',
            ['R']     = 'REPLACE',
            ['Rc']    = 'REPLACE',
            ['Rx']    = 'REPLACE',
            ['Rv']    = 'V-REPLACE',
            ['Rvc']   = 'V-REPLACE',
            ['Rvx']   = 'V-REPLACE',
            ['c']     = 'COMMAND',
            ['cv']    = 'EX',
            ['ce']    = 'EX',
            ['r']     = 'REPLACE',
            ['rm']    = 'MORE',
            ['r?']    = 'CONFIRM',
            ['!']     = 'SHELL',
            ['t']     = 'TERMINAL',
        },
        mode_colors = {
            n = 'blue',
            i = 'teal',
            v = 'orange',
            V = 'orange',
            ['\22'] = 'orange',
            c = 'purple',
            s = 'orange',
            S = 'orange',
            ['\19'] = 'orange',
            R = 'red',
            r = 'red',
            ['!'] = 'peach',
            t = 'purple',
        }
    },
    provider = function(self)
        return self.mode_names[self.mode]
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, }
    end,
    update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
            vim.cmd('redrawstatus')
        end),
    },
}

M.git = {
    condition = conditions.is_git_repo,
    static = {
        added_icon = '+',
        removed_icon = '-',
        changed_icon = '~',
        branch_icon = vim.g.nerdfonts and ' ' or 'GIT: ',
    },
    init = function(self)
        self.git = vim.b.gitsigns_status_dict
        self.git.added = self.git.added or 0
        self.git.removed = self.git.removed or 0
        self.git.changed = self.git.changed or 0
        self.has_changes = self.git.added ~= 0
            or self.git.removed ~= 0
            or self.git.changed ~= 0
    end,
    { -- Branch name
        provider = function(self)
            return '  ' .. self.branch_icon .. self.git.head
        end,
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ' ('
    },
    { -- Added
        provider = function(self)
            return self.git.added > 0 and ('+' .. self.git.added)
        end,
    },
    { -- Removed
        provider = function(self)
            return self.git.removed > 0 and ('-' .. self.git.removed)
        end,
    },
    { -- Changed
        provider = function(self)
            return self.git.changed > 0 and ('~' .. self.git.changed)
        end,
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ')',
    },
    update = {
        'User',
        pattern = 'GitSignsUpdate',
    }
}

M.diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
        error_icon = vim.g.nerdfonts and ' ' or 'E',
        warn_icon = vim.g.nerdfonts and ' ' or 'W',
        hint_icon = vim.g.nerdfonts and ' ' or 'H',
        info_icon = vim.g.nerdfonts and ' ' or 'I',
    },
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
        provider = function(self)
            return self.errors > 0 and ('  ' .. self.error_icon .. self.errors)
        end,
        hl = { fg = 'red' },
    },
    {
        provider = function(self)
            return self.warnings > 0 and ('  ' .. self.warn_icon .. self.warnings)
        end,
        hl = { fg = 'orange' },
    },
    {
        provider = function(self)
            return self.info > 0 and ('  ' .. self.info_icon .. self.info)
        end,
        hl = { fg = 'blue' },
    },
    {
        provider = function(self)
            return self.hints > 0 and ('  ' .. self.hint_icon .. self.hints)
        end,
        hl = { fg = 'yellow' },
    },
}

M.git_conflict = {
    condition = function()
        return vim.bo.filetype ~= 'bigfile'
    end,
    init = function(self)
        self.conflicts = vim.fn.search('^[<>|]\\{7} \\|=\\{7}$', 'nwc')
    end,
    provider = function(self)
        return self.conflicts > 0 and 'MERGE CONFLICT'
    end,
    update = { 'BufReadPost', 'BufWritePost', 'CursorHold' },
    hl = { fg = 'red' }
}

M.trailing_whitespace = {
    condition = function()
        return vim.bo.filetype ~= 'bigfile'
    end,
    init = function(self)
        self.has_trailing = vim.fn.search('\\s$', 'nwc') ~= 0
    end,
    provider = function(self)
        return self.has_trailing and '  TRAILING WHITESPACE'
    end,
    update = { 'BufReadPost', 'BufWritePost', 'CursorHold' },
    hl = { fg = 'orange' }
}

M.filetype = {
    static = {
        icon = 'FT: '
    },
    init = function(self)
        self.ft = vim.bo.filetype
        if vim.g.nerdfonts then
            self.icon = require('nvim-web-devicons')
                .get_icon_by_filetype(self.ft, { default = true }) .. ' '
        end
    end,
    provider = function(self)
        if self.ft ~= '' then
            return '  ' .. self.icon .. self.ft
        end
    end,
    update = { 'FileType', 'BufNewFile', 'BufEnter' }
}

M.lsp = {
    condition = conditions.lsp_attached,
    static = {
        icon = vim.g.nerdfonts and ' ' or 'LSP: '
    },
    {
        provider = function(self)
            local names = {}
            for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
            end
            return '  ' .. self.icon .. table.concat(names, ' ')
        end,
        update = { 'LspAttach' ,'LspDetach' },
    },
    {
        condition = spinner.spinner_active,
        provider = function()
            return ' ' .. require('snacks.util').spinner()
        end,
        update = { 'User', pattern = 'LspSpinner' }
    },
}

M.encoding = {
    static = {
        icon = vim.g.nerdfonts and ' ' or 'ENC: '
    },
    init = function(self)
        self.enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
    end,
    provider = function(self)
        if self.enc ~= 'utf-8' then
            return '  ' .. self.icon .. self.enc:upper()
        end
    end,
    update = { 'BufReadPost', 'BufWritePost' }
}

M.indent = {
    condition = function()
        return vim.bo.filetype ~= 'bigfile'
    end,
    static = {
        icon = vim.g.nerdfonts and '󰉶 ' or 'IND: '
    },
    init = function(self)
        self.spaces = vim.fn.search('^\t* \t*', 'nwc') ~= 0
        self.tabs = vim.fn.search('^ *\t *', 'nwc') ~= 0
        self.indent = ''
        if (self.spaces and self.tabs) then
            self.indent = 'Mix'
        elseif self.spaces then
            self.indent = 'Spaces'
        elseif self.tabs then
            self.indent = 'Tabs'
        end
    end,
    provider = function(self)
        if self.indent ~= '' then
            return '  ' .. self.icon .. self.indent
        end
    end,
    hl = function(self)
        return self.indent == 'Mix' and { fg = 'red' }
    end,
    update = { 'BufReadPost', 'BufWritePost', 'CursorHold', 'InsertLeave' },
}

M.progress = {
    static = {
        icon = vim.g.nerdfonts and '' or 'PRG:'
    },
    provider = function(self)
        return '  ' .. self.icon .. ' %P'
    end
}

M.search_count = {
    condition = function()
        return vim.bo.filetype ~= 'bigfile'
    end,
    static = {
        icon = vim.g.nerdfonts and ' ' or 'SEARCH: '
    },
    init = function(self)
        self.search = vim.fn.searchcount({ maxcount = 999, timeout = 250 })
    end,
    provider = function(self)
        if vim.tbl_isempty(self.search) or self.search.incomplete == 1 then
            return
        end
        local total = self.search.total
        local flag = ''
        if self.search.incomplete == 2 then
            total = self.search.maxcount
            flag = '+'
        end
        return string.format('  %s%d/%d%s', self.icon, self.search.current, total, flag)
    end,
    update = { 'CursorMoved' },
}

M.venv = {
    condition = function()
        return vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
    end,
    static = {
        icon = vim.g.nerdfonts and '󰆧 ' or 'VENV: '
    },
    provider = function(self)
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
        local name = vim.fn.fnamemodify(venv, ':t')
        return '  ' .. self.icon .. name
    end,
    update = { 'VimEnter' },
}

M.revision = {
    condition = function()
        return require 'tummetott.utils'.is_loaded('diffview.nvim') and
            require 'diffview.lib'.get_current_view()
    end,
    static = {
        icon = vim.g.nerdfonts and '󱞳' or '@'
    },
    provider = function(self)
        local view = require('diffview.lib').get_current_view()
        local bufnr = vim.api.nvim_get_current_buf()
        local rev_label = ''
        for _, file in ipairs(view.cur_entry and view.cur_entry.layout:files() or {}) do
            if file:is_valid() and file.bufnr == bufnr then
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
        return string.format(' %s %s', self.icon, rev_label)
    end,
    update = {
        'User',
        pattern = 'DiffviewDiffBufWinEnter'
    }
}

M.bufname = {
    static = {
        oil_icon = vim.g.nerdfonts and ' ' or ''
    },
    init = function(self)
        local bufname = vim.api.nvim_buf_get_name(0)
        local ft = vim.bo.filetype
        if bufname == '' then
            self.bufname = '[No File]'
            self.icon = ''
            return
        elseif ft == 'oil' then
            bufname = bufname:gsub('^oil://', '')
            self.bufname = vim.fn.fnamemodify(bufname, ':~')
            self.icon = self.oil_icon
            self.icon_color = '#e68805'
            return
        elseif bufname:match('^diffview://') then
            if bufname == 'diffview://null' then
                self.bufname = '[Empty Diffview]'
                self.icon = ''
                return
            end
            bufname = bufname:gsub('^diffview://', '')
            bufname = bufname:gsub('%.git/[^/]+/', '')
        end
        self.bufname = vim.fn.fnamemodify(bufname, ':~:.')
        if vim.g.nerdfonts then
            self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(
                vim.fn.expand('%:t'), nil, { default = true })
            self.icon = self.icon .. ' '
        end
    end,
    {
        provider = function(self)
            return self.icon
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    },
    {
        flexible = true,
        {
            provider = function(self)
                return self.bufname
            end
        },
        {
            provider = function(self)
                return vim.fn.pathshorten(self.bufname, 2)
            end
        },
        {
            provider = function(self)
                return vim.fn.pathshorten(self.bufname)
            end
        },
    },
    update = {
        'BufEnter',
        'BufFilePost',
        'DirChanged',
        'FileType',
        'BufWritePost',
        'VimResized',
    }
}

M.buff_modified = {
    provider = function()
        local modified_icon = ''
        if vim.bo.modified then
            modified_icon = vim.g.nerdfonts and '●' or '*'
        elseif vim.bo.readonly or not vim.bo.modifiable then
            modified_icon = vim.g.nerdfonts and '' or '#'
        end
        return ' ' .. modified_icon
    end,
    update = { 'BufModifiedSet', 'BufEnter' }
}

M.help_bufname = {
    condition = function()
        return vim.bo.filetype == 'help'
    end,
    static = {
        icon = vim.g.nerdfonts and '󰈙 ' or ''
    },
    provider = function(self)
        local bufname = vim.api.nvim_buf_get_name(0)
        bufname = vim.fn.fnamemodify(bufname, ':t')
        return self.icon .. bufname
    end,
    update = { 'BufEnter', 'BufFilePost' },
}

M.man_bufname = {
    condition = function()
        return vim.bo.filetype == 'man'
    end,
    static = {
        icon = vim.g.nerdfonts and '󰈙 ' or ''
    },
    provider = function(self)
        local bufname = vim.api.nvim_buf_get_name(0)
        local name = bufname:match('^man://(.+)')
        return self.icon .. (name or '[Empty Manpage]')
    end,
    update = { 'BufEnter', 'BufFilePost' },
}

M.special_bufname = {
    static = {
        bufnames = {
            ['NvimTree'] = 'NVIMTREE',
            ['TelescopePrompt'] = 'TELESCOPE',
            ['DressingInput'] = 'INPUT',
            ['lazy'] = 'LAZY',
            ['Outline'] = 'OUTLINE',
        }
    },
    provider = function(self)
        local ft = vim.bo.filetype
        return self.bufnames[ft]
    end,
    hl = { fg = 'blue', bold = true }
}

-------------------------------------------------------

local function flex(component, priority)
    return {
        flexible = priority,
        component,
        { provider = '' }
    }
end

M.default_statusline = {
    M.mode,
    flex(M.git, 12),
    flex(M.diagnostics, 11),
    M.align,
    flex(M.git_conflict, 6),
    flex(M.trailing_whitespace, 5),
    flex(M.filetype, 13),
    flex(M.venv, 8),
    flex(M.lsp, 10),
    flex(M.encoding, 7),
    flex(M.indent, 9),
    flex(M.search_count, 14),
    M.progress,
}

M.special_statusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = {
                'nofile',
                'prompt',
                'help',
                'quickfix',
                'acwrite',
            },
        })
    end,
    {
        fallthrough = false,
        M.help_bufname,
        M.man_bufname,
        {
            condition = function()
                return vim.bo.filetype == 'oil'
            end,
            M.mode
        },
        M.special_bufname,
    },
    M.align,
    {
        -- Don't show search count and percentage for some special files
        condition = function()
            return not conditions.buffer_matches({
                filetype = { 'TelescopePrompt', 'DressingInput' },
            })
        end,
        M.search_count,
        M.progress,
    }
}

M.statusline = {
    condition = function()
        return not conditions.buffer_matches({
            filetype = { 'snacks_dashboard' },
            buftype = { 'terminal' }
        })
    end,
    hl = {
        fg = 'fg',
        bg = 'bg',
    },
    M.left_moon,
    {
        fallthrough = false,
        M.special_statusline,
        M.default_statusline,
    },
    M.right_moon
}

M.winbar = {
    hl = {
        fg = 'fg',
        bg = 'bg',
    },
    M.left_moon,
    M.bufname,
    M.revision,
    M.buff_modified,
    M.align,
    M.right_moon
}

M.tabline = {
    condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
    end,
    static = {
        icon_active = vim.g.nerdfonts and '' or '*',
        icon_inactive = vim.g.nerdfonts and '' or 'o',
    },
    M.align,
    utils.make_tablist({
        provider = function(self)
            local icon = self.is_active and self.icon_active or self.icon_inactive
            return '%' .. self.tabnr .. 'T ' .. icon .. ' %T'
        end,
    }),
    hl = {
        fg = 'surface2'
    }
}

return M
