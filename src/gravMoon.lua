local M = {}

local ScreenScroll = require("src.screenScroll")

local xMoon = 20
local yMoon = 20

function M.getPos()
    return input.mouse()
end

function M.draw()
    ScreenScroll.sspr(0, 0, 64, 64, xMoon, yMoon)
end

return M
