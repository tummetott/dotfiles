return {
    'nvim-tree/nvim-tree.lua',
    enabled = true,
    dependencies = 'nvim-tree/nvim-web-devicons',
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
                show = {
                    git = false,
                },
            },
        },
    },
    keys = {
        {
            '<C-\\>',
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
