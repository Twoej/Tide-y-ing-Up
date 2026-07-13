local M = {}

local MouseHandler = require("src.mouseHandler")
local ScreenScroll = require("src.screenScroll")
local EtherealObject = {}
local Relic = {}

local currentMoons = {}

local recursionfix = {}

local initialMousePos = { 0, 0 }
local initialMoonPos = { 0, 0 }
local initialScreenPos = { 0, 0 }

local lightAlpha = 0

local magnetizing

local function holding(n)
    local xMouse, yMouse = input.mouse()
    local xScreen, yScreen = ScreenScroll.getScreenLocation()
    currentMoons[n][1] = initialMoonPos[1] + xMouse - initialMousePos[1] + xScreen - initialScreenPos[1]
    currentMoons[n][2] = initialMoonPos[2] + yMouse - initialMousePos[2] + yScreen - initialScreenPos[2]
    local halfDim = currentMoons[n][5] / 2
    local centerPosX = currentMoons[n][1] + halfDim
    local centerPosY = currentMoons[n][2] + halfDim
    if (centerPosX > 640) then
        currentMoons[n][1] = 640 - halfDim
    elseif (centerPosX < 0) then
        currentMoons[n][1] = 0 - halfDim
    end
    if (centerPosY < 0) then
        currentMoons[n][2] = 0 - halfDim
    elseif (centerPosY > 134 and centerPosX < 216) then
        currentMoons[n][2] = 134 - halfDim
    elseif (centerPosY + (0.5 * halfDim) > 266 and centerPosX >= 216) then
        currentMoons[n][2] = 266 - (1.5 * halfDim)
    end
end

local function dropped(n)
    MouseHandler.removeFromClickable(n)
    MouseHandler.addToClickable(currentMoons[n][1], currentMoons[n][2], currentMoons[n][5], currentMoons[n][6],
        MouseHandler.getClickableCount() + 1,
        n, recursionfix.clicked)
end

function recursionfix.clicked(n)
    if (n == 2 and magnetizing) then return end
    initialMousePos[1], initialMousePos[2] = input.mouse()
    initialMoonPos[1], initialMoonPos[2] = currentMoons[n][1], currentMoons[n][2]
    initialScreenPos[1], initialScreenPos[2] = ScreenScroll.getScreenLocation()
    MouseHandler.currentlyHeld(n, dropped, holding)
end

function M.addMoon(x, y, sx, sy, w, h, id)
    local obj = { x, y, sx, sy, w, h, id, 1 }
    table.insert(currentMoons, id, obj)
    MouseHandler.addToClickable(x, y, w, h, MouseHandler.getClickableCount() + 1, id, recursionfix.clicked)
end

function M.init()
    M.addMoon(30, 10, 0, 0, 64, 64, AssignId())
    M.addMoon(-50, 400, 240, 16, 32, 32, AssignId())
    M.addMoon(-50, 400, 272, 0, 64, 64, AssignId())
    EtherealObject = require("src.etherealObject")
    Relic = require("src.relic")
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
        if (i == 2 and magnetizing) then
            local tenthsOfSecond = math.floor((Time * 10) % 10)
            local baseRadius = 16
            if (tenthsOfSecond <= 2 or (tenthsOfSecond <= 6 and tenthsOfSecond > 4)) then
                baseRadius = 17
            end
            ScreenScroll.circ(currentMoons[2][1] + 16, currentMoons[2][2] + 16, baseRadius, 9, 0.6)
            ScreenScroll.circ(currentMoons[2][1] + 16, currentMoons[2][2] + 16, baseRadius + 2, 9, 0.4)
            ScreenScroll.circ(currentMoons[2][1] + 16, currentMoons[2][2] + 16, baseRadius + 4, 9, 0.2)
        end
        if i == 3 then
            ScreenScroll.tri_fill(currentMoons[3][1] - 50 + 32, currentMoons[3][2] + 90 + 32, currentMoons[3][1] + 32, currentMoons[3][2] + 13, currentMoons[3][1] + 50 + 32, currentMoons[3][2] + 90 + 32, 11, 0.3 + lightAlpha)
        end
        ScreenScroll.sspr(moon[3], moon[4], moon[5], moon[6], moon[1], moon[2], moon[8])
    end
end

function M.getPos(n)
    return currentMoons[n][1], currentMoons[n][2]
end

function M.isMagnetizing(currentlyMagnetizing)
    if magnetizing ~= currentlyMagnetizing and currentlyMagnetizing == true then
        sfx.play_ex("magnetsound", 0.3, 1, 0)
    end
    magnetizing = currentlyMagnetizing
end

function M.moveMoon(n, x, y)
    currentMoons[n][1] = x
    currentMoons[n][2] = y
    MouseHandler.removeFromClickable(n)
    MouseHandler.addToClickable(x, y, currentMoons[n][5], currentMoons[n][6], MouseHandler.getClickableCount() + 1, n, recursionfix.clicked)
end

function M.update()
    EtherealObject.move(7, currentMoons[1][1] + 12, currentMoons[1][2] + 12)
    currentMoons[1][8] = EtherealObject.getAlpha(7)
    Relic.moveRelic(11, currentMoons[1][1] + 20, currentMoons[1][2] + 20)
end

return M
