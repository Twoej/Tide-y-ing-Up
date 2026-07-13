function _config()
    ---@type Usagi.Config
    return { name = "Game", game_id = "com.usagiengine.YOURGAMENAME" }
end

local MouseHandler = require("src.mouseHandler")

local scenes = { MainMenu = require("scenes.mainMenu"), Game = require("scenes.game"), RelicList = require("scenes.relicList"), Museum = require("scenes.museum"), Credits = require("scenes.credits"), Intro = require("scenes.intro") }

Time = 0

local currentIdNumber = 0

function AssignId()
    currentIdNumber += 1
    return currentIdNumber
end


function SwitchScenes(key, init)
    State.pendingScene = key
    State.doInit = init
end

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    State = {}
    SwitchScenes("MainMenu", true)
end

function _update(dt)
    Time += dt
    if (State.pendingScene) then
        if (State.currentScene) then
            scenes[State.currentScene].close()
        end
        State.currentScene = State.pendingScene
        State.pendingScene = nil
        if (State.doInit) then
            scenes[State.currentScene].init()
        end
    end
    scenes[State.currentScene].update(dt)
    MouseHandler.checkMouseClick()
    MouseHandler.checkMouseHold()
end

function _draw(dt)
    gfx.clear(gfx.COLOR_BLACK)
    scenes[State.currentScene].draw(dt)
end
