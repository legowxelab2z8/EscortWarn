local addonName,addon = ...
EscortQuestWarn = {}
addon.frame = CreateFrame("Frame", addonName .. "Frame", UIParent)

--Modeled after CONFIRM_ACCEPT_PVP_QUEST
CONFIRM_ESCORT_QUEST = "Accepting this quest will start an event. Do you wish to accept?"
ANNOUNCE_ESCORT_QUEST = "I am ready to start event quest: %s"
StaticPopupDialogs["CONFIRM_ESCORT_QUEST"] = {
	text = CONFIRM_ESCORT_QUEST,
	button1 = ACCEPT,
	button2 = CANCEL,
	button3 = CHAT_ANNOUNCE,
	OnAccept = function (self) AcceptQuest(true); end,
	OnCancel = function (self) DeclineQuest(); end,
	OnAlt = function ()
		local channel
		if IsInGroup() then channel="PARTY" end
		if IsInRaid() then channel="RAID" end
		if channel then
			print(channel)
			SendChatMessage(string.format(ANNOUNCE_ESCORT_QUEST,C_QuestLog.GetQuestInfo(GetQuestID()) or ""), channel)
		else
			print(string.format(ANNOUNCE_ESCORT_QUEST,C_QuestLog.GetQuestInfo(GetQuestID()) or ""))
		end
	end,
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
	addon.frame[event](self, ...)
end)

addon.frame:RegisterEvent('PLAYER_ENTERING_WORLD')
function addon.frame:PLAYER_ENTERING_WORLD()
	--Hook AcceptQuest
	_G["AcceptQuest"] = EscortQuestWarn.AcceptQuest
end