local M = {}

local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local Relic = require("src.relic")

local objects = {}

local function addObject(x, y, sx, sy, w, h, alpha, visible, relic, buriedRelic)
    local t = { x, y, sx, sy, w, h, ["alpha"] = alpha, ["visible"] = visible, ["relic"] = relic, ["buriedRelic"] = buriedRelic}
    table.insert(objects, t)
end

function M.init()
    addObject(87, 87, 402, 1, 30, 49, 1, true, 7, 13)
    addObject(157, 90, 444, 7, 46, 34, 1, true, 9, 19)
    addObject(301, 265, 368, 0, 24, 24, 1, true, 6, 18)
    addObject(579, 265, 532, 7, 40, 23, 1, true, 8, nil)
    addObject(566, 270, 402, 1, 30, 49, 1, true, nil, 17)
    addObject(402, 195, 584, 424, 44, 30, 1, true, 10, nil)
    addObject(30, 10, 584, 424, 40, 40, 1, true, 11, nil)
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
        if (obj["buriedRelic"] ~= nil) then
            Relic.setMagnetic(obj["buriedRelic"], true)
        end
        ::continue::
    end
    return litObjects
end

function M.update(dt)
    local xMoon, yMoon = Moon.getPos(3)
    local litObjects = inLight(xMoon - 50 + 32, yMoon + 90 + 32, xMoon + 50 + 32)
    for i = 1, #litObjects do
        if (not sfx.is_playing("disappear") and objects[litObjects[i]]["alpha"] == 1) then
            sfx.play_ex("disappear", 0.3, 1, 0)
        end
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
            if (obj["alpha"] > 1) then
                obj["alpha"] = 1
            end
        else
            if (obj["relic"] ~= nil) then
                Relic.setVisible(obj["relic"], false)
            end
            if (obj["buriedRelic"] ~= nil) then
                Relic.setMagnetic(obj["buriedRelic"], false)
            end
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

function M.getAlpha(n)
    return objects[n]["alpha"]
end

function M.move(n, x, y)
    objects[n][1] = x
    objects[n][2] = y
end

return M
