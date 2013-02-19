require "Global.Class"
MyNode = class()
function MyNode:ctor()
    self.ins = 0    
    self.bg = nil
end
function MyNode:init()
    self.bg.myNode = self
    self.bg:registerScriptHandler(self.onEnterOrExit)
end
function MyNode:onEnterOrExit(tag)
    if tag == kCCNodeOnEnter then
        self:enterScene()
    elseif tag == kCCNodeOnExit then
        self:exitScene()
    end
end




function MyNode:removeSelf()
    self.bg:removeFromParentAndCleanup(true)
end

function MyNode:setZord(z)
end

function MyNode:enterScene()
    self.ins = 1
    print("enterScene", self)
end

function MyNode:setPos(p)
end

function MyNode:getPos()
end

function MyNode:exitScene()
    self.ins = 0
    print("exitScene", self)
end

function MyNode:addChild(child)
    self:addChildZ(child, 0)
end

function MyNode:addChildZ(child, z)
    self.bg:addChild(child.bg, z)
end

function MyNode:removeChild(child)
end




