local M = {}

local Moon = require("src.moon")
local ScreenScroll = require("src.screenScroll")

local ypoints = {}
local prevYpoints = {}
local defaultChance = 0.5
local waveChance = 0.25
local riseChance = 0
local riseIntensity = 0.006
local waterSize = 450
local rectWidth = 2
local rectCount = 0
local waves = false
local rise = true
local gravEffect = 15
local baseGrav = 0.45
local reverseGravEffect = 0.004
local gravDistance = 30
local greaterGravDistance = 100
local yMax = 60
local yMin = 170

local xWater = 200
local yWater = 100

function M.init()
    rectCount = waterSize / rectWidth
    for i = 1, rectCount do
        ypoints[i] = 100
        prevYpoints[i] = 100
    end
end

local function gravityCalc(waterIndex)
    local moonPos = { 0, 0 }
    moonPos["x"], moonPos["y"] = Moon.getPos(1)
    local dist = util.vec_dist(moonPos, { ["x"] = waterIndex * rectWidth, ["y"] = prevYpoints[waterIndex] })
    local gravity = 0
    if (dist > 250) then
        gravity += 0.2
        return gravity
    end
    local xDist = math.abs(moonPos["x"] - (waterIndex * rectWidth))
    if (xDist < gravDistance) then
        gravity += -((gravEffect * (1 / dist)) + baseGrav)
    else
        gravity += (reverseGravEffect * dist) - baseGrav
    end
    if (xDist < greaterGravDistance and xDist > gravDistance) then
        gravity -= gravEffect * (2 / dist)
    end
    return gravity
end

local function processPoints(dt)
    for i = 1, rectCount do
        if ((i % 10) ~= (math.floor(10 * (Time % 1)))) then
            if (math.random() < 0.8) then
                goto continue
            end
        end
        local gravity = gravityCalc(i)
        local centerpoint = yWater + gravity
        local y = centerpoint
        if (i ~= 1 and i ~= rectCount and prevYpoints[i + 1] ~= nil and prevYpoints[i - 1] ~= nil) then
            y = ((prevYpoints[i - 1] + prevYpoints[i + 1]) / 2) + gravity
        elseif (i == 1 and prevYpoints[i + 1] ~= nil) then
            y = prevYpoints[i + 1] + gravity
        elseif (i == rectCount and prevYpoints[i - 1] ~= nil) then
            y = prevYpoints[i - 1] + gravity
        end

        if (y < yMax) then
            y = yMax
        end
        if (y > yMin) then
            y = yMin
        end

        if (waves and math.random() < waveChance and i ~= 1 and i ~= 2 and prevYpoints[i + 1] ~= nil and prevYpoints[i + 2] ~= nil) then
            if (prevYpoints[i + 1] > prevYpoints[i + 2] and y > prevYpoints[i + 1]) then
                y += rectWidth
            elseif (prevYpoints[i + 1] < prevYpoints[i + 2] and y < prevYpoints[i + 1]) then
                y -= rectWidth
            end
        end

        if (math.random() < defaultChance) then
            y += math.random(-1, 1)
        end
        if (Time > 10 and rise) then
            if (Time % 5 < 2.5) then
                riseChance += riseIntensity * dt
            else
                riseChance -= riseIntensity * dt
            end
            if (math.random() < riseChance) then
                if (Time % 10 < 5) then
                    y += 1
                    yMax += 0.1 * dt
                else
                    y -= 1
                    yMax -= 0.1 * dt
                end
            end
        end

        ypoints[i] = y
        ::continue::
    end
    for i = 1, rectCount do
        prevYpoints[i] = ypoints[i]
    end
end

function M.update(dt)
    processPoints(dt)
end

function M.draw()
    for i = 1, rectCount do
        ScreenScroll.rect_fill((rectWidth * i) - rectWidth + xWater, ypoints[i] + yWater, rectWidth, 320 - ypoints[i], gfx.COLOR_DARK_BLUE,
            1)
    end
end

return M
