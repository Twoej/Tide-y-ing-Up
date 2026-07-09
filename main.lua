local Water = require("src.water")
local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local MouseHandler = require("src.mouseHandler")
local Relic = require("src.relic")

function _config()
    ---@type Usagi.Config
    return { name = "Game", game_id = "com.usagiengine.YOURGAMENAME" }
end

Time = 0

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    Moon.init()
    Water.init()
    State = {}
    Relic.init()
end

function _update(dt)
    Time += dt
    ScreenScroll.scrollInputProcess(dt)
    Water.update(dt)
    MouseHandler.checkMouseClick()
    MouseHandler.checkMouseHold()
    Relic.update(dt)
end

function _draw(dt)
    gfx.clear(gfx.COLOR_BLACK)
    ScreenScroll.sspr(0, 64, 640, 360, 0, 0, 1, true)
    Moon.draw()
    Water.draw()
    Relic.draw()
end
