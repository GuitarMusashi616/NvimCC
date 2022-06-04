local class = require "lib/class"
local util = require "lib/util"

local Model = class()

function Model:__init(controller)
    self.controller = controller
    self.curX, self.curY = 1, 1
    self.w, self.h = term.getSize()
    self.x, self.y = 1, 1
    self.NUM_VERTICAL = self.h - 1
    self.NUM_HORIZONTAL = self.w - 1
    
    self.insert_mode = false
    
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
    self.controller:notify({"rerender_all"})
end

function Model:scroll(n)
   self.y = util.clamp(self.y + n, 1, #self.lines - self.NUM_VERTICAL)
   self.controller:notify({"rerender_all"})
end

function Model:pan(n)
    local limit = 100
    self.x = util.clamp(self.x + n, 1, limit)
    self.controller:notify({"rerender_all"})
end

function Model:update_cursor_horizontal(n)
    if n > 0 and self.curX == self.w then
        self:pan(n)
    elseif n < 0 and self.curX == 1 then
        self:pan(n)
    else
        self.curX = util.clamp(self.curX + n, 1, self.w)
        self.controller:notify({"model_cursor_changed"})
    end
end

function Model:update_cursor_vertical(n)
    if n > 0 and self.curY == self.h then
        self:scroll(n)
    elseif n < 0 and self.curY == 1 and self.y>1 then
        self:scroll(n)
    else
        self.curY = util.clamp(self.curY + n, 1, self.h)
        self.controller:notify({"model_cursor_changed"})
    end
end

function Model:reset_pan()
    self.x = 1
    self.curX = 1
    self.controller:notify{"model_cursor_changed"}
end

function Model:get_boundaries()
    return self.y, self.y + self.NUM_VERTICAL, self.x
end

function Model:get_line()
    local x,y = self:get_line_pos()
    return self.lines[y]
end

function Model:get_lines()
    return self.lines
end

function Model:switch_mode(mode)
    if mode == "insert" then
        self.insert_mode = true
    elseif mode == "normal" then
        self.insert_mode = false
    else
        error(tostring(mode) .. " is not a valid mode", 0)
    end
end

function Model:insert(text)
    local x,y = self:get_line_pos()
    local line = self.lines[y]
    
    self.lines[y] = line:sub(1,x-1) .. text .. line:sub(x)    
    
    self:update_cursor_horizontal(#text)
    self.controller:notify{"rerender_all"}           
end

function Model:backspace(n)
    assert(n<=1, tostring(n).." greater than 1 not yet supported")
    local x,y = self:get_line_pos()
    local line = self.lines[y]
    if x > 1 and line:sub(x-1,x-1) == "\t" then
        n = 4
    end
    
    self.lines[y] = line:sub(1,x-1-n)..line:sub(x)
    self:update_cursor_horizontal(-1*n)
    self.controller:notify{"rerender_all"}
end

function Model:enter(n)
    local x,y = self:get_line_pos()
    local line = self.lines[y]
    
    table.insert(self.lines, y+1, line:sub(x))
    self.lines[y] = line:sub(1,x-1)
    
    if self.x > 1 then
        self:pan(1-self.x)
    end
    self.curX = 1
    
    self:update_cursor_vertical(1)
    self.controller:notify{"rerender_all"}
end

function Model:get_line_pos()
    local x = self.x + self.curX - 1
    local y = self.y + self.curY - 1
    return x,y
end

function Model:get_cursor_pos()
    return self.curX, self.curY
end

function Model:get_mode()
    if self.insert_mode then
        return "insert"
    else
        return "normal"
    end
end

return Model