---@diagnostic disable-next-line: undefined-global
local rex = rex

rex.bind('ctrl+shift+t', 'client.tab.new')
rex.bind('ctrl+shift+s', 'pane.split', { direction = 'auto' })
rex.bind('ctrl+shift+u', 'pane.split', { direction = 'down' })
rex.bind('ctrl+shift+w', 'pane.close')
rex.bind('ctrl+shift+h', 'pane.focus', { direction = 'left' })
rex.bind('ctrl+shift+l', 'pane.focus', { direction = 'right' })
rex.bind('ctrl+shift+j', 'pane.focus', { direction = 'down' })
rex.bind('ctrl+shift+k', 'pane.focus', { direction = 'up' })
rex.bind('ctrl+shift+p', 'client.tab.previous')
rex.bind('ctrl+shift+n', 'client.tab.next')
rex.bind('ctrl+shift+m', 'client.mode.enter', { name = 'move' })
rex.bind('ctrl+shift+r', 'client.tab.rename')
rex.bind('ctrl+shift+z', 'pane.zoom')
rex.bind('ctrl+shift+i', 'pane.move_to_new_tab')
rex.bind('ctrl+shift+[', 'client.prompt.previous')
rex.bind('ctrl+shift+]', 'client.prompt.next')
for i = 1, 9 do
    rex.bind('ctrl+shift+' .. i, 'client.tab.goto', { index = i })
end

rex.mode('move', { exclusive = true })
for _, d in ipairs({
    { 'h', 'left' }, { 'left', 'left' },
    { 'j', 'down' }, { 'down', 'down' },
    { 'k', 'up' }, { 'up', 'up' },
    { 'l', 'right' }, { 'right', 'right' },
}) do
    rex.bind('move/' .. d[1], 'pane.move', { direction = d[2] })
    if #d[1] == 1 then
        rex.bind('move/ctrl+shift+' .. d[1], 'pane.move', { direction = d[2] })
    end
end
rex.bind('move/[', 'client.tab.move', { direction = 'backward' })
rex.bind('move/ctrl+shift+[', 'client.tab.move', { direction = 'backward' })
rex.bind('move/]', 'client.tab.move', { direction = 'forward' })
rex.bind('move/ctrl+shift+]', 'client.tab.move', { direction = 'forward' })
rex.bind('move/enter', 'client.mode.exit')
rex.bind('move/esc', 'client.mode.exit')
rex.bind('move/ctrl+c', 'client.mode.exit')

rex.bind('shift+backspace', 'pane.send_key', { key = 'shift+backspace' })
