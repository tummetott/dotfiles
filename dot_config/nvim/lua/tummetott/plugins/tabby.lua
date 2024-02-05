return {
    'nanozuki/tabby.nvim',
    enabled = true,
    event = 'TabNew',
    config = function()
        local icon1 = ''
        local icon2 = ''
        if not vim.g.nerdfonts then
            icon1 = '*'
            icon2 = 'o'
        end
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
