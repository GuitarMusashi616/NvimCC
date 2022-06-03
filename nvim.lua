local tArgs = {...}

function load_file(filename)
    local h = io.open(filename, "r")

    local lines = {}
    for line in h:lines() do
        table.insert(lines, line)
    end

    h:close()
    return lines
end

function blit(lines, n, m)
    local l = 1
    for i=n,m do
        term.setCursorPos(1,l)
        term.clearLine()
        term.write(lines[i])
        l = l + 1
    end
end

function handle_events(filename)
    local w,h = term.getSize()
    local y1,y2 = 1, h
    local x,y = 1,1
    local lines = load_file(filename)
    blit(lines, y1, y2)
    term.setCursorPos(x,y)    
    term.setCursorBlink(true)
    while true do
        local events = {os.pullEvent("key")}
        if events[2] == keys.down then
            y1 = y1 + 1
            y2 = y2 + 1
            blit(lines, y1, y2)
            term.setCursorPos(x,y)
        elseif events[2] == keys.up then
            y1 = y1 - 1
            y2 = y2 - 1
            blit(lines, y1, y2)
            term.setCursorPos(x,y)
        elseif events[2] == keys.left then
            x = x - 1
            term.setCursorPos(x,y)
        elseif events[2] == keys.right then
            x = x + 1
            term.setCursorPos(x,y)
        end
    end
end

handle_events(tArgs[1])