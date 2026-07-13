local M = {}

local Relic = require("src.relic")

local startTime
local alpha = 1
local screen = 1

local relics = {}

local drawSkeleton = false

function M.init()
    music.stop()
    music.play("end music")
    startTime = Time
    relics = { Relic.getRelicFromList(1), Relic.getRelicFromList(3), Relic.getRelicFromList(6), Relic.getRelicFromList(7),
        Relic.getRelicFromList(8), Relic.getRelicFromList(11),
        Relic.getRelicFromList(12), Relic.getRelicFromList(13), Relic.getRelicFromList(14), Relic.getRelicFromList(15), Relic.getRelicFromList(17)}
    drawSkeleton = Relic.getRelicFromList(2)["found"] and Relic.getRelicFromList(4)["found"] and Relic.getRelicFromList(5)["found"] and Relic.getRelicFromList(9)["found"] and Relic.getRelicFromList(10)["found"] and Relic.getRelicFromList(16)["found"] and Relic.getRelicFromList(18)["found"] and Relic.getRelicFromList(19)["found"]
end

function M.close()
end

function M.update(dt)
    if (Time - startTime > 5) then
        alpha -= dt
        if (alpha < -0.5) then
            if (screen == 4) then
                SwitchScenes("Credits", true)
            end
            screen += 1
            startTime = Time
        end
        return
    end
    if (alpha < 1) then
        alpha += dt
    end
end

function M.draw()
    gfx.sspr(0, 874, 320, 180, 0, 0, alpha)

    gfx.sspr(165, 842, 32, 32, 64, 142, alpha)
    gfx.sspr(90, 842, 40, 22, 60, 160, alpha)
    gfx.sspr(165, 842, 32, 32, 224, 142, alpha)
    gfx.sspr(90, 842, 40, 22, 220, 160, alpha)
    if (screen == 4) then
        if (relics[10]["found"]) then
            gfx.sspr(relics[10][3], relics[10][4], relics[10][6], relics[10][7], 72, 122, alpha)
        end
        if (relics[11]["found"]) then
            gfx.sspr(relics[11][3], relics[11][4], relics[11][6], relics[11][7], (2 * 80) + 72, 122, alpha)
        end
        gfx.sspr(197, 810, 64, 64, 128, 126, alpha)
        gfx.sspr(90, 842, 40, 22, 124, 160, alpha)
        if drawSkeleton then
            gfx.sspr(261, 784, 50, 90, 135, 36, alpha)
        end
        return
    end
    gfx.sspr(165, 842, 32, 32, 144, 142, alpha)
    gfx.sspr(90, 842, 40, 22, 140, 160, alpha)
    for i = 1, 3 do
        local relici = i + (screen - 1) * 3
        if (relics[relici] ~= nil) then
            if (relics[relici]["found"]) then
                gfx.sspr(relics[relici][3], relics[relici][4], relics[relici][6], relics[relici][7], ((i - 1) * 80) + 72, 122, alpha)
            end
        end
    end
end

return M
