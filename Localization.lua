local addonName,EscortWarn = ...
EscortWarn.L = {}
local L = EscortWarn.L
local locale = GetLocale()

CONFIRM_ESCORT_QUEST = "Accepting this quest will start an event.\nDo you wish to accept?"
L["Enabled"] = VIDEO_OPTIONS_ENABLED or true
L["Settings"] = CHAT_CONFIGURATION or true
L["ANNOUNCE_ESCORT_QUEST"] = "EscortWarn - I am ready to start event quest: %s."
L["Auto Announce"] = true
L["Automatically announce to group members when you are about to start an event quest."] = true

if locale == 'ruRU' then

elseif locale == 'koKR' then

end

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end