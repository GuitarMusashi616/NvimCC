local class = require "lib/class"
local util = require "lib/util"

local View = class()

function View:__init(controller)
    term.setCursorPos(1,1)
    term.setCursorBlink(true)
    self.controller = controller
end

function View:render(lines, y1, y2, x1)
    local x,y = term.getCursorPos()
    local x1 = x1 or 1
    local l = 1
    for y = y1, y2 do
        term.setCursorPos(1,l)
        term.clearLine()
        local line = lines[y]:sub(x1)
        term.write(line)
        l = l + 1
    end
    term.setCursorPos(x,y)
end

function View:update_cursor(curX, curY)
    term.setCursorPos(curX, curY)
end

function View:handle_events()
   while true do
       local events = {os.pullEvent()}
       self.controller:notify(events)
   end
end

return View