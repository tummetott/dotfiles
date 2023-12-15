-- Splitting & joining blocks of code
return {
    'Wansmer/treesj',
    enabled = true,
    opts = {
        use_default_keymaps = false,
    },
    cmd = {
        'TSJToggle',
        'TSJSplit',
        'TSJJoin',
    },
    keys = {
        {
            'gs',
            '<Cmd>TSJToggle<CR>',
            desc = 'Split/Join current code block',
        }
    },
}
