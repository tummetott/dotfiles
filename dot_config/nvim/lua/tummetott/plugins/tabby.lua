return {
    'nanozuki/tabby.nvim',
    enabled = false,
    event = 'TabNew',
    config = function()
        local icon1 = vim.g.nerdfonts and '' or '*'
        local icon2 = vim.g.nerdfonts and '' or 'o'
        local function render_function(line)
            return {
                line.spacer(),
                line.tabs().foreach(function(tab)
                    local icon = tab.is_current() and icon1 or icon2
                    return { ' ', icon, ' ', hl = 'TabbyTab' }
                end),
            }
        end
        require('tabby.tabline').set(render_function)
    end,
}
