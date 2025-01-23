return {
    'folke/todo-comments.nvim',
    enabled = true,
    opts = {
        keywords = {
            FIX = {
                icon = vim.g.nerdfonts and ' ' or '',
                color = 'error',
                alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
            },
            TODO = {
                icon = vim.g.nerdfonts and ' ' or '',
                color = 'info',
            },
            HACK = {
                icon = vim.g.nerdfonts and ' ' or '',
                color = 'warning',
            },
            WARN = {
                icon = vim.g.nerdfonts and ' ' or '',
                color = 'warning',
                alt = { 'WARNING' },
            },
            PERF = {
                icon = vim.g.nerdfonts and ' ' or '',
                alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' },
            },
            NOTE = {
                icon = vim.g.nerdfonts and ' ' or '',
                color = 'hint',
                alt = { 'INFO' },
            },
            TEST = {
                icon = vim.g.nerdfonts and '⏲ ' or '',
                color = 'test',
                alt = { 'TESTING', 'PASSED', 'FAILED' },
            },
        },
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
            desc = 'Toggle todo list',
        },
        {
            '<Leader>ft',
            '<Cmd>TodoTelescope keywords=TODO,FIX,PERF<CR>',
            desc = 'Todos',
        },
    },
}
