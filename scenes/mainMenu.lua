local M = {}

local MouseHandler = require("src.mouseHandler")

local function clicked(n)
    MouseHandler.removeFromClickable(n)
    SwitchScenes("Game", true)
end

function M.init()
    MouseHandler.addToClickable(95, 55, 70, 25, MouseHandler.getClickableCount() + 1, MouseHandler.getClickableCount() + 1, clicked)
end

function M.close()
end

function M.update(dt)

end

function M.draw(dt)
    gfx.text("I Spy!", 100, 30, gfx.COLOR_BLUE, 1)
    gfx.rect_fill(95, 55, 70, 25, gfx.COLOR_DARK_GRAY, 1)
    gfx.text("Start game", 100, 60, gfx.COLOR_BLUE, 1)
end

return M
