local addonName,addon = ...
EscortWarn.optionsPanel = CreateFrame( "Frame", addonName.."optionsPanel", UIParent );
local optionsPanel = EscortWarn.optionsPanel
optionsPanel.name = addonName
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addonName.. " " .. CHAT_CONFIGURATION)

function optionsPanel.refresh()
	--print("refresh")
end

function optionsPanel.okay()
	--print("okay")
end

function optionsPanel.cancel()
	--print("cancel")
end

function optionsPanel.default ()
	--print("default")
end

InterfaceOptions_AddCategory(optionsPanel)