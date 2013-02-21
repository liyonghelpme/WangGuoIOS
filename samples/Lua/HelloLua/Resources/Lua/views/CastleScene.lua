require "Global.MyNode"
require "views.CastlePage"

CastleScene = class(Scene)
function CastleScene:ctor()
    self.mc = CastlePage.new(self)
    self:addChild(self.mc)
end

