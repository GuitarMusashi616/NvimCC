
local Controller = require "controller"
local Model = require "model"
local View = require "view"
local HJKL = require "HJKL"

local controller = Controller()
local model = Model(controller)
local view = View(controller)
local hjkl = HJKL(controller)

controller:set_model(model)
controller:set_view(view)

controller:add_event_listener(hjkl)

controller:open(...)
