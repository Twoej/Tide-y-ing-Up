local M = {}

local ypoints = {}
local prevYpoints = {}
local defaultChance = 0.5

function M.init()
    for i = 1, 160 do
        ypoints[i] = 100
        prevYpoints[i] = 100
    end
end

function M.processPoints(time)
    for i = 1, 160 do
        if ((i % 10) ~= (math.floor(10 * (time % 1)))) then
            if (math.random() < 0.8) then
                goto continue
            end
        end
        local centerpoint = 100
        local y = centerpoint

        if (math.random() < defaultChance) then
            y += math.random(-1, 1)
        end
        if (i ~= 1 and i ~= 160) then
            if (prevYpoints[i - 1] ~= centerpoint or prevYpoints[i + 1] ~= centerpoint) then
                y = ((prevYpoints[i - 1] + prevYpoints[i + 1]) / 2)
            end
            if (math.random() < defaultChance) then
                y += math.random(-1, 1)
            end
        end
        ypoints[i] = y
        ::continue::
    end
    for i = 1, 160 do
        prevYpoints[i] = ypoints[i]
    end
end

function M.draw()
    for i = 1, 160 do
        gfx.rect_fill((2 * i) - 1, ypoints[i], 2, ypoints[i], gfx.COLOR_DARK_BLUE, 1)
    end
end

return M
