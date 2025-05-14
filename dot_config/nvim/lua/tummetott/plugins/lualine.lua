local colors = {}
local ok, catppuccin = pcall(require, 'catppuccin.palettes')
if ok then
    local c = catppuccin.get_palette('frappe')
    if not c then return end
    colors.fg = c.subtext0
    colors.bg = c.surface0
    colors.base = c.base
    colors.red = c.red
    colors.orange = c.peach
    colors.yellow = c.yellow
    colors.blue = c.blue
    colors.teal = c.teal
    colors.purple = c.mauve
end

local theme = {
    normal = {
        a = { bg = colors.bg, fg = colors.blue, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        x = { bg = colors.bg, fg = colors.fg },
        y = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
    },
    insert = {
        a = { bg = colors.bg, fg = colors.teal, gui = 'bold' },
    },
    visual = {
        a = { bg = colors.bg, fg = colors.orange, gui = 'bold' },
    },
    replace = {
        a = { bg = colors.bg, fg = colors.red, gui = 'bold' },
    },
    command = {
        a = { bg = colors.bg, fg = colors.purple, gui = 'bold' },
    },
    -- inactive = {
    --     a = { bg = colors.bg, fg = colors.gray, gui = 'bold' },
    -- }
}

local mix = false

return {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        sections = {
            lualine_a = {
                {
                    'mode',
                    separator = { left = '' }
                },
            },
            lualine_b = {
                {
                    'branch',
                    icon = '',
                    icons_enabled = vim.g.nerdfonts,
                },
                -- {
                --     'diff',
                --     colored = false,
                --     symbols = vim.g.nerdfonts and { added = ' ', modified = ' ', removed = ' ' } or
                --         { added = '+', modified = '~', removed = '-' }
                -- },
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    sections = { 'error', 'warn', 'info', 'hint' },
                    symbols = vim.g.nerdfonts and { error = '  ', warn = '  ', info = '  ', hint = '  ' } or
                        { error = 'E', warn = 'W', info = 'I', hint = 'H' },
                    colored = true,
                    update_in_insert = false,
                    always_visible = false,
                },
            },
            lualine_c = {},
            lualine_x = {
                {
                    -- Git conflict
                    -- PERF: disable in bigfile
                    function()
                        local conflicts = vim.fn.search('^[<>|]\\{7} \\|=\\{7}$', 'nwc')
                        return conflicts > 0 and 'MERGE CONFLICT' or ''
                    end,
                    color = { fg = colors.red, gui = 'bold' },
                },
                {
                    -- Trailing whitespace
                    function()
                        local tw = vim.fn.search('\\s$', 'nwc') ~= 0
                        return tw and 'TRAILING WHITESPACE' or ''
                    end,
                    color = { fg = colors.orange, gui = 'bold' },
                }
            },
            lualine_y = {
                {
                    'filetype',
                    colored = false,
                    icon = { align = 'left' },
                    icons_enabled = vim.g.nerdfonts,
                },
                -- TODO: Conda env
                {
                    'lsp_status',
                    icon = '',
                    symbols = {
                        spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                        done = '',
                        separator = ' ' -- Delimiter between lsp names
                    }
                },
                {
                    'encoding',
                    icon = '',
                    icons_enabled = vim.g.nerdfonts,
                    fmt = string.upper,
                },
                {
                    -- Indent
                    -- TODO: color in red when mixed indent
                    -- PERF: disable for bigfiles
                    function()
                        local spaces = vim.fn.search('^\t* \t*', 'nwc') ~= 0
                        local tabs = vim.fn.search('^ *\t *', 'nwc') ~= 0
                        local indent = ''
                        if (spaces and tabs) then
                            indent = 'Mix'
                            mix = true
                        elseif spaces then
                            indent = 'Spaces'
                        elseif tabs then
                            indent = 'Tab'
                        end
                        return indent
                    end,
                    icon = '󰉶',
                    icons_enabled = vim.g.nerdfonts,
                    color = function()
                        if mix then
                            return { fg = colors.red }
                        end
                    end
                },
                -- TODO: searchcount
            },
            lualine_z = {
                {
                    'progress',
                    icon = '',
                    icons_enabled = vim.g.nerdfonts,
                    separator = { right = '' }
                }
            }
        },
        extensions = {
            {
                sections = {
                    lualine_b = {
                        {
                            'filename',
                            separator = { left = '' }
                        },
                    },
                    lualine_z = {
                        {
                            function()
                                return ''
                            end,
                            separator = { right = '' },
                            draw_empty = true,
                        }
                    }
                },
                filetypes = { 'help' },
            },
        },
        options = {
            theme = theme,
            always_show_tabline = false,
            -- globalstatus = true, -- TODO: delete is not necessary
            component_separators = {
                left = '',
                right = '',
            },
            section_separators = {
                left = '',
                right = '',
            },
            disabled_filetypes = {
                statusline = {}, -- TODO:
                winbar = {}      -- TODO:
            },
            ignore_focus = {},
        },
        tabline = {}, -- TODO:
        winbar = {}   -- TODO:
    }
}
