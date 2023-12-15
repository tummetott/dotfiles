-- This is a standalone config file for neovim which is only used for kitty
-- scrollback buffers.

local prefix = vim.fn.stdpath('data')
vim.opt.runtimepath:append {
    prefix .. '/lazy/catppuccin',
    prefix .. '/lazy/nvim-surround',
    prefix .. '/lazy/flash.nvim',
    prefix .. '/lazy/kitty-scrollback.nvim',
}

vim.g.mapleader = ' '

require('catppuccin').setup {
    flavour = 'frappe',
    custom_highlights = function(c)
        local darken = require 'catppuccin.utils.colors'.darken
        return {
            Visual = { bg = c.surface0, style = { nil } },
            Search = { fg = c.surface0, bg = darken(c.lavender, 0.7, c.base) },
            CurSearch = { link = 'Search' },
            IncSearch = { bg = c.maroon },
            FlashLabel = { fg = c.base, bg = c.maroon, style = { 'bold' } },
        }
    end
}
vim.cmd.colorscheme 'catppuccin'

require('nvim-surround').setup {
    move_cursor = false,
    keymaps = {
        insert = false,
        insert_line = false,
        normal = 's',
        normal_cur = 'ss',
        normal_line = 'S',
        normal_cur_line = 'SS',
        visual = 's',
        visual_line = 'S',
    }
}

require('flash').setup {
    modes = {
        char = { enabled = false },
        search = { enabled = false },
    },
    label = {
        current = true,
        before = false,
        after = true,
    },
}
vim.keymap.set('c', '<c-j>', require('flash').toggle)

require('kitty-scrollback').setup {
    global = function()
        return {
            paste_window = {
                winopts_overrides = function()
                    local width = math.floor(vim.o.columns / 6 * 5)
                    local height = math.floor(vim.o.lines / 3 * 2)
                    return {
                        border = 'rounded',
                        row = math.floor((vim.o.lines - height) / 2) - 2,
                        col = math.floor((vim.o.columns - width) / 2),
                        height = height,
                        width = width,
                    }
                end,
                footer_winopts_overrides = function()
                    return {
                        border = 'rounded',
                    }
                end,
                highlight_as_normal_win = function() return true end
            },
            visual_selection_highlight_mode = 'nvim',
            kitty_get_text = {
                extent = 'all',
            },
        }
    end,
    last_cmd = function()
        return {
            kitty_get_text = {
                extent = 'last_non_empty_output',
            },
        }
    end,
    last_visisted_cmd = function()
        return {
            kitty_get_text = {
                extent = 'last_visited_cmd_output',
            },
        }
    end
}
