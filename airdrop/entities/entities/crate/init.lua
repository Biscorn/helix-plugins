AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local PLUGIN = PLUGIN

local function createInv(entity)

    local w, h = math.random(3, 5), math.random(4, 8)
    local crate = ix.inventory.Create(w, h, os.time())
    crate.noSave = true
    crate.category = entity.category
    entity.ixInventory = crate
    PLUGIN:PopulateInventory(entity, crate, w*h)

end

local function dropFlare(parent)

    local flareColor = parent.flareColor

    local entity = ents.Create("ent_jack_gmod_ezsignalnade")
    entity:SetParent(parent)
    entity:SetPos(parent:GetPos() + Vector(0, 0, 10))
    parent.flare = entity
    entity:Spawn()
    entity:SetColor( flareColor )
    entity:SetRenderMode(RENDERMODE_TRANSCOLOR)
    entity:SetCollisionGroup(parent:GetCollisionGroup())
    entity:GetPhysicsObject():EnableMotion(false)

end

local function SetCustomSkin(entity)
    for _, v in pairs(PLUGIN.crate.crateType) do
        if v.crateType == entity.category then
            entity:SetSkin(v.skin)
        end
    end
end

function ENT:Initialize()

    self:SetModel("models/domainecontamine/crate/airdrop_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetRenderMode(RENDERMODE_NORMAL)
    createInv(self)
    dropFlare(self)
    SetCustomSkin(self)
    self.automaticRemove = CurTime() + ix.config.Get("airdropAutomaticRemoveTime", 1800)

	local phys = self:GetPhysicsObject()
		
	if IsValid(phys) then
		phys:Wake()
        phys:SetMass(8)
		self.physic = phys
	end
end

function ENT:Think()

    if CurTime() > self.automaticRemove then
        self:Remove()
        return
    end

    if (CurTime() > (self.timeBeforeRemoving or 0)) and self:GetGround() and self.canBeOpened then 
        self:Remove()
        return
    end
    
    if ! self:GetGround() then
        local trace = util.TraceLine( {
		    start = self:GetPos(),
		    endpos = self:GetPos() - Vector(0, 0, 400)
		} )

        local Cur = math.floor(CurTime()) + 2

        if trace.HitWorld == true then
            self:SetCollisionGroup(COLLISION_GROUP_NONE)
            self:SetGround(true)
            self.flare:Detonate()
            self.flare.FuelLeft = 1000
            self:SetBodygroup(1, 1)
            self.physic:SetMass(60)
            timer.Simple(1, function()
                self.physic:SetMass(1000)
            end )
        end

        if self:GetGround() and Cur < math.floor(CurTime()) then
            self.physic:EnableMotion(false)
            self.physic:Wake()
        end

    end

    if IsValid(self.flare) and self:GetGround() then
        self.flare.FuelLeft = self.flare.FuelLeft - 0.5
    end 

end

function ENT:Use(act)

    if ! self:GetGround() then return end
    
    local cur = math.Round(CurTime())

    self.canBeOpened = self.canBeOpened or false

    if (self.nextOpen or 0) < cur then

        if ! self.ActivatedTimer then
            self.ActivatedTimer = cur + self.openingTime
            self.canBeOpened = false
            self:BoxTriggered()
            --act:NotifyLocalized("Case activated.") --not really useful, but depends
        end

        if self.ActivatedTimer < cur then
            self.ActivatedTimer = 0
            self.canBeOpened = true
            self.timeBeforeRemoving = CurTime() + ix.config.Get("airdropTimeRemoveCrateOpened", 300)
            if self.ixInventory and !ix.storage.InUse(self.ixInventory) then
                local w, h = self.ixInventory:GetSize()
                ix.storage.Open(act, self.ixInventory, {
                    entity = self,
                    name = "Largage",
                    searchText = "Inspection de la caisse",
                    searchTime = (w+h)/2,
                    OnPlayerOpen = function()
                        act:SetSetActionPlayerStatus(true, true)
                    end,
                    OnPlayerClose = function()
                        act:SetSetActionPlayerStatus(false, false)
                    end
                    })
                return false
            end
        end

        self.nextOpen = cur + 3

    end

end

function ENT:BoxTriggered()

    local cur = math.Round(CurTime())
    local time = self.ActivatedTimer - cur

    if time <= 0 then return end

    local timerName = "OpeningCaseTriggerCrate"..self:EntIndex()

    timer.Create(timerName, 1, time, function()
        if IsValid(self) then
            self:EmitSound("dropsystem/beepsound.wav")
        else
            timer.Remove(timerName)
        end
    end)

end