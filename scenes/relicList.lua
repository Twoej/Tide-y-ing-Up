local M = {}

local Relic = require("src.relic")
local MouseHandler = require("src.mouseHandler")
local ScreenScroll = require("src.screenScroll")

local page = 1

local rightArrowId
local leftArrowId

local messageShowing = false

local function clicked(n)
    if (n == rightArrowId and Relic.getRelicListLength() > page * 6) then
        page += 1
    end
    if (n == leftArrowId and page > 1) then
        page -= 1
    end
end

function M.init()
    local xScreen, yScreen = ScreenScroll.getScreenLocation()
    MouseHandler.storeAndClearList()
    rightArrowId = AssignId()
    leftArrowId = AssignId()
    MouseHandler.addToClickable(280 + xScreen, 146 + yScreen, 30, 18, MouseHandler.getClickableCount() + 1, rightArrowId, clicked)
    MouseHandler.addToClickable(10 + xScreen, 146 + yScreen, 30, 18, MouseHandler.getClickableCount() + 1, leftArrowId, clicked)
end

function M.close()
    MouseHandler.removeFromClickable(rightArrowId)
    MouseHandler.removeFromClickable(leftArrowId)
    MouseHandler.restoreList()
end

function M.update(dt)
    if (input.key_pressed(input.KEY_TAB)) then
        SwitchScenes("Game", false)
    end
    if (input.key_pressed(input.KEY_SPACE) and Relic.getMessageFound()) then
        if (messageShowing) then messageShowing = false else messageShowing = true end
    end
end

function M.draw(dt)
    gfx.clear(gfx.COLOR_WHITE)
    if (messageShowing) then
        gfx.text("The message in the bottle:\nHidden beneath stone\nOn the western edge\nMy gold ye shall own\nIf moon ye can leverage", 75, 50, gfx.COLOR_BLACK, 1)
        return
    end
    gfx.text("Relic List", 131, 20, gfx.COLOR_BLACK, 1)
    for i = 1, 6 do
        if ((Relic.getRelicListLength() % 6) < i and math.floor(Relic.getRelicListLength() / 6) < page) then
            break
        end
        local relic = Relic.getRelicFromList(i + ((page - 1) * 6))
        if (relic["found"]) then
            gfx.sspr_ex(relic[3], relic[4], relic[6], relic[7], (((i - 1) % 3) * 64) + 80, (math.floor(i / 4) * 64) + 64,
                2 * relic[6], 2 * relic[7], false, false, 0, gfx.COLOR_TRUE_WHITE, 1)
        else
            gfx.sspr_ex(relic[3], relic[4], relic[6], relic[7], (((i - 1) % 3) * 64) + 80, (math.floor(i / 4) * 64) + 64,
                2 * relic[6], 2 * relic[7], false, false, 0, gfx.COLOR_BLACK, 1)
        end
    end
    if (Relic.getRelicListLength() > page * 6) then
        gfx.rect_fill(280, 150, 20, 9, gfx.COLOR_BLACK, 1)
        gfx.tri_fill(300, 146, 310, 155, 300, 164, gfx.COLOR_BLACK, 1)
    end
    if (page > 1) then
        gfx.rect_fill(20, 150, 20, 9, gfx.COLOR_BLACK, 1)
        gfx.tri_fill(20, 146, 10, 155, 20, 164, gfx.COLOR_BLACK, 1)
    end
    if (Relic.getMessageFound()) then
        gfx.text("Press spacebar to read the message in the bottle", 5, 0, gfx.COLOR_BLACK, 1)
    end
end

return M
