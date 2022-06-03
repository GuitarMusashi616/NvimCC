local class = require "lib/class"

local Model = class()

function Model:__init(controller)
    self.controller = controller
    self.curX, self.curY = 1, 1
    self.w, self.h = term.getSize()
    self.y = 1
    self.NUM_LINES = self.h - 1
    self.lines = {}
end

function Model:load_file(filename)
    if not fs.exists(filename) then
        error(tostring(filename) .. " does not exist", 0)
    end
    local h = io.open(filename, "r")
    if not h then
        error(tostring(filename) .. " could not be opened", 0)
    end
    local lines = {}
    for line in h:lines() do
        table.insert(lines, line)
    end
    self.lines = lines
end

function Model:scroll(n)
   self.y = math.min(math.max(1, self.y + n), #self.lines - self.NUM_LINES)
   self.controller:notify({"model_scrolled", self.y, self.y + self.NUM_LINES})
end

function Model:update_cursor_horizontal(n)
    self.curX = math.max(1, math.min(self.curX + n, self.w))
    self.controller:notify({"model_cursor_changed"})
end

function Model:update_cursor_vertical(n)
    if n > 0 and self.curY == self.h then
        self:scroll(n)
    elseif n < 0 and self.curY == 1 then
        self:scroll(n)
    else
        self.curY = math.max(1, math.min(self.curY + n, self.h))
        self.controller:notify({"model_cursor_changed"})
    end
end

return Model