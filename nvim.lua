local Controller = require "controller"
local Model = require "model"
local View = require "view"
local HJKL = require "HJKL"
local InsertMode = require "insert_mode"

local controller = Controller()
local model = Model(controller)
local view = View(controller)

local hjkl = HJKL(controller)
local insertMode = InsertMode(controller)

local tArgs = {...}
if #tArgs ~= 1 then
    error("Usage: nvim <filename>", 0)
end

controller:set_model(model)
controller:set_view(view)

controller:add_event_handler(hjkl)
controller:add_event_handler(insertMode)

controller:open(tArgs[1])