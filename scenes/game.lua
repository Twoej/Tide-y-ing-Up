local M = {}

local Water = require("src.water")
local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local Relic = require("src.relic")
local EtherealObject = require("src.etherealObject")
local Boat = require("src.boat")

Time = 0

function M.init()
    music.loop("main music")
    Moon.init()
    Water.init()
    Relic.init()
    EtherealObject.init()
    Boat.init()
end

function M.close()
end

function M.update(dt)
    ScreenScroll.scrollInputProcess(dt)
    Water.update(dt)
    Relic.update(dt)
    EtherealObject.update(dt)
    if (input.key_pressed(input.KEY_TAB)) then
        SwitchScenes("RelicList", true)
    end
    Boat.update(dt)
    Moon.update()

    if (Relic.foundRelicCount() >= 12 and input.key_pressed(input.KEY_SPACE)) then
        SwitchScenes("Museum", true)
    end
end

function M.draw(dt)
    ScreenScroll.sspr(0, 64, 640, 360, 0, 0, 1, true)
    Relic.draw()
    EtherealObject.draw()
    Moon.draw(dt)
    Boat.draw()
    if not (Relic.isFound(15) and Relic.isFound(14)) then
        local glintR
        local timeMod8 = Time % 8
        local timeMod8Mod3 = timeMod8 % 3
        if (timeMod8 < 3) then
            if (timeMod8Mod3 < 1 or timeMod8Mod3 > 2) then
                glintR = 1
            else
                glintR = 2
            end
            if not (Relic.isFound(15) or Relic.isMagnetized(15)) then
                ScreenScroll.circ_fill(254, 333, glintR, gfx.COLOR_TRUE_WHITE, 0.8)
            end
            if not (Relic.isFound(14) or Relic.isMagnetized(14)) then
                ScreenScroll.circ_fill(140, 122, glintR, gfx.COLOR_TRUE_WHITE, 0.8)
            end
        end
    end
    if (not (Relic.isFound(16) or Relic.isVisible(16))) then
        ScreenScroll.sspr(105, 49, 7, 6, 537, 217, 1, false)
    end
    Water.draw()
    ScreenScroll.sspr(0, 424, 640, 360, 0, 0, 1, true)
    Relic.drawOver(dt)
    gfx.text("Relics: " .. Relic.foundRelicCount() .. "/19", 5, 5, gfx.COLOR_WHITE, 1)
end

return M
