local class = require "lib/class"

local InsertMode = class()

function InsertMode:__init(controller)
    self.controller = controller
    self.ignored_first_i = false
    self.ctrl_held = false
end

function InsertMode:handle(events, model)
    if not events or model:get_mode() ~= "insert" then
        return
    end
    
    if events[1] == "key" and events[2] == keys.c and self.ctrl_held then
        self.ignored_first_i = false
        self.ctrl_held = false
        self.controller:notify{"switch_mode", "normal"}
    elseif events[1] == "key" and events[2] == keys.leftCtrl then
        self.ctrl_held = true
    elseif events[1] == "key_up" and events[2] == keys.leftCtrl then
        self.ctrl_held = false
    elseif events[1] == "char" then
        if events[2] == "i" and not self.ignored_first_i then
            self.ignored_first_i = true
            return        
        end
        self.controller:notify{"insert", events[2]}
    elseif events[1] == "key" and events[2] == keys.backspace then
        self.controller:notify{"backspace", 1}
    elseif events[1] == "key" and events[2] == keys.enter then
        self.controller:notify{"enter", 1}
    elseif events[1] == "key" and events[2] == keys.tab then
        self.controller:notify{"insert", "\t\t\t\t"}     
    end
end

return InsertMode