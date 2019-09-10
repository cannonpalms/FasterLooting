-- File: FasterLooting.lua
-- Name: FasterLooting
-- Author: cannon
-- Description: Auto loots all items without the delay currently in Classic
-- Version: 1.0.0

-- Time delay
local tDelay = 0

-- Fast loot function
local function FastLoot()
    if GetTime() - tDelay >= 0.3 then
        tDelay = GetTime()
        if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot(i)
            end
            tDelay = GetTime()
        end
    end
end

-- event frame
local faster = CreateFrame("Frame")
faster:RegisterEvent("LOOT_READY")
faster:SetScript("OnEvent", FastLoot)