local PLUGIN = PLUGIN

ix.command.Add("AirdropSpawnerAdd", {
	description = "@cmdAirdropSpawnerAdd",
	privilege = "Airdrop",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number,
		ix.type.text
	},
	OnRun = function(self, client, title, delay, description)

		if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

		local delay = delay
		local location = client:GetEyeTrace().HitPos

		if #description > 200 or #description < 8 then
			return client:NotifyLocalized("Description invalide.")
		end

		if delay < ix.config.Get("airdropMinimumDelay", 300) then 
			client:NotifyLocalized("Valeur minimum mise à " .. ix.config.Get("airdropMinimumDelay", 300) .. " secondes.")
			delay = ix.config.Get("airdropMinimumDelay", 300)
		end

		PLUGIN:AddAirdrop(client, location, delay, title, description)

		client:NotifyLocalized("Aidrop spawn added.")
		
	end
})

ix.command.Add("AirdropManager", {
	description = "@cmdAirdropManager",
	privilege = "Airdrop",
	superAdminOnly = true,
	OnRun = function(self, client)

		if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end
		net.Start("ixAirdropOpenManager")
			net.WriteTable(PLUGIN.spawn.position)
		net.Send(client)
	end
})

ix.command.Add("AirdropRemoveCrate", {
	description = "@cmdAirdropManager",
	privilege = "Airdrop",
	superAdminOnly = true,
	OnRun = function(self, client)

		if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

		for k, v in ipairs(ents.GetAll()) do
			if v:GetClass() == "crate" then
				v:Remove()
			end
		end
	end
})