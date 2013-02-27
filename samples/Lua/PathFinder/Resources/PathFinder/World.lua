-- 参考实现 http://www.policyalmanac.org/games/aStarTutorial.htm
-- https://github.com/liyonghelpme/PathFinder

require "Class"
require "heapq"

World = class()

--[[
startPoint 搜索起点
endPoint 搜索终点
cellNum 地图cellNum*cellNum 大小   内部表示会在地图边界加上一圈墙体 因此实际大小是(cellNum+2)*(cellNum+2) 有效坐标范围1-cellNum 
cells 记录地图每个网格的状态 nil 空白区域 Wall 障碍物 Start 开始位置 End 结束位置 

coff 将x y 坐标转化成 单一的key的系数 x*coff+y = key 默认1000


w = World()
w:initCell()
w:putStart(x, y)
w:putEnd(x, y)
w:putWall(x, y)
path = w:search()

]]--
function World:ctor(cellNum, coff)
    self.startPoint = nil
    self.endPoint = nil
    self.cellNum = cellNum
    if coff == nil then
        self.coff = 1000
    else
        self.coff = coff
    end
end
function World:getKey(x, y)
    return x*self.coff+y
end
-- 初始化cells 
-- 每次生成路径都会修改cells的属性
-- 因此在下次搜索结束之前应该清空cells状态 
-- g 从start位置到当前的位置的开销
-- h 启发从当前位置到目标位置的开销
-- f = g+h
function World:initCell()
    self.cells = {}
    for x = 1, self.cellNum, 1 do
        for y = 1, self.cellNum, 1 do
            self.cells[x*self.coff+y] = {state=nil, fScore=nil, gScore=nil, hScore=nil, parent=nil}
        end
    end
    for i = 0, self.cellNum+1, 1 do
        self.cells[0*self.coff+i] = {state=nil, fScore=nil, gScore=nil, hScore=nil, parent=nil}
        self.cells[i*self.coff+0] = {state=nil, fScore=nil, gScore=nil, hScore=nil, parent=nil}
        self.cells[(self.cellNum+1)*self.coff+i] = {state=nil, fScore=nil, gScore=nil, hScore=nil, parent=nil}
        self.cells[i*self.coff+(self.cellNum+1)] = {state=nil, fScore=nil, gScore=nil, hScore=nil, parent=nil}
    end
end
function World:putStart(x, y)
    self.startPoint = {x, y}
    self.cells[self:getKey(x, y)]['state'] = 'Start'
end
function World:putEnd(x, y)
    self.endPoint = {x, y}
    self.cells[self:getKey(x, y)]['state'] = 'End'
end
function World:putWall(x, y)
    print("putWall", x, y)
    self.cells[self:getKey(x, y)]['state'] = 'Wall'
end
-- 临边10 斜边 14
function World:calcG(x, y)
    local data = self.cells[self:getKey(x, y)]
    local parent = data['parent']
    local difX = math.abs(math.floor(parent/self.coff)-x)
    local difY = math.abs(parent%self.coff-y)
    local dist = 10
    if difX > 0 and difY > 0 then
        dist = 14
    end
    data['gScore'] = self.cells[parent]['gScore']+dist
end
function World:calcH(x, y)
    local data = self.cells[self:getKey(x, y)]
    data['hScore'] = (math.abs(self.endPoint[1]-x)+math.abs(self.endPoint[2]-y))*10
end
function World:calcF(x, y)
    local data = self.cells[self:getKey(x, y)]
    data['fScore'] = data['gScore']+data['hScore']
end
function World:pushQueue(x, y)
    local fScore = self.cells[self:getKey(x, y)]['fScore']
    heapq.heappush(self.openList, fScore)
    local fDict = self.pqDict[fScore]
    if fDict == nil then
        fDict = {}
    end
    table.insert(fDict, self:getKey(x, y))
    self.pqDict[fScore] = fDict
end

function World:checkNeibor(x, y)
    local neibors = {
        {x-1, y-1},
        {x, y-1},
        {x+1, y-1},
        {x+1, y},
        {x+1, y+1},
        {x, y+1},
        {x-1, y+1},
        {x-1, y}
    }

    for n, nv in ipairs(neibors) do
        local key = self:getKey(nv[1], nv[2]) 
        if self.cells[key]['state'] ~= 'Wall' and self.closedList[key] == nil then
            -- 检测是否已经在 openList 里面了
            local nS = self.cells[key]['fScore']
            local inOpen = false
            if nS ~= nil then
                local newPossible = self.pqDict[nS]
                if newPossible ~= nil then
                    for k, v in ipairs(newPossible) do
                        if v == key then
                            inOpen = true
                            break
                        end
                    end
                end
            end
            -- 已经在开放列表里面 检查是否更新
            if inOpen then
                local oldParent = self.cells[key]['parent']
                local oldGScore = self.cells[key]['gScore']
                local oldHScore = self.cells[key]['hScore']
                local oldFScore = self.cells[key]['fScore']

                self.cells[key]['parent'] = self:getKey(x, y)
                self:calcG(nv[1], nv[2])

                -- 新路径比原路径花费高 gScore  
                if self.cells[key]['gScore'] > oldGScore then
                    self.cells[key]['parent'] = oldParent
                    self.cells[key]['gScore'] = oldGScore
                    self.cells[key]['hScore'] = oldHScore
                    self.cells[key]['fScore'] = oldFScore
                else -- 删除旧的自己的优先级队列 重新压入优先级队列
                    self:calcH(nv[1], nv[2])
                    self:calcF(nv[1], nv[2])

                    local oldPossible = self.pqDict[oldFScore]
                    for k, v in ipairs(oldPossible) do
                        if v == key then
                            table.remove(oldPossible, k)
                            break
                        end
                    end
                    self:pushQueue(nv[1], nv[2])
                end
                    
            else --不在开放列表中 直接插入
                self.cells[key]['parent'] = self:getKey(x, y)
                self:calcG(nv[1], nv[2])
                self:calcH(nv[1], nv[2])
                self:calcF(nv[1], nv[2])

                self:pushQueue(nv[1], nv[2])
            end
        end
    end
    self.closedList[self:getKey(x, y)] = true
end
function World:getXY(pos)
    return math.floor(pos/self.coff), pos%self.coff
end


function World:search()
    self.openList = {}
    self.pqDict = {}
    self.closedList = {}

    self.cells[self:getKey(self.startPoint[1], self.startPoint[2])]['gScore'] = 0
    self:calcH(self.startPoint[1], self.startPoint[2])
    self:calcF(self.startPoint[1], self.startPoint[2])
    self:pushQueue(self.startPoint[1], self.startPoint[2])

    --获取openList 中第一个fScore
    while #(self.openList) > 0 do
        local fScore = heapq.heappop(self.openList)
        local possible = self.pqDict[fScore]
        if #(possible) > 0 then
            local point = table.remove(possible) --这里可以加入随机性 在多个可能的点中选择一个点 用于改善路径的效果 
            local x, y = self:getXY(point)
            if x == self.endPoint[1] and y == self.endPoint[2] then
                break
            end
            self:checkNeibor(x, y)
        end
    end

    local path = {self.endPoint}
    local parent = self.cells[self:getKey(self.endPoint[1], self.endPoint[2])]['parent']
    while parent ~= nil do
        local x, y = self:getXY(parent)
        table.insert(path, {x, y})
        if x == self.startPoint[1] and y == self.startPoint[2] then
        
        else
            self.cells[parent]['state'] = 'Path'
        end
        local x, y = self:getXY(parent)
        table.insert(path, {x, y})
        parent = self.cells[parent]["parent"]
    end
    
    local temp = {}
    for i = #path, 0, 1 do
        table.insert(path[i])
    end

    return temp
end

function World:printCell()
    print("cur Board")
    local d
    for j = 0, self.cellNum+1, 1 do 
        for i = 0, self.cellNum+1, 1 do
            d = self.cells[self:getKey(i, j)]
            if d['state'] == nil then
                d['state'] = 'None'
            end
            io.write(string.format("%4s ", d['state'])) 
        end
        print() 
        for i = 0, self.cellNum+1, 1 do
            d = self.cells[self:getKey(i, j)]
            if d['gScore'] == nil then
                d['gScore'] = 0
            end
            io.write(string.format("%4d ", d['gScore'])) 
        end
        print()
        for i = 0, self.cellNum+1, 1 do
            d = self.cells[self:getKey(i, j)]
            if d['hScore'] == nil then
                d['hScore'] = 0
            end
            io.write(string.format("%4d ", d['hScore'])) 
        end
        print()

        for i = 0, self.cellNum+1, 1 do
            d = self.cells[self:getKey(i, j)]
            if d['fScore'] == nil then
                d['fScore'] = 0
            end
            io.write(string.format("%4d ", d['fScore'])) 
        end
        print()

        for i = 0, self.cellNum+1, 1 do
            d = self.cells[self:getKey(i, j)]
            if d['parent'] == nil then
                io.write(string.format("%4s ", "Pare"))
            else
                io.write(string.format("%d,%d ", self:getXY(d['parent']))) 
            end
        end
        print()
    end
end


--[[Test Case
MAP = {
0, 0, 0, 0, 0, 0, 0,  
0, 0, 0, 1, 0, 0, 0,  
0, 2, 0, 1, 0, 3, 0,  
0, 0, 0, 1, 0, 0, 0,  
0, 0, 0, 0, 0, 0, 0,  
0, 0, 0, 0, 0, 0, 0,  
0, 0, 0, 0, 0, 0, 0,  
}

world = World.new(7)
world:initCell()
for k, v in ipairs(MAP) do
    if v == 1 then
        world:putWall((k-1)%world.cellNum+1, math.floor((k-1)/world.cellNum)+1)
    elseif v == 2 then
        world:putStart((k-1)%world.cellNum+1, math.floor((k-1)/world.cellNum)+1)
    elseif v == 3 then
        world:putEnd((k-1)%world.cellNum+1, math.floor((k-1)/world.cellNum)+1)
    end
end
world:search()
world:printCell()
]]--

