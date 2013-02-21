require "Global.Class"
require "Global.MyNode"

Director = class()
Scene = class(MyNode)
function Scene:ctor()
    self.bg = CCScene:create()
    self:init()
end

function Director:ctor()
    self.stack = {}
    self.disSize = {960, 640}
    self.sceneStack = {}
    self.curScene = nil
    print("init Director", self.curScene, CCDirector:sharedDirector():getVisibleSize().width)
end

function Director:pushView(view, dark, autoPop)
end
-- 弹出场景 去掉节点
function Director:replaceScene(view)
    self.stack = {}
    CCDirector:sharedDirector():replaceScene(self.curScene.bg)
end

function Director:pushScene(view)
    table.insert(self.sceneStack, self.curScene)
    self.curScene = view
    CCDirector:sharedDirector():pushScene(self.curScene.bg)
end
function Director:runWithScene(view)
    self.curScene = view
    CCDirector:sharedDirector():runWithScene(self.curScene.bg)
end

function Director:popScene()
    self.curScene = table.remove(self.sceneStack)
    CCDirector:sharedDirector():popScene()
end

function Director:popView()
end

