local addonName,EscortWarn = ...
local L = EscortWarn.L
local settings = EscortWarn.settings
--Modeled after CONFIRM_ACCEPT_PVP_QUEST

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
			SendChatMessage(string.format(L["ANNOUNCE_ESCORT_QUEST"],C_QuestLog.GetQuestInfo(GetQuestID()) or ""), channel)
		else
			print(string.format(L["ANNOUNCE_ESCORT_QUEST"],C_QuestLog.GetQuestInfo(GetQuestID()) or ""))
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
	whileDead = 1,
}

local original_AcceptQuest = AcceptQuest
EscortWarn.original_AcceptQuest = original_AcceptQuest
function EscortWarn.AcceptQuest(override)
	if not settings.enabled then return original_AcceptQuest() end
	if override == true then 
		original_AcceptQuest()
		return
	end
	local questID = GetQuestID()
	if questID and EscortWarn.EventQuests[questID] then--escort quest starting
		QuestFrame.dialog = StaticPopup_Show("CONFIRM_ESCORT_QUEST");
		return
	else
		original_AcceptQuest()
		return
	end
end
function EscortWarn:Hook()
_G["AcceptQuest"] = EscortWarn.AcceptQuest
end
function EscortWarn:UnHook()
_G["AcceptQuest"] = original_AcceptQuest
end

if settings.enabled then EscortWarn:Hook() end