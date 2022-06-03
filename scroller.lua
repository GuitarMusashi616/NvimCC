local class = require "lib/class"

local Scroller = class()

function Scroller:__init(...)
    self.list = {...}   
end

function Scroller:test()
    for i,v in pairs(self.list) do
        print(i, v)
    end
end

function main()
    local scroller = Scroller('a', 'b', 'c', 'd')
    local scroller2 = Scroller('d', 'f', 't', 'e')
    scroller:test()
    scroller2:test()
end

main()