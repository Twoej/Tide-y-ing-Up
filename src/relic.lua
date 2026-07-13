local M = {}

local ScreenScroll = require("src.screenScroll")
local MouseHandler = require("src.mouseHandler")
local Moon = require("src.moon")

local relicList = {}

local relicUnlock1 = false
local relicUnlock2 = false
local relicUnlockTime = -20

local messageFound = false
local messageFoundTime = -20

local textAlpha = 0
local textAlpha2 = 0

local function addToRelicList(x, y, sx, sy, ssprite, spridx, w, h, id, found, visible, magnetic)
    local t = {
        x,
        y,
        sx,
        sy,
        ["ssprite"] = ssprite,
        id,
        ["found"] = found,
        ["visible"] = visible,
        w,
        h,
        spridx,
        ["fading"] = false,
        ["alpha"] = 1,
        ["magnetic"] = magnetic,
        ["magnetized"] = false,
        ["magnetizedTime"] = 0,
        ["attachedToMoonx"] = nil
    }
    table.insert(relicList, t)
end

local function clicked(n)
    for i, relic in ipairs(relicList) do
        if (relic[5] == n) then
            sfx.play_ex("collectingrelic", 0.3, 1, 0)
            relicList[i]["found"] = true
            relicList[i]["fading"] = true
            relicList[i]["attachedToMoonx"] = nil
            MouseHandler.removeFromClickable(relic[5])
            return
        end
    end
end

function M.init()
    addToRelicList(50, 124, 64, 0, false, 5, 16, 16, AssignId(), false, true, false)    --flower    1
    addToRelicList(70, 303, 224, 0, false, 15, 16, 16, AssignId(), false, true, false)  --bone      2
    addToRelicList(220, 314, 80, 16, false, 46, 16, 16, AssignId(), false, true, false) --shell     3
    addToRelicList(398, 269, 200, 24, true, 47, 24, 24, AssignId(), false, true, false) --skull     4
    addToRelicList(370, 50, 176, 24, true, 46, 24, 24, AssignId(), false, false, false) --hat       5

    for _, relic in ipairs(relicList) do
        if (relic["visible"]) then
            MouseHandler.addToClickable(relic[1], relic[2], relic[6], relic[7], MouseHandler.getClickableCount() + 1,
                relic[5],
                clicked)
        end
    end
end

function M.foundRelicCount()
    local count = 0
    for _, relic in ipairs(relicList) do
        if (relic["found"]) then
            count += 1
        end
    end
    return count
end

local function unlockRelics1()
    addToRelicList(306, 268, 96, 16, false, 47, 16, 16, AssignId(), false, false, false)    --message in bottle 6
    addToRelicList(93, 109, 64, 32, false, 85, 16, 16, AssignId(), false, false, false)     --doll1             7
    addToRelicList(587, 270, 96, 32, false, 87, 16, 16, AssignId(), false, false, false)    --tooth             8
    addToRelicList(163, 98, 224, 16, false, 55, 16, 16, AssignId(), false, false, false)    --spine             9
    addToRelicList(402, 195, 80, 48, false, 126, 16, 16, AssignId(), false, false, false)   --hand              10
    addToRelicList(50, 30, 176, 0, true, 0, 24, 24, AssignId(), false, false, false)        --crown             11
end

local function unlockRelics2()
    addToRelicList(15, 175, 80, 0, false, 6, 16, 16, AssignId(), false, true, true)         --coin              12
    addToRelicList(93, 148, 96, 0, false, 7, 16, 16, AssignId(), false, false, false)       --doll2             13
    addToRelicList(133, 147, 64, 16, false, 45, 16, 16, AssignId(), false, true, true)      --compass           14
    addToRelicList(247, 318, 64, 48, false, 125, 16, 16, AssignId(), false, false, true)    --earring           15
    addToRelicList(528, 216, 96, 48, false, 127, 16, 16, AssignId(), false, false, true)    --foot              16
    addToRelicList(566, 291, 200, 0, true, 0, 24, 24, AssignId(), false, false, false)      --necklace          17
    addToRelicList(307, 272, 240, 0, false, 16, 16, 16, AssignId(), false, false, false)    --pelvis            18
    addToRelicList(166, 135, 224, 32, false, 95, 16, 16, AssignId(), false, false, false)   --rib               19
end

function M.update(dt)
    local xMoon2, yMoon2 = Moon.getPos(2)
    for _, relic in ipairs(relicList) do
        if (relic["fading"]) then
            relic["alpha"] -= dt
            if (relic["alpha"] <= 0) then
                relic["visible"] = false
                relic["fading"] = false
            end
        end
        if (relic["magnetic"] and not relic["magnetized"]) then
            if (math.abs((xMoon2 + 16) - (relic[1] + (relic[6] / 2))) < 8) then
                relic["magnetized"] = true
                relic["magnetizedTime"] = Time
            end
        end
        if (relic["magnetized"]) then
            if (relic["found"]) then
                Moon.isMagnetizing(false)
                relic["magnetized"] = false
                goto continue
            end
            local timeSinceMagnetize = Time - relic["magnetizedTime"]
            if not (math.abs((xMoon2 + 16) - (relic[1] + (relic[6] / 2))) < 8) then
                relic["magnetized"] = false
                Moon.isMagnetizing(false)
                goto continue
            end
            if (timeSinceMagnetize > 1 and relic["attachedToMoonx"] == nil and not relic["found"]) then
                if (not relic["visible"]) then
                    relic["visible"] = true
                end
                Moon.isMagnetizing(true)
                effect.screen_shake(dt, 1)
                relic[2] -= 40 * dt
                MouseHandler.removeFromClickable(relic[5])
                MouseHandler.addToClickable(relic[1], relic[2], relic[6], relic[7], MouseHandler.getClickableCount() + 1,
                    relic[5],
                    clicked)
                if relic[2] <= (yMoon2 + 30) then
                    relic[2] = yMoon2 + 30
                    relic["magnetized"] = false
                    Moon.isMagnetizing(false)
                    relic["magnetic"] = false
                    relic["attachedToMoonx"] = relic[1] - xMoon2
                end
                relic["magnetizedTime"] += 0.067
            end
        end
        ::continue::
        if (relic["attachedToMoonx"] ~= nil) then
            if (relic[1] ~= relic["attachedToMoonx"] + xMoon2) then
                relic[1] = relic["attachedToMoonx"] + xMoon2
            end
            if (relic[2] ~= (yMoon2 + 30)) then
                relic[2] = yMoon2 + 30
            end
            MouseHandler.removeFromClickable(relic[5])
            MouseHandler.addToClickable(relic[1], relic[2], relic[6], relic[7], MouseHandler.getClickableCount() + 1,
                relic[5],
                clicked)
        end
    end
    if M.foundRelicCount() >= 3 and not relicUnlock1 then
        relicUnlock1 = true
        unlockRelics1()
        relicUnlockTime = Time
        Moon.moveMoon(3, 288, 10)
    end
    if M.foundRelicCount() >= 6 and not relicUnlock2 then
        relicUnlock2 = true
        unlockRelics2()
        relicUnlockTime = Time
        Moon.moveMoon(2, 288, 10)
    end
    if (relicList[6] ~= nil) then
        if relicList[6]["found"] and not messageFound then
            print("here")
            messageFound = true
            messageFoundTime = Time
        end
    end
    if (usagi.IS_DEV and input.key_pressed(input.KEY_L)) then
        for i, relic in ipairs(relicList) do
            if (not relic["found"]) then
                clicked(relic[5])
                break
            end
        end
    end
end

function M.draw()
    for _, relic in ipairs(relicList) do
        if (relic["visible"]) then
            if (relic["ssprite"]) then
                ScreenScroll.sspr(relic[3], relic[4], relic[6], relic[7], relic[1], relic[2], relic["alpha"])
            else
                ScreenScroll.spr(relic[8], relic[1], relic[2], relic["alpha"])
            end
        end
    end
end

function M.drawOver(dt)
    ScreenScroll.sspr(relicList[2][3], relicList[2][4], relicList[2][6], relicList[2][7], relicList[2][1], relicList[2][2], relicList[2]["alpha"])
    if (relicList[5]["visible"]) then
        ScreenScroll.sspr(relicList[5][3], relicList[5][4], relicList[5][6], relicList[5][7], relicList[5][1], relicList[5][2], relicList[5]["alpha"])
    end
    if (Time - relicUnlockTime < 5) then
        if (Time - relicUnlockTime < 2.5) then
            textAlpha += dt
        else
            textAlpha -= dt
        end
        gfx.text("There is a new moon in the sky!", 55, 165, gfx.COLOR_WHITE, textAlpha)
        if (Time - messageFoundTime < 5) then
            messageFoundTime = Time
        end
        return
    end
    if (Time - messageFoundTime < 5) then
        if (Time - messageFoundTime < 2.5) then
            textAlpha2 += dt
        else
            textAlpha2 -= dt
        end
        gfx.text("You have found a message - press tab to read it!", 15, 165, gfx.COLOR_WHITE, textAlpha2)
    end
    if (M.foundRelicCount() >= 12) then
        gfx.text("Press spacebar when finished", 5, 20, gfx.COLOR_WHITE, 1)
    end
end

function M.getRelicFromList(n)
    return relicList[n]
end

function M.getRelicListLength()
    local count = 0
    for _, relic in ipairs(relicList) do
        count += 1
    end
    return count
end

function M.setVisible(n, visible)
    if (relicList[n] == nil) then
        return
    end
    relicList[n]["visible"] = visible
    if visible then
        MouseHandler.addToClickable(relicList[n][1], relicList[n][2], relicList[n][6], relicList[n][7], MouseHandler.getClickableCount() + 1,
        relicList[n][5],
        clicked)
    else
        MouseHandler.removeFromClickable(relicList[n][5])
    end
end


function M.setMagnetic(n, magnetic)
    if(relicList[n] == nil) then
        return
    end
    relicList[n]["magnetic"] = magnetic
end

function M.moveRelic(n, x, y)
    if (relicList[n] == nil) then
        return
    end
    relicList[n][1] = x
    relicList[n][2] = y
    if (relicList[n]["visible"]) then
        MouseHandler.removeFromClickable(relicList[n][5])
        MouseHandler.addToClickable(relicList[n][1], relicList[n][2], relicList[n][6], relicList[n][7], MouseHandler.getClickableCount() + 1,
            relicList[n][5],
            clicked)
    end
end

function M.isFound(n)
    if (relicList[n] == nil) then
        return false
    end
    return relicList[n]["found"]
end

function M.isMagnetized(n)
    if (relicList[n] == nil) then
        return false
    end
    return relicList[n]["magnetized"]
end

function M.isVisible(n)
    if (relicList[n] == nil) then
        return false
    end
    return relicList[n]["visible"]
end

function M.getMessageFound()
    return messageFound
end

return M
