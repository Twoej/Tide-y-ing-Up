local M = {}

local ScreenScroll = require("src.screenScroll")
local Water = require("src.water")
local Relic = require("src.relic")
local EtherealObject = require("src.etherealObject")

local boatState = {}

local successTime = nil
local relicSpawned = false
local relicPos = {["x"] = 0, ["y"] = 0}

function M.init()
    boatState = { ["x"] = 402, ["y"] = 195, ["rotation"] = 0, ["sx"] = 116, ["sy"] = 13, ["w"] = 56, ["h"] = 36, ["alpha"] = 1 }
end

function M.update(dt)
    local totalWaterHeightLeft = 0
    local avgWaterHeightLeft
    local totalWaterHeightRight = 0
    local avgWaterHeightRight = 0
    local avgWaterHeight
    for x = boatState["x"] - 20 + 28, boatState["x"] - 1 + 28 do
        totalWaterHeightLeft += Water.getPoint(x)
    end
    avgWaterHeightLeft = totalWaterHeightLeft / 20
    for x = boatState["x"] + 1 + 28, boatState["x"] + 20 + 28 do
        totalWaterHeightRight += Water.getPoint(x)
    end
    avgWaterHeightRight = totalWaterHeightRight / 20
    boatState["rotation"] = (avgWaterHeightRight - avgWaterHeightLeft) / 20
    if (boatState["rotation"] > 1.2) then
        boatState["rotation"] = 1.2
    end
    if (boatState["rotation"] < -1.2) then
        boatState["rotation"] = -1.2
    end
    local speed = (avgWaterHeightRight - avgWaterHeightLeft) * dt * 2
    boatState["x"] += speed
    boatState["x"] += ((402 - boatState["x"]) * dt) / 20
    if (boatState["x"] > 580) then
        boatState["x"] = 580
    end
    if (boatState["x"] < 195) then
        boatState["x"] = 195
    end
    avgWaterHeight = (avgWaterHeightLeft + avgWaterHeightRight) / 2
    boatState["y"] = avgWaterHeight + 68
    if (speed > 1.5 or speed < -1.5 and successTime == nil and boatState["x"] < 500 and boatState["x"] > 240) then
        successTime = Time
    end
    if (successTime ~= nil and not relicSpawned) then
        if (Time - successTime > 0.15) then
            Relic.moveRelic(5, boatState["x"], boatState["y"])
            relicPos["x"] = boatState["x"]
            relicPos["y"] = boatState["y"]
            Relic.setVisible(5, true)
            relicSpawned = true
        end
    end
    if (relicSpawned) then
        if (relicPos["x"] > 203) then
            relicPos["x"] -= 300 * dt
        end
        if (relicPos["y"] > 125) then
            relicPos["y"] -= 150 * dt
        end
        Relic.moveRelic(5, relicPos["x"], relicPos["y"])
    end
    EtherealObject.move(6, boatState["x"] + 6, boatState["y"] + 3)
    boatState["alpha"] = EtherealObject.getAlpha(6)
    Relic.moveRelic(10, boatState["x"] + 20, boatState["y"] + 10)
end

function M.draw()
    ScreenScroll.sspr_ex(boatState["sx"], boatState["sy"], boatState["w"], boatState["h"], boatState["x"], boatState["y"], boatState["w"], boatState["h"], false, false, boatState["rotation"], gfx.COLOR_TRUE_WHITE, boatState["alpha"])
end

return M
