local M = {}

local maxScrollSpeed = 120
local scrollSpeed = 0
local scrollAccel = 90

local screenLocation = { ["x"] = 0, ["y"] = 0 }
local screenBorders = { ["left"] = 0, ["right"] = 320, ["up"] = 0, ["down"] = 180 }

function M.scrollInputProcess(dt)
    if (input.held(input.LEFT)) then
        screenLocation["x"] -= scrollSpeed * dt
        if (screenLocation["x"] < screenBorders["left"]) then
            screenLocation["x"] = screenBorders["left"]
        end
    end
    if (input.held(input.RIGHT)) then
        screenLocation["x"] += scrollSpeed * dt
        if (screenLocation["x"] > screenBorders["right"]) then
            screenLocation["x"] = screenBorders["right"]
        end
    end
    if (input.held(input.UP)) then
        screenLocation["y"] -= scrollSpeed * dt
        if (screenLocation["y"] < screenBorders["up"]) then
            screenLocation["y"] = screenBorders["up"]
        end
    end
    if (input.held(input.DOWN)) then
        screenLocation["y"] += scrollSpeed * dt
        if (screenLocation["y"] > screenBorders["down"]) then
            screenLocation["y"] = screenBorders["down"]
        end
    end
    scrollSpeed += scrollAccel * dt
    if (scrollSpeed > maxScrollSpeed) then
        scrollSpeed = maxScrollSpeed
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

function M.sspr(sx, sy, sw, sh, dx, dy, alpha, background)
    if (background or checkIfDraw(dx, dy, sw, sh)) then
        gfx.sspr(sx, sy, sw, sh, dx - screenLocation["x"], dy - screenLocation["y"], alpha)
    end
end

function M.spr(index, x, y, alpha)
    if (checkIfDraw(x, y, 16, 16)) then
        gfx.spr(index, x - screenLocation["x"], y - screenLocation["y"], alpha)
    end
end

function M.getScreenLocation()
    return screenLocation["x"], screenLocation["y"]
end

return M
