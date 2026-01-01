local PLUGIN = PLUGIN

PLUGIN.name = "Airdrop"
PLUGIN.author = "Hern"
PLUGIN.description = "Some crate will drop from the sky to fall to the ground with random items inside."

CAMI.RegisterPrivilege({
	Name = "Helix - Airdrop",
	MinAccess = "superadmin"
})

--More config should be made to have a real control over the plugin itself it, plus a langage support

ix.config.Add("airdropMinimumDelay", 300, "The minimum airdrop delay.", nil, {
	data = {min = 300, max = 3600},
	category = "Airdrop"
})

ix.config.Add("airdropMinimumOpeningBeep", 70, "The minimum aidrop beep time when a crate has been opened.", nil, {
	data = {min = 5, max = 600},
	category = "Airdrop"
})

ix.config.Add("airdropTimeRemoveCrateOpened", 300, "Time before a crate gets removed after it has been opened.", nil, {
	data = {min = 300, max = 3600},
	category = "Airdrop"
})

ix.config.Add("airdropAutomaticRemoveTime", 1800, "Time before a crate gets removed automatically.", nil, {
	data = {min = 1800, max = 3600},
	category = "Airdrop"
})

ix.config.Add("airdropMinPlayer", 8, "Minimum players for the airdrop to activate.", nil, {
	data = {min = 2, max = 20},
	category = "Airdrop"
})

ix.util.Include("sh_commands.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_tables.lua")