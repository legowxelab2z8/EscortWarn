local addonName,EscortWarn = ...
local L = EscortWarn.L

EscortWarn.dataLoaded = false

local defaultSettings = {
	enabled = true,
	enabledWhileSolo = false,
	autoAnnounce = true,
}

local settings

local function LoadDefaults()
	print("Loading Defaults") -- DEBUGGING DELETE ME
	if not EscortWarnData then EscortWarnData = {} end
	EscortWarnData.settings = CopyTable(defaultSettings)
	settings = EscortWarnData.settings
end

function EscortWarn:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		if ... == addonName then
			if not EscortWarnData or not EscortWarnData.settings then LoadDefaults() end
			settings = EscortWarnData.settings

			if settings.enabled then EscortWarn:Hook() end

			EscortWarn.dataLoaded = true
		end
	end
end

EscortWarn.optionsPanel = CreateFrame("Frame", addonName.."optionsPanel", UIParent)

EscortWarn.optionsPanel:SetScript("OnEvent",EscortWarn.OnEvent)
EscortWarn.optionsPanel:RegisterEvent("ADDON_LOADED")

local optionsPanel = EscortWarn.optionsPanel
optionsPanel.name = addonName
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addonName.. " " .. L["Settings"])


--Checkbox, Enable
local enableCheck = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
local thisOption = enableCheck
thisOption:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
thisOption.Text:SetText(L["Enabled"])
local lastOption = thisOption

--Checkbox, Enabled While Solo
local enableWhileSolo = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
thisOption = enableWhileSolo
thisOption:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 10, 0)
thisOption.Text:SetText(L["Enabled While Solo"])
thisOption.tooltipText = L["Show the prompt when starting an event quest even when you are not in a group"]
lastOption = thisOption

--Checkbox, Auto-Announce
local announceCheck = CreateFrame("CheckButton", nil, enableCheck, "InterfaceOptionsCheckButtonTemplate")
thisOption = announceCheck
thisOption:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, 0)
thisOption.tooltipText = L["Automatically announce to group members when you are about to start an event quest."]
thisOption.Text:SetText(L["Auto Announce"])
lastOption = thisOption


function optionsPanel.refresh()
	--print("refresh") -- DEBUGGING DELETE ME
	if not EscortWarn.dataLoaded then return end
	enableCheck:SetChecked(settings.enabled)
	enableWhileSolo:SetChecked(settings.enabledWhileSolo)
	announceCheck:SetChecked(settings.autoAnnounce)
end

function optionsPanel.okay()
	--print("okay")-- DEBUGGING DELETE ME
	if settings.enabled ~= enableCheck:GetChecked() then
		if enableCheck:GetChecked() then
			EscortWarn:Hook()
		else
			EscortWarn:UnHook()
		end
	end

	settings.enabled = enableCheck:GetChecked()
	settings.enabledWhileSolo = enableWhileSolo:GetChecked()
	settings.autoAnnounce = announceCheck:GetChecked()
end

function optionsPanel.cancel()
	--print("cancel")-- DEBUGGING DELETE ME
end

function optionsPanel.default ()
	LoadDefaults()
end

InterfaceOptions_AddCategory(optionsPanel)