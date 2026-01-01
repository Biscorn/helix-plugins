local PLUGIN = PLUGIN
PLUGIN.spawn = PLUGIN.spawn or {}
PLUGIN.spawn.position = PLUGIN.spawn.position or {}
PLUGIN.spawn.instances = PLUGIN.spawn.instances or {} --pour gérer les instances avec le think je pense et avoir une logique sympa

util.AddNetworkString("ixAirdropOpenManager")
util.AddNetworkString("ixAirdropGoto")
util.AddNetworkString("ixAirdropRemove")
util.AddNetworkString("ixAirdropSpawn")
util.AddNetworkString("ixAirdropSound")
util.AddNetworkString("ixAirdropEdit")

function PLUGIN:LoadData()
    PLUGIN.spawn.position = ix.data.Get("airdrop", {}) or self:GetData() or {}

	for _, v in pairs(PLUGIN.spawn.position) do
		v.nextSpawn = math.random(v.delay.minimum, v.delay.maximum)
	end

end

function PLUGIN:SaveData()
	self:SetData(PLUGIN.spawn.position)
    ix.data.Set("airdrop", PLUGIN.spawn.position)
end

function PLUGIN:ShouldCollide(a, b)
	if a:GetClass() == "crate" and b:GetClass() == "crate" then return false end
end

function PLUGIN:AddAirdrop(client, position, time, title, description)
    if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

	local openingTime = ix.config.Get("airdropMinimumOpeningBeep", 70)
	local id = 1

	for k, v in ipairs(PLUGIN.spawn.position or {}) do
		if v.ID == nil then
			break
		elseif v.ID <= id then
			id = v.ID + 1
		end
	end

    table.insert(PLUGIN.spawn.position, {
		["ID"] = id,
		["title"] = title,
		["delay"] = {
			minimum = time,
			maximum = time * 3
		},
		["nextSpawn"] = math.random(time, time * 3),
		["category"] = "Random",
		["openingTime"] = openingTime,
		["crateDrop"] = 1,
		["description"] = description,
		["createdAt"] = os.time(),
		["author"] = client:SteamID64(),
		["position"] = position
	})

    PLUGIN:SaveData()
end

function PLUGIN:RemoveAirdrop(client, name, id)
    if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

    for k, v in ipairs(PLUGIN.spawn.position) do
		if (v.title:lower() == name:lower()) and (tostring(v.ID) == id) then
			table.remove(PLUGIN.spawn.position, k)
            PLUGIN:SaveData()
            net.Start("ixAirdropOpenManager")
                net.WriteTable(PLUGIN.spawn.position)
            net.Send(client)
			return client:Notify("Airdrop " .. v.ID .. " - " .. v.title .. " supprimé.")
		end
	end
	return false

end

function PLUGIN:PopulateInventory(entity, inventory, maxSpace)

	if ! entity:GetClass() == "crate" then return end
	local category = inventory.category or "Base"

	local items = PLUGIN.crate.items[category].items
    local itemList = {}
    for name, infos in pairs(items) do
        table.insert(itemList, {name = name, infos = infos})
    end

	for i = #itemList, 2, -1 do
        local j = math.random(1, i)
        itemList[i], itemList[j] = itemList[j], itemList[i]
    end

	for _, itemData in ipairs(itemList) do
        local name = itemData.name
        local max = itemData.infos.max or math.random(0, 1)
        local h = ix.item.Get(itemData.name).height
        local w = ix.item.Get(itemData.name).width
        local empty = inventory:FindEmptySlot(w, h, false)

        if empty != nil then
            for i = 1, math.random(1, max) do
                inventory:Add(name, 1)
            end
        end
	end

    -- When we looped the most important items, we now populated with junk
    local junksTbl = PLUGIN.crate.items[category].junks
    local maxTries = maxSpace
    local junkNumber = #junksTbl

    while maxTries > 0 do
        local empty = inventory:FindEmptySlot(1, 1, false)

        if empty != nil then
            local junkName = junksTbl[math.random(1, junkNumber)]
            inventory:Add(junkName, 1)
        else
            break
        end

        maxTries = maxTries - 1
    end
end

function PLUGIN:Think()
	if table.IsEmpty(PLUGIN.spawn.position) or (#PLUGIN.spawn.position <= 0) then return end
	if ! self.nextPlayerCheck or (CurTime() >= self.nextPlayerCheck) then
		local var = #player.GetAll()
		if var <= ix.config.Get("airdropMinPlayer", 8) then
			self.matchPlayerNumber = false
		else
			self.matchPlayerNumber = true
		end
		self.nextPlayerCheck = CurTime() + 150
		if ! self.matchPlayerNumber then
			return
		end
	end
	if self.isDropping then
		if (CurTime() > self.nextThink) then
			self.isDropping = false
			return
		end
	else 
		if ! self.nextThink or (CurTime() >= self.nextThink and CurTime() >= (self.nextDropDelay or math.random(1200, 2400))) and (self.matchPlayerNumber or false) then --Random value to send another plane
			local time = CurTime()
			local randomDrop = PLUGIN.spawn.position[math.random(1, #PLUGIN.spawn.position)]
				
			if time >= randomDrop.nextSpawn then
				local data = {
					ID = randomDrop.ID,
					position = randomDrop.position,
					category = randomDrop.category,
					crateDrop = randomDrop.crateDrop,
					openingTime = randomDrop.openingTime
				}
				PLUGIN:Plane(data)
				data = {}
				self.nextDropDelay = CurTime() + ix.config.Get("airdropAutomaticRemoveTime", 1800)
				randomDrop.nextSpawn = CurTime() + math.random(randomDrop.delay.minimum, randomDrop.delay.maximum * 3)
				self.isDropping = true
			end
		end
		self.nextThink = CurTime() + 300 --each 5 minutes we will check to know when to create another plane
	end
end

function PLUGIN:SpawnForcePlane(client, data)
	
	if self.isDropping then 
		return client:Notify("There is currently a drop somewhere.")
	else
		PLUGIN:Plane(data)
	end
	--To do : log to add to know when someones has forced it.
	--Edit the if statement if you want to really force the airplane to spawn whenever another one is currently dropped

end

function PLUGIN:Plane(data)

	--To do : log to add, such as an airplane spawned at this coordinate...

	local id = data.ID
	local dropPos = data.position
	local category = data.category or "Random"
	local crateDropNumber = data.crateDrop or 1
	local openingTime = data.openingTime or ix.config.Get("airdropMinimumOpeningBeep", 70)

	local randomCategory = function()
		if category == "Random" then
			local totalDropRate = 0
	
			for _, crate in ipairs(PLUGIN.crate.crateType) do
				totalDropRate = totalDropRate + crate.dropRate
			end

			local cumul = 0
			local rdm = math.random(1, totalDropRate)
			for _, crate in ipairs(PLUGIN.crate.crateType) do
				cumul = cumul + crate.dropRate
				if rdm <= cumul then
					return crate.crateType
				end
			end
		end
	end

	local trace = util.TraceLine({
        start = dropPos + Vector(-5000, 0, 8000),
        endpos = dropPos + Vector(-5000, 0, 8000),
        mask = MASK_SOLID_BRUSHONLY
    })
	
	local startpos = trace.HitPos

	net.Start("ixAirdropSound")
		net.WriteString("dropsystem/planerun.wav")
	net.Broadcast()

	timer.Simple(10, function()
		local airplane = ents.Create("plane")
		airplane.dropPos = dropPos
		airplane.ID = id
		airplane.category = randomCategory() or category
		airplane.crateDropNumber = crateDropNumber or 1
		airplane.openingTime = openingTime
		airplane:SetPos(startpos)
		airplane:SetAngles(Angle(0, -90, 0)) --you might need to edit this value, keep it in mind
		--airplane:SetModelScale(10) --if you need a bigger model, depending on the selected model!
		airplane:Spawn()
	end)

end

net.Receive("ixAirdropRemove", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

	local name = net.ReadString()
    local id = net.ReadString()
	PLUGIN:RemoveAirdrop(client, name, id)
end)

net.Receive("ixAirdropGoto", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

	local position = net.ReadVector()
	client:SetPos(position)
end)

net.Receive("ixAirdropSpawn", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

	local data = net.ReadTable()

	PLUGIN:SpawnForcePlane(client, data)
end)

net.Receive("ixAirdropEdit", function(length, client)
	if !(CAMI.PlayerHasAccess(client, "Helix - Airdrop", nil)) then return end

	local tbl = net.ReadTable()

	for k, v in pairs(PLUGIN.spawn.position) do
		if (v.ID == tbl[1]) then
			v.delay.minimum = tbl[2]
			v.delay.maximum = tbl[3]
			v.openingTime = tbl[4]
			v.category = tbl[5]
			v.crateDrop  = tbl[6]
			v.description = tbl[7]
			v.nextSpawn = CurTime() + math.random(tbl[2], tbl[3])
		end
	end

	PLUGIN:SaveData()

	net.Start("ixAirdropOpenManager")
		net.WriteTable(PLUGIN.spawn.position)
	net.Send(client)

end)