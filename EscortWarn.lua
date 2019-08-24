local addonName,EscortWarn = ...
local L = EscortWarn.L
local hooked = false
ew = EscortWarn -- DEBUGGING DELETE ME
--Modeled after CONFIRM_ACCEPT_PVP_QUEST
StaticPopupDialogs["CONFIRM_ESCORT_QUEST"] = {
	text = CONFIRM_ESCORT_QUEST,
	button1 = ACCEPT,
	button2 = CANCEL,
	button3 = CHAT_ANNOUNCE,
	OnAccept = function (self) AcceptQuest(true); end,
	OnCancel = function (self) DeclineQuest(); end,
	OnAlt = function ()
		EscortWarn:Announce()
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
	if not EscortWarnData then return original_AcceptQuest() end
	if not EscortWarnData.settings.enabled then return original_AcceptQuest() end
	if override == true then return original_AcceptQuest() end
	if not hooked then print("shouldnt be hooked") return original_AcceptQuest() end --Shouldn't happen, but maybe
	
	local questID = GetQuestID()
	if questID and EscortWarn.EventQuests[questID] then--escort quest starting
		QuestFrame.dialog = StaticPopup_Show("CONFIRM_ESCORT_QUEST");
		if EscortWarnData.settings.autoAnnounce then
			EscortWarn:Announce()
		end
		return
	else
		original_AcceptQuest()
		return
	end
end

function EscortWarn:Announce()
	local channel
	if IsInGroup() then channel="PARTY" end
	if IsInRaid() then channel="RAID" end
	if channel then
		SendChatMessage(string.format(L["ANNOUNCE_ESCORT_QUEST"],C_QuestLog.GetQuestInfo(GetQuestID()) or ""), channel)
	else
		print(string.format(L["ANNOUNCE_ESCORT_QUEST"],C_QuestLog.GetQuestInfo(GetQuestID()) or "")) -- DEBUGGING DELETE ME
	end
end

function EscortWarn:Hook()
	if not hooked then
		print("hook") -- DEBUGGING DELETE ME
		_G["AcceptQuest"] = EscortWarn.AcceptQuest
		hooked = true
	end
end
function EscortWarn:UnHook()
	if hooked then 
		print("unhook") -- DEBUGGING DELETE ME
		_G["AcceptQuest"] = original_AcceptQuest
		hooked = false
	end
end