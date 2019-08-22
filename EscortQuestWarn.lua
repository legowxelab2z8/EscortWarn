addonName,addon = ...
EscortQuestWarn = {}
addon.frame = CreateFrame("Frame", addonName .. "Frame", UIParent)

--Modeled after CONFIRM_ACCEPT_PVP_QUEST
CONFIRM_ESCORT_QUEST = "Accepting this quest will start an event. Do you wish to accept?"
StaticPopupDialogs["CONFIRM_ESCORT_QUEST"] = {
	text = CONFIRM_ESCORT_QUEST,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function (self) AcceptQuest(true); end,
	OnCancel = function (self) DeclineQuest(); end,
	OnShow = function()
		QuestFrameAcceptButton:Disable();
		QuestFrameDeclineButton:Disable();
	end,
	OnHide = function()
		QuestFrameAcceptButton:Enable();
		QuestFrameDeclineButton:Enable();
	end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 0,
	whileDead = 1,
}

local original_AcceptQuest = AcceptQuest
EscortQuestWarn.original_AcceptQuest = original_AcceptQuest
function EscortQuestWarn.AcceptQuest(override)
	if override == true then 
		original_AcceptQuest()
		return
	end
	local questID = GetQuestID()
	if questID and addon.EventQuests[questID] then
		--escort quest starting
		--print("Attempting to start escort quest")
		QuestFrame.dialog = StaticPopup_Show("CONFIRM_ESCORT_QUEST");
		return
	else
		--print("not escort quest")
		original_AcceptQuest()
		return
	end
end

-- Register events and call functions
addon.frame:SetScript("OnEvent", function(self, event, ...)
	addonTable.frame[event](self, ...)
end)

addon.frame:RegisterEvent('PLAYER_ENTERING_WORLD')
function addon.frame:PLAYER_ENTERING_WORLD()
	--print("entering world")
	--Hook AcceptQuest
	_G["AcceptQuest"] = EscortQuestWarn.AcceptQuest
end