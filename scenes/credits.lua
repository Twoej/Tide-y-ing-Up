local M = {}

function M.init()
end

function M.close()
end

function M.update()
end

function M.draw()
    gfx.text(
    "Credits\nProgramming - Joshua Toohey\nArt - Ellie Chartrain-Lawton\n      Emma Toohey\nMusic and Sfx - Ellie Chartrain-Lawton\n\nThanks for playing!",
        40, 30, gfx.COLOR_WHITE, 1)
end


return M
