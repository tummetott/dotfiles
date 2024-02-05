return {
    'goolord/alpha-nvim',
    enabled = true,
    event = 'VimEnter',
    config = function()
        local cat = {
            '⠀⡀⠀⠀⠀⢠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
            '⠀⠈⣿⢶⣦⡏⠙⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
            '⠀⢀⣴⣿⣿⣿⣿⣾⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
            '⠀⣿⡿⢛⣿⣿⣿⣿⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
            '⢀⣿⣷⣿⣿⣿⣿⠃⣾⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
            '⠀⠺⠿⠿⣿⣿⣿⣼⣿⣿⣿⣿⣿⣠⣄⡀⠀⠀⠀⠀⠀⠀   ',
            '⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣷⣆⠀⠀⠀⠀   ',
            '⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⠏⣾⣿⣿⣿⣿⣿⡀⠀⠀⠀   ',
            '⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⡟⣰⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀   ',
            '⠀⠀⠀⠀⠻⣿⣿⣿⣿⢏⣴⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀   ',
            '⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⢣⣿⡿⢟⣿⣿⣿⠀⠀   ',
            '⠀⠀⠀⠀⠀⠀⢹⣷⣽⢻⣿⣿⠃⠞⣫⣴⣿⣿⣿⣿⡟⠀   ',
            '⠀⠀⠀⠀⠀⢳⣄⠙⠇⢸⣿⠃⣠⣾⣿⣿⣿⣿⣿⣿⡇⠀   ',
            '⠀⠀⠀⠀⠀⠀⢿⣷⣤⣈⠛⠀⢿⣿⣿⣿⣿⣿⣿⠟⠀⠀   ',
            '⠀⠀⠀⠀⠀⠀⢀⡉⠛⢿⣿⣶⣤⣈⣉⣉⣉⣉⣉⣰⣿⠄   ',
            '⠀⠀⠀⠀⠀⠀⠏⢴⣷⡦⠌⠙⠻⢿⡿⠿⠿⠿⠿⠿⠃⠀   ',
            '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ',
        }
        local cat2 = {
            [[   ,_     _         ]],
            [[   |\\_,-~/         ]],
            [[   / _  _ |    ,--. ]],
            [[  (  @  @ )   / ,-' ]],
            [[   \  _T_/-._( (    ]],
            [[   /         `. \   ]],
            [[  |         _  \ |  ]],
            [[   \ \ ,  /      |  ]],
            [[    || |-_\__   /   ]],
            [[   ((_/`(____,-'    ]],
        }
        local image = {
            type = 'text',
            val = vim.g.nerdfonts and cat or cat2,
            opts = {
                position = 'center',
                hl = 'AlphaHeader',
            },
        }

        local release = {
            type = 'text',
            val = function()
                local v = vim.version()
                return string.format('NVIM v%d.%d.%d', v.major, v.minor, v.patch)
            end,
            opts = {
                position = 'center',
                hl = 'AlphaFooter',
            }
        }

        local get_padding = function ()
            local win_height = vim.api.nvim_win_get_height(0)
            local img_height = #image.val
            local greeter_height = win_height - img_height - 2
            if greeter_height < 0 then return 0 end
            return math.floor(greeter_height / 2)
        end

        require('alpha').setup {
            layout = {
                { type = 'padding', val = get_padding },
                image,
                { type = 'padding', val = 2 },
                release,
            },
            opts = {
                noautocmd = true,
                keymap = {
                    press = nil
                }
            }
        }

        -- Register key bindings
        local group = vim.api.nvim_create_augroup('Alpha', { clear = true })
        vim.api.nvim_create_autocmd('User', {
            pattern = 'AlphaReady',
            callback = function(ctx)
                vim.keymap.set(
                    'n',
                    'q',
                    '<CMD>quit<CR>',
                    { buffer = ctx.buf, desc = 'Quit' }
                )
                vim.keymap.set(
                    'n',
                    'i',
                    '<CMD>enew <BAR> startinsert <CR>',
                    { buffer = ctx.buf, desc = 'New file' }
                )
                vim.keymap.set(
                    'n',
                    '<CR>',
                    '<CMD>enew<CR>',
                    { buffer = ctx.buf, desc = 'New file' }
                )
            end,
            group = group,
        })

    end,
}
