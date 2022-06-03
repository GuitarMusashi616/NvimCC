
local Controller = require "controller"
local Model = require "model"
local View = require "view"
local HJKL = require "hjkl"

local controller = Controller()
local model = Model(controller)
local view = View(controller)
local hjkl = HJKL(controller)

controller:set_model(model)
controller:set_view(view)

controller:add_event_handler(hjkl)

controller:open(...)
