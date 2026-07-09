local M = {}

local ScreenScroll = require("src.screenScroll")

local clickable = {}

local held = {}

local isHolding = false

function M.checkMouseClick()
    local xScreen, yScreen = ScreenScroll.getScreenLocation()
    if (input.mouse_pressed(input.MOUSE_LEFT)) then
        local mousePos = { 0, 0 }
        local clicked = {}
        mousePos["x"], mousePos["y"] = input.mouse()
        for i = 1, #clickable do
            if (mousePos["x"] > (clickable[i][1] - xScreen) and mousePos["x"] < (clickable[i][1] + clickable[i][3] - xScreen) and mousePos["y"] > (clickable[i][2] - yScreen) and mousePos["y"] < (clickable[i][2] + clickable[i][4] - yScreen)) then
                table.insert(clicked, i)
            end
        end
        if (#clicked == 0) then
            return
        end
        local topDrawingIndex = 1
        if #clicked > 1 then
            local topDrawingLayer = 0
            for i = 1, #clicked do
                if (clickable[clicked[i]][5] > topDrawingLayer) then
                    topDrawingLayer = clickable[clicked[i]][5]
                    topDrawingIndex = i
                end
            end
        end
        local id = clickable[clicked[topDrawingIndex]][6]
        clickable[clicked[topDrawingIndex]].clicked(id)
    end
end

function M.checkMouseHold()
    if isHolding then
        if (input.mouse_released(input.MOUSE_LEFT)) then
            held.dropped(held[1])
            held = {}
            isHolding = false
        else
            held.holding(held[1])
        end
    end
end

function M.addToClickable(x, y, w, h, layer, id, clicked)
    local obj = { x, y, w, h, layer, id, clicked = clicked }
    table.insert(clickable, obj)
end

function M.getClickableCount()
    local count = 0
    for _, obj in pairs(clickable) do
        count += 1
    end
    return count
end

function M.currentlyHeld(id, dropped, holding)
    held = { id, dropped = dropped, holding = holding }
    isHolding = true
end

function M.removeFromClickable(id)
    for i, obj in ipairs(clickable) do
        if (obj[6] == id) then
            table.remove(clickable, i)
        end
    end
end

return M
