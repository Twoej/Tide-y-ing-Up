local M = {}

local spacebarPresses = 0

function M.init()
end

function M.close()
end

function M.update()
end

function M.draw()
    if (spacebarPresses == 0) then
        gfx.text(
            "You are investigating a crash on an\nalien planet.\nYou mysteriously discover that you can\nmagically control the moon here\n\nHow will this aid your investigation?\n\n\nPress spacebar to continue",
            40, 30, gfx.COLOR_WHITE, 1)
    end
    if (spacebarPresses == 1) then
        gfx.text(
        "wasd or arrows to move camera\nuse the mouse to click on relics\nand move the moon\ntab to view acquired relics\n\n\nPress spacebar to continue",
            40, 30, gfx.COLOR_WHITE, 1)
    end
    if (spacebarPresses == 2) then
        SwitchScenes("Game", true)
    end
    if (input.key_pressed(input.KEY_SPACE)) then
        spacebarPresses += 1
    end
end

return M
