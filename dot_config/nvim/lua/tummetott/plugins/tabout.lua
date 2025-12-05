return {
    'abecodes/tabout.nvim',
    enabled = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
        tabkey = '<Tab>',
        backwards_tabkey = '<S-Tab>',
        enable_backwards = true,
        -- Shift content if tab out is not possible.
        act_as_tab = true,
        -- Reverse shift content if tab out is not possible.
        act_as_shift_tab = true,
        -- If you use a completion pum that also uses the tab key for a smart
        -- scroll function. Setting this to true will disable tab out when the
        -- pum is open and execute the smart scroll function instead.
        completion = true,
        tabouts = {
            {open = "'", close = "'"},
            {open = '"', close = '"'},
            {open = '`', close = '`'},
            {open = '(', close = ')'},
            {open = '[', close = ']'},
            {open = '{', close = '}'}
        },
        -- Tabout will ignore these filetypes
        exclude = {}
    },
    keys = {
        {
            '<tab>',
            mode = 'i',
        },
        {
            '<s-tab>',
            mode = 'i',
        },
    }
}
