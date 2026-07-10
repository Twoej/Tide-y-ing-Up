local M = {}

local MouseHandler = require("src.mouseHandler")
local ScreenScroll = require("src.screenScroll")

local currentMoons = {}

local recursionfix = {}

local initialMousePos = { 0, 0 }
local initialMoonPos = { 0, 0 }
local initialScreenPos = { 0, 0 }

local function holding(n)
    local xMouse, yMouse = input.mouse()
    local xScreen, yScreen = ScreenScroll.getScreenLocation()
    currentMoons[n][1] = initialMoonPos[1] + xMouse - initialMousePos[1] + xScreen - initialScreenPos[1]
    currentMoons[n][2] = initialMoonPos[2] + yMouse - initialMousePos[2] + yScreen - initialScreenPos[2]
end

local function dropped(n)
    MouseHandler.removeFromClickable(n)
    MouseHandler.addToClickable(currentMoons[n][1], currentMoons[n][2], currentMoons[n][5], currentMoons[n][6],
        MouseHandler.getClickableCount() + 1,
        n, recursionfix.clicked)
end

function recursionfix.clicked(n)
    initialMousePos[1], initialMousePos[2] = input.mouse()
    initialMoonPos[1], initialMoonPos[2] = currentMoons[n][1], currentMoons[n][2]
    initialScreenPos[1], initialScreenPos[2] = ScreenScroll.getScreenLocation()
    MouseHandler.currentlyHeld(n, dropped, holding)
end

function M.addMoon(x, y, sx, sy, w, h, id)
    local obj = { x, y, sx, sy, w, h, id }
    table.insert(currentMoons, id, obj)
end

function M.init()
    M.addMoon(20, 20, 0, 0, 64, 64, AssignId())
    MouseHandler.addToClickable(20, 20, 64, 64, 1, MouseHandler.getClickableCount() + 1, recursionfix.clicked)
end

function M.draw()
    for _, moon in ipairs(currentMoons) do
        ScreenScroll.sspr(moon[3], moon[4], moon[5], moon[6], moon[1], moon[2], 1)
    end
end

function M.getPos(n)
    return currentMoons[n][1], currentMoons[n][2]
end

return M
