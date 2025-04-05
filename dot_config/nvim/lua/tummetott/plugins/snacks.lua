local cat1 = [[
⠀⡀⠀⠀⠀⢠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   
⠀⠈⣿⢶⣦⡏⠙⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   
⠀⢀⣴⣿⣿⣿⣿⣾⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   
⠀⣿⡿⢛⣿⣿⣿⣿⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   
⢀⣿⣷⣿⣿⣿⣿⠃⣾⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀   
⠀⠺⠿⠿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣠⣄⡀⠀⠀⠀⠀⠀⠀   
⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣷⣆⠀⠀⠀⠀   
⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⠏⣾⣿⣿⣿⣿⣿⡀⠀⠀⠀   
⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⡟⣰⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀   
⠀⠀⠀⠀⠻⣿⣿⣿⣿⢏⣴⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀   
⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⢣⣿⡿⢟⣿⣿⣿⠀⠀   
⠀⠀⠀⠀⠀⠀⢹⣷⣽⢻⣿⣿⠃⠞⣫⣴⣿⣿⣿⣿⡟⠀   
⠀⠀⠀⠀⠀⢳⣄⠙⠇⢸⣿⠃⣠⣾⣿⣿⣿⣿⣿⣿⡇⠀   
⠀⠀⠀⠀⠀⠀⢿⣷⣤⣈⠛⠀⢿⣿⣿⣿⣿⣿⣿⠟⠀⠀   
⠀⠀⠀⠀⠀⠀⢀⡉⠛⢿⣿⣶⣤⣈⣉⣉⣉⣉⣉⣰⣿⠄   
⠀⠀⠀⠀⠀⠀⠏⢴⣷⡦⠌⠙⠻⢿⡿⠿⠿⠿⠿⠿⠃⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   
]]

local cat2 = [[
   ,_     _        
   |\\_,-~/        
   / _  _ |    ,--.
  (  @  @ )   / ,-'
   \  _T_/-._( (   
   /         `. \  
  |         _  \ | 
   \ \ ,  /      | 
    || |-_\__   /  
   ((_/`(____,-'   
]]

return {
    'folke/snacks.nvim',
    enabled = true,
    priority = 1000,
    lazy = false,
    opts = {
        -- TODO: feline is very slow on big files. Also foldexpr slows down the
        -- loading of bigfiles
        bigfile = {
            enabled = true,
        },
        dashboard = {
            enabled = true,
            sections = {
                {
                    text = {
                        vim.g.nerdfonts and cat1 or cat2,
                        align = 'center',
                        hl = 'SnacksDashboardHeader',
                    }
                },
                {
                    text = {
                        (function()
                            local v = vim.version()
                            return string.format('NVIM v%d.%d.%d', v.major, v.minor, v.patch)
                        end)(),
                        align = 'center',
                        hl = 'SnacksDashboardFooter',
                    }
                },
                {
                    key = 'i',
                    action = '<CMD>enew <BAR> startinsert <CR>',
                    hidden = true
                },
                -- ISSUE: https://github.com/folke/snacks.nvim/issues/1678
                {
                    key = '<cr>',
                    action = '<CMD>enew<CR>',
                    hidden = true
                },
                {
                    key = 'q',
                    action = '<CMD>quit<CR>',
                    hidden = true
                }
            }
        },
        -- explorer = { enabled = true },
        -- indent = { enabled = true },
        -- input = { enabled = true },
        -- picker = { enabled = true },
        -- notifier = { enabled = true },
        -- quickfile = { enabled = true },
        -- scope = { enabled = true },
        -- scroll = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- words = { enabled = true },
    },
}
