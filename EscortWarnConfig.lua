local addonName,EscortWarn = ...

local L = EscortWarn.L

local defaultSettings = {
	enabled = true,
}

local function LoadDefaults()
	EscortWarn.settings = defaultSettings
end

if not EscortWarn.settings then LoadDefaults() end

local settings = EscortWarn.settings


EscortWarn.optionsPanel = CreateFrame( "Frame", addonName.."optionsPanel", UIParent)
local optionsPanel = EscortWarn.optionsPanel
optionsPanel.name = addonName
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addonName.. " " .. L["Settings"])

--Checkbox, Enable
local enableCheck = CreateFrame("CheckButton", nil, optionsPanel, "ChatConfigCheckButtonTemplate")
enableCheck:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
enableCheck:Show()
local enableLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
enableLabel:SetPoint("TOPLEFT", enableCheck, "TOPRIGHT", 4, -4)
enableLabel:SetText(L["Enabled"])
--Checkbox, Auto-Announce
--Checkbox, Only in group

function optionsPanel.refresh()
	--print("refresh")
	enableCheck:SetChecked(settings.enabled)
end

function optionsPanel.okay()
	--print("okay")
	if settings.enabled ~= enableCheck:GetChecked() then
		if enableCheck:GetChecked() then
			EscortWarn:Hook()
		else
			EscortWarn:UnHook()
		end

	end
	settings.enabled = enableCheck:GetChecked()

	
end

function optionsPanel.cancel()
	--print("cancel")
end

function optionsPanel.default ()
	--print("default")
	LoadDefaults()
end

InterfaceOptions_AddCategory(optionsPanel)