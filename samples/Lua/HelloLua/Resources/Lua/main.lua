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
    local function haha(code, data)
        print("haha")
        print(code..","..data)
    end
    MyHttpClient:doPost("http://192.168.3.103:8100/login", haha, "papayaId=1000&papayaName=中国")
    global.director:runWithScene(CastleScene.new())
end

xpcall(main, __G__TRACKBACK__)
