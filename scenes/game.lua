local M = {}

local Water = require("src.water")
local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local Relic = require("src.relic")
local EtherealObject = require("src.etherealObject")

Time = 0

function M.init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    Moon.init()
    Water.init()
    Relic.init()
    EtherealObject.init()
end

function M.close()
end

function M.update(dt)
    Time += dt
    ScreenScroll.scrollInputProcess(dt)
    Water.update(dt)
    Relic.update(dt)
    EtherealObject.update(dt)
    if (input.key_pressed(input.KEY_TAB)) then
        SwitchScenes("RelicList", true)
    end
end

function M.draw(dt)
    ScreenScroll.sspr(0, 64, 640, 360, 0, 0, 1, true)
    Moon.draw(dt)
    Relic.draw()
    EtherealObject.draw()
    Water.draw()
    ScreenScroll.sspr(0, 424, 640, 360, 0, 0, 1, true)
    Relic.drawOver(dt)
end

return M
