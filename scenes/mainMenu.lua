local M = {}

function M.init()
end

function M.close()
end

function M.update(dt)
    if (input.mouse_pressed(input.MOUSE_LEFT)) then
        SwitchScenes("Game")
    end
end

function M.draw(dt)
    gfx.text("I Spy!", 100, 30, gfx.COLOR_BLUE, 1)
end

return M
