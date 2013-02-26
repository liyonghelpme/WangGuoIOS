require "Global.MyNode"
require "views.CastlePage"

CastleScene = class(Scene)
function CastleScene:ctor()
    self:initData()
    self.mc = CastlePage.new(self)
    self:addChild(self.mc)
end
function CastleScene:initData()
    self.curBuild = nil

end

function CastleScene:enterScene()
    global.msgCenter:registerCallback(INITDATA_OVER, self)
end
function CastleScene:receiveMsg(param)
    local msid = param[1]
    if msid == INITDATA_OVER then
        self.mc:initDataOver()
    end
end

