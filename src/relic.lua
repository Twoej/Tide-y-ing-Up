local M = {}

local ScreenScroll = require("src.screenScroll")
local MouseHandler = require("src.mouseHandler")

local relicList = {}

local function addToRelicList(x, y, sx, sy, ssprite, spridx, w, h, id, found, visible)
    local t = {
        x,
        y,
        sx,
        sy,
        ["ssprite"] = ssprite,
        id,
        ["found"] = found,
        ["visible"] = visible,
        w,
        h,
        spridx,
        ["fading"] = false,
        ["alpha"] = 1
    }
    table.insert(relicList, t)
end

local function clicked(n)
    for i, relic in ipairs(relicList) do
        if (relic[5] == n) then
            relicList[i]["found"] = true
            relicList[i]["fading"] = true
            MouseHandler.removeFromClickable(n)
            return
        end
    end
end

function M.init()
    addToRelicList(50, 50, 64, 0, false, 5, 16, 16, AssignId(), false, true)
    addToRelicList(80, 50, 80, 0, false, 6, 16, 16, AssignId(), false, true)
    addToRelicList(110, 50, 96, 0, false, 7, 16, 16, AssignId(), false, true)
    addToRelicList(150, 50, 64, 16, false, 45, 16, 16, AssignId(), false, true)
    addToRelicList(170, 50, 80, 16, false, 46, 16, 16, AssignId(), false, true)
    addToRelicList(190, 50, 96, 16, false, 47, 16, 16, AssignId(), false, true)
    addToRelicList(210, 50, 64, 32, false, 85, 16, 16, AssignId(), false, true)
    addToRelicList(230, 50, 80, 32, false, 86, 16, 16, AssignId(), false, true)
    addToRelicList(250, 50, 96, 32, false, 87, 16, 16, AssignId(), false, true)
    addToRelicList(270, 50, 64, 48, false, 125, 16, 16, AssignId(), false, true)
    addToRelicList(290, 50, 80, 48, false, 126, 16, 16, AssignId(), false, true)
    addToRelicList(310, 50, 96, 48, false, 127, 16, 16, AssignId(), false, true)
    addToRelicList(330, 50, 176, 0, true, 0, 24, 24, AssignId(), false, true)
    addToRelicList(350, 50, 200, 0, true, 0, 24, 24, AssignId(), false, true)
    addToRelicList(370, 50, 176, 24, true, 46, 24, 24, AssignId(), false, true)
    addToRelicList(390, 50, 200, 24, true, 47, 24, 24, AssignId(), false, true)
    addToRelicList(410, 50, 224, 0, false, 15, 16, 16, AssignId(), false, true)
    addToRelicList(430, 50, 240, 0, false, 16, 16, 16, AssignId(), false, true)
    addToRelicList(450, 50, 224, 16, false, 55, 16, 16, AssignId(), false, true)
    addToRelicList(470, 50, 224, 32, false, 95, 16, 16, AssignId(), false, true)

    for _, relic in ipairs(relicList) do
        if (relic["visible"]) then
            MouseHandler.addToClickable(relic[1], relic[2], relic[6], relic[7], MouseHandler.getClickableCount() + 1,
                relic[5],
                clicked)
        end
    end
end

function M.update(dt)
    for _, relic in ipairs(relicList) do
        if (relic["fading"]) then
            relic["alpha"] -= dt
            if (relic["alpha"] <= 0) then
                relic["visible"] = false
                relic["fading"] = false
            end
        end
    end
end

function M.draw()
    for _, relic in ipairs(relicList) do
        if (relic["visible"]) then
            if (relic["ssprite"]) then
                ScreenScroll.sspr(relic[3], relic[4], relic[6], relic[7], relic[1], relic[2], relic["alpha"])
            else
                ScreenScroll.spr(relic[8], relic[1], relic[2], relic["alpha"])
            end
        end
    end
end

function M.getRelicFromList(n)
    return relicList[n]
end

function M.getRelicListLength()
    local count = 0
    for _, relic in ipairs(relicList) do
        count += 1
    end
    return count
end

return M
