local Water = require("src.water")

function _config()
    ---@type Usagi.Config
    return { name = "Game", game_id = "com.usagiengine.YOURGAMENAME" }
end

Time = 0

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    Water.init()
    State = {}
end

function _update(dt)
    Time += dt
    Water.update(dt)
end

function _draw(dt)
    gfx.clear(gfx.COLOR_BLACK)
    Water.draw()
end
