function _config()
    ---@type Usagi.Config
    return { name = "Game", game_id = "com.usagiengine.YOURGAMENAME" }
end

local scenes = { MainMenu = require("scenes.mainMenu"), Game = require("scenes.game") }

Time = 0


function SwitchScenes(key)
    local newScene = scenes[key]
    State.pendingScene = key
end

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    State = {}
    SwitchScenes("MainMenu")
end

function _update(dt)
    if (State.pendingScene) then
        if (State.currentScene) then
            scenes[State.currentScene].close()
        end
        State.currentScene = State.pendingScene
        State.pendingScene = nil
        scenes[State.currentScene].init()
    end
    scenes[State.currentScene].update(dt)
end

function _draw(dt)
    gfx.clear(gfx.COLOR_BLACK)
    scenes[State.currentScene].draw(dt)
end
