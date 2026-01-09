return {
    'rebelot/heirline.nvim',
    enabled = true,
    lazy = false,
    dependencies = 'lewis6991/gitsigns.nvim',
    config = function()
        local comp = require('tummetott.plugins.heirline.components')
        local colors = require('tummetott.utils.color').load_alias_colors()
        require('heirline').setup {
            statusline = comp.statusline,
            winbar = comp.winbar,
            tabline = comp.tabline,
            opts = {
                colors = colors,
                disable_winbar_cb = function(args)
                    return require('heirline.conditions').buffer_matches({
                        buftype = {
                            'nofile',
                            'prompt',
                            'help',
                            'quickfix',
                        },
                        filetype = {
                            'trouble',
                            'FTerm',
                            'help',
                            'NvimTree',
                            'man',
                            'DiffviewFiles',
                            'DiffviewFileHistory',
                            'qf',
                            'sidekick_terminal',
                            'snacks_dashboard',
                        },
                    }, args.buf)
                end,
            }
        }
        vim.api.nvim_create_autocmd('User', {
            group = vim.api.nvim_create_augroup('HeirlineColorUpdate', { clear = true }),
            pattern = 'TintedColorsPost',
            callback = function()
                vim.schedule(function()
                    ---@diagnostic disable-next-line: redefined-local
                    local colors = require('tummetott.utils.color').load_alias_colors()
                    if colors then
                        require('heirline.utils').on_colorscheme(colors)
                        vim.cmd('redrawstatus')
                        vim.cmd('redrawtabline')
                    end
                end)
            end,
        })
    end,
}
