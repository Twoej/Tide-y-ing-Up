local water = require("src.water")

function _config()
    ---@type Usagi.Config
    return { name = "Game", game_id = "com.usagiengine.YOURGAMENAME" }
end

local time = 0

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    water.init()
    State = {}
end

function _update(dt)
    time += dt
    water.processPoints(time)
end

function _draw(dt)
    gfx.clear(gfx.COLOR_BLACK)
    water.draw()
end
