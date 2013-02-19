-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local cclog = function(...)
        print(string.format(...))
    end
    print("hello world")
    require "Global.INCLUDE"
    require "views.CastleScene"
    global.director:runWithScene(CastleScene.new())
end

xpcall(main, __G__TRACKBACK__)
