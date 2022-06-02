local class = require "lib/class"
local HJKL = class()

function HJKL:__init(controller)
    self.controller = controller
end

function HJKL:handle(events)
    if #events < 2 or events[1] ~= "key" then
        return
    end
    
    if events[2] == keys.h then
        self.controller:notify({"update_cursor_horizontal", -1})
    elseif events[2] == keys.l then
        self.controller:notify({"update_cursor_horizontal", 1})
    elseif events[2] == keys.j then
        self.controller:notify({"update_cursor_vertical", -1})
    elseif events[2] == keys.k then
        self.controller:notify({"update_cursor_vertical", 1})
    end
end

return HJKL