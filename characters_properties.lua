local PLUGIN = PLUGIN

PLUGIN.name = "Property System"
PLUGIN.author = "Hern"
PLUGIN.description = "Property system for admin that can be used on character."

-- Context Menu for Admin
CAMI.RegisterPrivilege({
	Name = "Helix - Admin Context Options",
	MinAccess = "admin"
})

properties.Add("ixViewPlayerProperty", {
	MenuLabel = "#View Player",
	Order = 1,
	MenuIcon = "icon16/user.png",
	Format = "%s | %s\nHP: %s\nArmor: %s\nUsergroup: %s",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:NotifyLocalized(string.format(self.Format, entity:Nick(), entity:SteamID(), entity:Health(), entity:Armor(), entity:GetUserGroup()))
		end
	end
})

properties.Add("ixSetHealthProperty", {
	MenuLabel = "#Set Health",
	Order = 2,
	MenuIcon = "icon16/heart.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for i = 100, 0, -25 do
			local option = submenu:AddOption(i, function() self:SetHealth( ent, i ) end )
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetHealth = function(self, target, health)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(health, 8)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local health = net.ReadUInt(8)

			entity:SetHealth(health)
			if (entity:Health() == 0) then entity:Kill() end
		end
	end
})

properties.Add("ixSetArmorProperty", {
	MenuLabel = "#Set Armor",
	Order = 3,
	MenuIcon = "icon16/shield.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for i = 100, 0, -25 do
			local option = submenu:AddOption(i, function() self:SetArmor( ent, i ) end )
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetArmor = function(self, target, armor)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(armor, 8)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local armor = net.ReadUInt(8)

			entity:SetArmor(armor)
		end
	end
})

properties.Add("ixSetDescriptionProperty", {
	MenuLabel = "#Edit Description",
	Order = 4,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:RequestString("Set the character's description.", "New Description", function(text)
				entity:GetCharacter():SetDescription(text)
			end, entity:GetCharacter():GetDescription())
		end
	end
})

properties.Add("ixSetFactionProperty", {
	MenuLabel = "#Set Faction",
	Order = 11,
	MenuIcon = "icon16/user_go.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for k, v in pairs(ix.faction.indices) do
			local option = submenu:AddOption(v.name, function() self:SetFaction( ent, v.name ) end )
			if v.isDefault == false then
				option:SetIcon("icon16/bullet_orange.png")
			else
				option:SetIcon("icon16/bullet_green.png")
			end
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetFaction = function(self, target, faction)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteString(faction)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local name = net.ReadString()
			local faction
			
			for _, v in pairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name)) then
					faction = v

					break
				end
			end

			local index = ix.faction.GetIndex(faction.uniqueID)
			local char = entity:GetCharacter()

			char:SetFaction(index)

			if (faction.OnTransferred) then
				faction:OnTransferred(char)
			end

			for _, v in ipairs(player.GetAll()) do
				if (CAMI.PlayerHasAccess(v, "Helix - Admin Context Options", nil) or v == entity) then
					v:NotifyLocalized("cChangeFaction", client:GetName(), entity:GetName(), L(faction.name, v))
				end
			end		
		end
	end
})

properties.Add("ixSetClassProperty", {
	MenuLabel = "#Set Class",
	Order = 13,
	MenuIcon = "icon16/user_go.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for k, v in pairs(ix.class.list) do
			if v.faction == target:GetCharacter():GetFaction() then
				local option = submenu:AddOption(v.name, function() self:SetClass( ent, v.index, v.name ) end )
				if v.isDefault == false then
					option:SetIcon("icon16/bullet_orange.png")
				else
					option:SetIcon("icon16/bullet_green.png")
				end
			end
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetClass = function(self, target, class, classname)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteString(class)
			net.WriteString(classname)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local class = net.ReadString()
			local classname = net.ReadString()
			local char = entity:GetCharacter()

			local class_table = ix.class.list

			class_table.CanSwitchTo = function(client)
				if classname == "Elite Metropolice" then
					return print("yes")
				end
			end

			char:JoinClass(tonumber(class))

			if (class.OnSet) then
				class:OnSet(char)
			end

			for _, v in ipairs(player.GetAll()) do
				if (CAMI.PlayerHasAccess(v, "Helix - Admin Context Options", nil) or v == entity) then
					v:NotifyLocalized("cChangeFaction", client:GetName(), entity:GetName(), class.name, v)
				end
			end		
		end
	end
})

properties.Add("ixViewInventoryProperty", {
	MenuLabel = "#View Inventory",
	Order = 14,
	MenuIcon = "icon16/briefcase.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer() and entity != client
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local target = net.ReadEntity()
			local name = hook.Run("GetDisplayedName", target) or target:Name()
			local inventory = target:GetCharacter():GetInventory()

			ix.storage.Open(client, inventory, {
				entity = target,
				name = name
			})
		end
	end
})