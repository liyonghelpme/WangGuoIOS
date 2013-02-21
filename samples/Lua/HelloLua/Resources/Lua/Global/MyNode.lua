require "Global.Class"
MyNode = class()
function MyNode:ctor()
    self.ins = 0    
    self.bg = nil
end
function MyNode:init()
    self.bg.myNode = self
    local function onEnterOrExit(tag)
        if tag == "enter" then
            self:enterScene()
        elseif tag == "exit" then
            self:exitScene()
        end
    end
    self.bg:registerScriptHandler(onEnterOrExit)
end



function MyNode:removeSelf()
    self.bg:removeFromParentAndCleanup(true)
end

function MyNode:setZord(z)
end

function MyNode:enterScene()
    self.ins = 1
end

function MyNode:setPos(p)
    -- print(p.x, p.y)
    self.bg:setPosition(p)
end

function MyNode:getPos()
    return self.bg:getPosition()
end

function MyNode:exitScene()
    self.ins = 0
end

function MyNode:addChild(child)
    self:addChildZ(child, 0)
end

function MyNode:addChildZ(child, z)
    self.bg:addChild(child.bg, z)
end

function MyNode:removeChild(child)
end




