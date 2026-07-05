local M = {}

local scrollSpeed = 30

local screenLocation = { ["x"] = 0, ["y"] = 0 }

function M.scrollInputProcess(dt)
    if (input.held(input.LEFT)) then
        screenLocation["x"] -= scrollSpeed * dt
    end
    if (input.held(input.RIGHT)) then
        screenLocation["x"] += scrollSpeed * dt
    end
    if (input.held(input.UP)) then
        screenLocation["y"] -= scrollSpeed * dt
    end
    if (input.held(input.DOWN)) then
        screenLocation["y"] += scrollSpeed * dt
    end
end

local function checkIfDraw(x, y, w, h)
    for i = x, x + w do
        if ((y < screenLocation["y"] or y > (screenLocation["y"] + 180)) and ((y + h) < screenLocation["y"] or (y + h) > screenLocation["y"] + 180)) then
            break
        end
        if (i >= screenLocation["x"] and i < screenLocation["x"] + 320) then
            return true
        end
    end
    for i = y, y + h do
        if ((x < screenLocation["x"] or x > (screenLocation["x"] + 320)) and ((x + w) < screenLocation["x"] or (x + w) > screenLocation["x"] + 320)) then
            break
        end
        if (i >= screenLocation["y"] and i < screenLocation["y"] + 180) then
            return true
        end
    end
    return false
end

function M.rect_fill(x, y, w, h, color, alpha)
    if (checkIfDraw(x, y, w, h)) then
        gfx.rect_fill(x - screenLocation["x"], y - screenLocation["y"], w, h, color, alpha)
    end
end

return M
