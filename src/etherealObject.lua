local M = {}

local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local Relic = require("src.relic")

local objects = {}

local function addObject(x, y, sx, sy, w, h, alpha, visible, relic)
    local t = { x, y, sx, sy, w, h, ["alpha"] = alpha, ["visible"] = visible, ["relic"] = relic }
    table.insert(objects, t)
end

function M.init()
    addObject(30, 100, 336, 0, 32, 32, 1, true, 1)
    addObject(62, 100, 336, 0, 32, 32, 1, true, nil)
end

local function inLight(x1, y1, x3)
    local litObjects = {}
    for i, obj in ipairs(objects) do
        local dxl = obj[1] - x1
        local dxr = x3 - (obj[1] + obj[5])
        local maxHeightl = dxl * math.tan(42)
        local maxHeightr = dxr * math.tan(42)
        if (obj[2] + obj[6]) > y1 then goto continue end
        if (dxl < 0) then goto continue end
        if (dxr < 0) then goto continue end
        if maxHeightl < (y1 - obj[2]) then goto continue end
        if maxHeightr < (y1 - obj[2]) then goto continue end
        table.insert(litObjects, i)
        if (obj["relic"] ~= nil) then
            Relic.setVisible(obj["relic"], true)
        end
        ::continue::
    end
    return litObjects
end

function M.update(dt)
    local xMoon, yMoon = Moon.getPos(3)
    local litObjects = inLight(xMoon - 50 + 32, yMoon + 90 + 32, xMoon + 50 + 32)
    for i = 1, #litObjects do
        objects[litObjects[i]]["alpha"] -= dt
        if objects[litObjects[i]]["alpha"] < 0 then
            objects[litObjects[i]]["alpha"] = 0
        end
    end
    for i, obj in ipairs(objects) do
        for _, objIdx in ipairs(litObjects) do
            if objIdx == i then goto continue end
        end
        if (obj["alpha"] < 1) then
            obj["alpha"] += (dt * obj["alpha"]) + (dt / 20)
        elseif(obj["relic"] ~= nil) then
            Relic.setVisible(obj["relic"], false)
        end
        ::continue::
    end
end

function M.draw()
    for _, obj in ipairs(objects) do
        if (obj["visible"]) then
            ScreenScroll.sspr(obj[3], obj[4], obj[5], obj[6], obj[1], obj[2], obj["alpha"], false)
        end
    end
end



return M
