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
    addToRelicList(150, 50, 64, 0, false, 5, 16, 16, AssignId(), false, true)
    addToRelicList(170, 50, 64, 0, false, 5, 16, 16, AssignId(), false, true)
    addToRelicList(190, 50, 64, 0, false, 5, 16, 16, AssignId(), false, true)
    addToRelicList(210, 50, 64, 0, false, 5, 16, 16, AssignId(), false, true)
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
