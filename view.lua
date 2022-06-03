local class = require "lib/class"

local View = class()

function View:__init(controller)
    term.setCursorPos(1,1)
    term.setCursorBlink(true)
    self.controller = controller
end

function View:render(lines, n, m)
    local l = 1
    for i=n,m do
        term.setCursorPos(1,l)
        term.clearLine()
        term.write(lines[i])
        l = l + 1
    end
end

-- function View:subscribe(subscriber)
--     if not subscriber.update then
--         error(tostring(subscriber) .. " must have an update method", -1)
--     end
--     table.insert(self.subscribers, subscriber)
-- end

-- function View:notify(events)
--     for i, subscriber in pairs(self.subscribers) do
--        subscriber:update(events)
--     end
-- end

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