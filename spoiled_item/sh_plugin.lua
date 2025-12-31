
local PLUGIN = PLUGIN

PLUGIN.name = "Spoiled items"
PLUGIN.author = "Hern"
PLUGIN.description = "Item that can be marked as spoiled."

ix.util.Include("cl_hooks.lua")

function PLUGIN:SetDays(days)
    local currentDate = ix.date.Get():copy():adddays(days)
    return currentDate
end