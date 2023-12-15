return {
    'nanozuki/tabby.nvim',
    enabled = true,
    event = 'TabNew',
    config = function()
        local function render_function(line)
            return {
                line.spacer(),
                line.tabs().foreach(function(tab)
                    local icon = tab.is_current() and '' or ''
                    return { ' ', icon, ' ', hl = 'TabbyTab' }
                end),
            }
        end
        require('tabby.tabline').set(render_function)
    end,
}
