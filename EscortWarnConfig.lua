local addonName,EscortWarn = ...

local L = EscortWarn.L

EscortWarn.dataLoaded = false


local defaultSettings = {
	enabled = true,
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

EscortWarn.optionsPanel = CreateFrame( "Frame", addonName.."optionsPanel", UIParent)

EscortWarn.optionsPanel:SetScript("OnEvent",EscortWarn.OnEvent)
EscortWarn.optionsPanel:RegisterEvent("ADDON_LOADED")

local optionsPanel = EscortWarn.optionsPanel
optionsPanel.name = addonName
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addonName.. " " .. L["Settings"])

--Checkbox, Enable
local enableCheck = CreateFrame("CheckButton", nil, optionsPanel, "ChatConfigCheckButtonTemplate")
enableCheck:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
local enableLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
enableLabel:SetPoint("TOPLEFT", enableCheck, "TOPRIGHT", 4, -4)
enableLabel:SetText(L["Enabled"])

--Checkbox, Auto-Announce
local announceCheck = CreateFrame("CheckButton", nil, enableCheck, "ChatConfigCheckButtonTemplate")
announceCheck:SetPoint("TOPLEFT", enableCheck, "BOTTOMLEFT", 8, -4)
announceCheck.tooltipText = L["Automatically announce to group members when you are about to start an event quest."]
local announceLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
announceLabel:SetPoint("TOPLEFT", announceCheck, "TOPRIGHT", 4, -4)
announceLabel:SetText(L["Auto Announce"])
announceLabel.tooltipText = L["Automatically announce to group members when you are about to start an event quest."]
--Checkbox, Only in group

function optionsPanel.refresh()
	print("refresh") -- DEBUGGING DELETE ME
	if not EscortWarn.dataLoaded then return end
	enableCheck:SetChecked(settings.enabled)
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
	settings.autoAnnounce = announceCheck:GetChecked()
end

function optionsPanel.cancel()
	--print("cancel")-- DEBUGGING DELETE ME
end

function optionsPanel.default ()
	LoadDefaults()
end

InterfaceOptions_AddCategory(optionsPanel)