require "Global.INCLUDE"
require "busiViews.Sky"
require "util.Util"
require "data.Static"
require "views.StandardTouchHandler"
require "busiViews.BuildLand"
require "busiViews.BuildLayer"

CastlePage = class(MyNode)
function CastlePage:ctor(scene)
    self.scene = scene
    self.bg = CCLayer:create()
    self:init()
    
    self.bg:setAnchorPoint(ccp(0, 0))
    self.bg:setContentSize(CCSizeMake(getParam("MapWidth"), getParam("MapHeight")))

    --self.bg:setPosition(ccp(global.director.disSize[1]/2-getParam("MapWidth")/2, global.director.disSize[2]/2-getParam("MapHeight")/2))

    local sky = Sky.new()
    self:addChildZ(sky, -2)

    self:addChild(BuildLand.new())
    self.buildLayer = BuildLayer.new()
    self:addChild(self.buildLayer)

    self.touchDelegate = StandardTouchHandler.new()
    self.touchDelegate:setBg(self.bg)

    local function onTouches(eventType, touches)

        if eventType == "began" then
            print("touch Page")
            self:touchBegan(touches)
        elseif eventType == "moved" then
            self:touchMoved(touches)
        elseif eventType == "ended" then
            self:touchEnded(touches)
        end
    end
    self.bg:setTouchEnabled(true)
    self.bg:registerScriptTouchHandler(onTouches, true)
end
function CastlePage:touchBegan(touches)
    self.touchDelegate:tBegan(self.bg, touches)
end

function CastlePage:touchMoved(touches)
    self.touchDelegate:tMoved(self.bg, touches)
end

function CastlePage:touchEnded(touches)
    self.touchDelegate:tEnded(self.bg, touches)
end
