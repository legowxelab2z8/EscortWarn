local addonName,EscortWarn = ...
local L = EscortWarn.L
local hooked = false

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

local function GetGroupOrRaid()
	local channel
	if IsInGroup() then channel="PARTY" end
	if IsInRaid() then channel="RAID" end
	return channel
end

local original_AcceptQuest = AcceptQuest
EscortWarn.original_AcceptQuest = original_AcceptQuest
local acceptTime --Used for intercepting calls to hide quest panel this tick
function EscortWarn.AcceptQuest(override)
	if not EscortWarnData then return original_AcceptQuest() end
	if not EscortWarnData.settings.enabled then return original_AcceptQuest() end
	if override == true then return original_AcceptQuest() end
	if not hooked then return original_AcceptQuest() end
	if not GetGroupOrRaid() and not EscortWarnData.settings.enabledWhileSolo then return original_AcceptQuest() end
	
	local questID = GetQuestID()
	if questID and EscortWarn.EventQuests[questID] then--escort quest starting
		QuestFrame.dialog = StaticPopup_Show("CONFIRM_ESCORT_QUEST");
		acceptTime = GetTime()
		if EscortWarnData.settings.autoAnnounce then
			EscortWarn:Announce()
		end
		return
	else
		original_AcceptQuest()
		return
	end
end

--QuestFrame.Hide
--Needed for addons like Leatrix_Plus that closes the QuestFrame after accepting a quest
--Causes tainting. Shows error message INTERFACE_ACTION_BLOCKED, but quest functions still work
local original_QuestFrameHide = QuestFrame.Hide
function EscortWarn.QuestFrameHide(...)
	if acceptTime == GetTime() then
		return
	end
	return original_QuestFrameHide(...)
end

function EscortWarn:Announce()
	local channel = GetGroupOrRaid()
	if channel then
		SendChatMessage(string.format(L["ANNOUNCE_ESCORT_QUEST"],GetTitleText()), channel)
	end
end

function EscortWarn:Hook()
	if not hooked then
		_G["AcceptQuest"] = EscortWarn.AcceptQuest
		QuestFrame.Hide = EscortWarn.QuestFrameHide
		hooked = true
	end
end
function EscortWarn:UnHook()
	if hooked then 
		_G["AcceptQuest"] = original_AcceptQuest
		QuestFrame.Hide = original_QuestFrameHide
		hooked = false
	end
end