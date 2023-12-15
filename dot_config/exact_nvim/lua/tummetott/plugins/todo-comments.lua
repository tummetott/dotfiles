return {
    'folke/todo-comments.nvim',
    enabled = true,
    opts = {
        highlight = {
            keyword = '',
            after = '',
        },
    },
    event = 'LazyFile',
    keys = {
        {
            '<Leader>to',
            '<Cmd>TodoTrouble<CR>',
            desc = 'open todos',
        },
        {
            '<Leader>ft',
            '<Cmd>TodoTelescope keywords=TODO,FIX,PERF<CR>',
            desc = 'todos',
        },
    },
}
