local FasterLooting = CreateFrame("Frame")

function FasterLooting:LootItems()
	local numItems = GetNumLootItems()
	if numItems > 0 then
		for i = GetNumLootItems(), 1, -1 do
			numItems = numItems - 1
			LootSlot(i)
		end

		if numItems > 0 then
			self:ShowLootFrame(true)
		end
	end
end

function FasterLooting:ShowLootFrame(show)
	local frame, parent = self:GetLootFrame()
	if show then
		self:LootUnderMouse(frame, parent)
		if self.ElvUI then
			frame:SetParent(parent)
			frame:SetFrameStrata("HIGH")
		elseif frame:IsEventRegistered("LOOT_SLOT_CLEARED") then
			frame.page = 1
			LootFrame_Show(frame)
		end
	elseif self.ElvUI then
		frame:SetParent(self)
	end
end

function FasterLooting:GetLootFrame()
	if self.ElvUI then
		return ElvLootFrame, ElvLootFrameHolder
	else
		return LootFrame, UIParent
	end
end

function FasterLooting:LootUnderMouse()
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", parent, "TOPLEFT")
	end
end

function FasterLooting:OnEvent(e, ...)
	if e == "PLAYER_LOGIN" then
		self.ElvUI = ElvUI and ElvUI[1].private.general.loot
		LootFrame:UnregisterEvent("LOOT_OPENED")
		self:ShowLootFrame(false)
	elseif (e == "LOOT_READY" or e == "LOOT_OPENED") and not self.isLooting then
		self.isLooting = true
		local autoLoot = ...
		if autoLoot or GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			self:LootItems()
		else
			self:ShowLootFrame(true)
		end
	elseif e == "LOOT_CLOSED" then
		self.isLooting = false
		self.isHidden = false
		self:ShowLootFrame(false)
	elseif e == "UI_ERROR_MESSAGE" and tContains({ ERR_INV_FULL, ERR_ITEM_MAX_COUNT }, select(2,...)) then
		if self.isLooting and self.isHidden then
			self:ShowLootFrame(true)
		end
	end
end

function FasterLooting:OnLoad()
	self:SetToplevel(true)
	self:Hide()
	self:SetScript("OnEvent", function(_, ...)
		self:OnEvent(...)
	end)

	for _,e in next, ({ "PLAYER_LOGIN",
						"LOOT_READY",
						"LOOT_OPENED",
						"LOOT_CLOSED",
						"UI_ERROR_MESSAGE" }) do
		self:RegisterEvent(e)
	end
end

FasterLooting:OnLoad()