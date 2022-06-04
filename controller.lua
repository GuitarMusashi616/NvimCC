local class = require "lib/class"

local Controller = class()

function Controller:__init()
    self.model = nil
    self.view = nil
    self.event_handlers = {}
end

function Controller:set_model(model)
    self.model = model
end

function Controller:set_view(view)
    self.view = view
end

function Controller:add_event_handler(handler)
    if not handler.handle then
        error(tostring(handler) .. " must have a handle method", 0)
    end
    table.insert(self.event_handlers, handler)
end

function Controller:notify_handlers(events)
    for i, handler in pairs(self.event_handlers) do
        handler:handle(events, self.model)
    end
end

function Controller:open(filename)
    self.model:load_file(filename)
    self.view:handle_events()
end

function Controller:notify(events)
    if not events then
        return
    end

    if events[1] == "update_cursor_horizontal" then
        self.model:update_cursor_horizontal(events[2])
    elseif events[1] == "update_cursor_vertical" then
        self.model:update_cursor_vertical(events[2])
        --self.model:update_cursor_horizontal(0)
    elseif events[1] == "model_cursor_changed" then
        local curX, curY = self.model:get_cursor_pos()
        self.view:update_cursor(curX, curY)
    elseif events[1] == "rerender_all" then
        local y1, y2, x1 = self.model:get_boundaries()
        self.view:render(self.model:get_lines(), y1, y2, x1)
    elseif events[1] == "switch_mode" then
        self.model:switch_mode(events[2])
    elseif events[1] == "insert" then
        self.model:insert(events[2])
    elseif events[1] == "backspace" then
        self.model:backspace(events[2])
    elseif events[1] == "enter" then
        self.model:enter(events[2])
    else
        self:notify_handlers(events)
    end
end

return Controller