return {
    'nvim-tree/nvim-tree.lua',
    enabled = true,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.nerdfonts,
    },
    opts = {
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
        },
        renderer = {
            highlight_git = true,
            indent_markers = {
                enable = true,
            },
            icons = {
                glyphs = {
                    folder = {
                        arrow_closed = vim.g.nerdfonts and '' or '>',
                        arrow_open = vim.g.nerdfonts and '' or 'v',
                    },
                },
                show = {
                    file = vim.g.nerdfonts,
                    folder = vim.g.nerdfonts,
                    folder_arrow = true,
                    git = false,
                    modified = false,
                    diagnostics = false,
                    bookmarks = false,
                },
            },
        },
    },
    keys = {
        {
            '<C-m>',
            '<Cmd>NvimTreeToggle<CR>',
            desc = 'Toggle NvimTree',
        }
    },
    cmd = {
        'NvimTreeOpen',
        'NvimTreeClose',
        'NvimTreeToggle',
        'NvimTreeFocus',
        'NvimTreeRefresh',
        'NvimTreeFindFile',
        'NvimTreeFindFileToggle',
        'NvimTreeClipboard',
        'NvimTreeResize',
        'NvimTreeCollapse',
        'NvimTreeCollapseKeepBuffers',
    },
}
