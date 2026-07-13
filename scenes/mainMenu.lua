local M = {}

local MouseHandler = require("src.mouseHandler")

local function clicked(n)
    MouseHandler.removeFromClickable(n)
    SwitchScenes("Intro", true)
end

function M.init()
    music.loop("intro music")
    MouseHandler.addToClickable(231, 141, 68, 19, MouseHandler.getClickableCount() + 1, MouseHandler.getClickableCount() + 1, clicked)
end

function M.close()
    music.stop()
end

function M.update(dt)

end

function M.draw(dt)
    gfx.sspr(320, 874, 320, 180, 0, 0, 1)
end

return M
