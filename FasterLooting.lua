-- File: FasterLooting.lua
-- Name: FasterLooting
-- Author: cannon, latenssi
-- Description: Auto loots all items without the delay currently in Classic
-- Version: 1.2.0

local DEBOUNCE_INTERVAL = 0.3

local delay = 0
local shouldFastLoot = false
local LootFrame_OnEvent_default = LootFrame:GetScript("OnEvent")

-- Fast loot function
function FastLoot()
    if GetTime() - delay >= DEBOUNCE_INTERVAL then
        for i = GetNumLootItems(), 1, -1 do
            LootSlot(i)
        end
        delay = GetTime()
    end
end

function LootFrame_OnEvent_modified(...)
    local _, event = ...

    if event == "LOOT_READY" then
        shouldFastLoot = GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE")
    elseif event == "LOOT_CLOSED" then
        -- Reset
        shouldFastLoot = false
    end

    if event == "LOOT_READY" and shouldFastLoot then
        -- Run our FastLoot handler
        -- Note: Ignoring all LootFrame registered events to prevent displaying the loot window etc.
        -- Note: This is run on LOOT_READY so we do not need to wait for the LOOT_OPENED event
        FastLoot()
    elseif not shouldFastLoot then
        -- Run the default handler
        LootFrame_OnEvent_default(...)
    end
end

LootFrame:SetScript("OnEvent", LootFrame_OnEvent_modified)
