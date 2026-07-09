local M = {}

local Water = require("src.water")
local ScreenScroll = require("src.screenScroll")
local Moon = require("src.moon")
local MouseHandler = require("src.mouseHandler")
local Relic = require("src.relic")

Time = 0

function M.init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    Moon.init()
    Water.init()
    Relic.init()
end

function M.close()
end

function M.update(dt)
    Time += dt
    ScreenScroll.scrollInputProcess(dt)
    Water.update(dt)
    MouseHandler.checkMouseClick()
    MouseHandler.checkMouseHold()
    Relic.update(dt)
end

function M.draw(dt)
    ScreenScroll.sspr(0, 64, 640, 360, 0, 0, 1, true)
    Moon.draw()
    Water.draw()
    Relic.draw()
end

return M
