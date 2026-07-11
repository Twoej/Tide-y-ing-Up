local M = {}

local MouseHandler = require("src.mouseHandler")
local ScreenScroll = require("src.screenScroll")

local currentMoons = {}

local recursionfix = {}

local initialMousePos = { 0, 0 }
local initialMoonPos = { 0, 0 }
local initialScreenPos = { 0, 0 }

local lightAlpha = 0

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
    MouseHandler.addToClickable(20, 20, 64, 64, MouseHandler.getClickableCount() + 1, currentMoons[1][7], recursionfix.clicked)
    M.addMoon(100, 20, 240, 16, 32, 32, AssignId())
    MouseHandler.addToClickable(100, 20, 32, 32, MouseHandler.getClickableCount() + 1, currentMoons[2][7],
        recursionfix.clicked)
    M.addMoon(180, 20, 272, 0, 64, 64, AssignId())
    MouseHandler.addToClickable(180, 20, 64, 64, MouseHandler.getClickableCount() + 1, currentMoons[3][7], recursionfix.clicked)
end

local function updateAlpha(alpha, dt)
    local timeMod4 = Time % 4
    if (timeMod4 < 2) then
        alpha += dt / 8
    else
        alpha -= dt / 8
    end
    if (alpha < 0) then
        alpha = 0
    end
    return alpha
end

function M.draw(dt)
    lightAlpha = updateAlpha(lightAlpha, dt)
    for i, moon in ipairs(currentMoons) do
        if i == 3 then
            ScreenScroll.tri_fill(currentMoons[3][1] - 50 + 32, currentMoons[3][2] + 90 + 32, currentMoons[3][1] + 32, currentMoons[3][2] + 13, currentMoons[3][1] + 50 + 32, currentMoons[3][2] + 90 + 32, 11, 0.3 + lightAlpha)
        end
        ScreenScroll.sspr(moon[3], moon[4], moon[5], moon[6], moon[1], moon[2], 1)
    end
end

function M.getPos(n)
    return currentMoons[n][1], currentMoons[n][2]
end

return M
