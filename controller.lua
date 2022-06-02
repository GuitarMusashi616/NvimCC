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
    for i, handler in pairs(self.handlers) do
        handler.handle(events)
    end
end

function Controller:open(filename)
    self.model:load_file(filename)
    self.view:render(self.model.lines)

    self.view:handle_events()
end

function Controller:notify(events)
    if #events <= 2 then
        return
    end

    if events[1] == "update_cursor_horizontal" then
        self.model:update_cursor_horizontal(events[2])
    elseif events[1] == "update_cursor_vertical" then
        self.model:update_cursor_vertical(events[2])
    elseif events[1] == "model_cursor_changed" then
        self.view:update_cursor(self.model.curX, self.model.curY)
    else
        self.notify_handlers(events)
    end
end