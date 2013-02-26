require "data.constant"
require "Global.GlobalController"
require "Global.Director"
require "Global.HttpController"
require "Global.User"
require "Global.MessageCenter"

global = GlobalController.new()
global.httpController = HttpController.new()
global.msgCenter = MessageCenter.new()
global.director = Director.new()
global.json = require "Global.JSON"
global.user = User.new()

