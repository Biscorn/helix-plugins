AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()

    self:SetModel("models/custom/c17_static_closed.mdl") --models/custom/c17_static_open.mdl

    self:PhysicsInit(SOLID_OBB_YAW)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:StartMotionController()

    local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
        phys:EnableGravity(false)
	    self.physic = phys
	end

end

function ENT:Think()
    if IsValid(self) then
        timer.Simple(1, function()
            if IsValid(self) then  
                util.ScreenShake(self:GetPos(), 3, 4, 1, 20000)
            else
                return
            end
        end)
    end
end

function ENT:PhysicsSimulate(phys, delta)

    if ! self.hasBeenDropped then

        local diff = self.dropPos - self:GetPos()
        
        local horizontalDistance = Vector(diff.x, 0, 0):Length()

        if horizontalDistance < 50 then
            self:CrateDrop(self:GetPos())
        end
    
    end
    
    if self.hasBeenDropped and ! self:IsInWorld() then
        self:Remove()
    end

    return Vector(0, 0, 0), ((-self:GetRight() * 1000) * 3) - (self:GetVelocity() * 5), SIM_GLOBAL_ACCELERATION

end

function ENT:CrateDrop(offset)

    local crateCategory = self.category
    local openingTime = self.openingTime
    local smokeColor

    for _, crateData in pairs(PLUGIN.crate.crateType) do
        if crateData.crateType == crateCategory then
            smokeColor = crateData.smokeColor
            break
        end
    end

    local offset = Vector(offset.x,offset.y,offset.z-150) --just in case, the crate will be spawned a little further down

    local currentIndex = 1
    local isSpawning = false
    
    local function SpawnNextCrate(seed)
        if currentIndex > (self.crateDropNumber or 1) then return end  
        
        if isSpawning then return end


        timer.Create("ixAirdropping"..currentIndex, 2, self.crateDropNumber, function()
            local dist
            seed = (seed or 0) + math.random(150, 350)
            if currentIndex == 1 then
                dist = offset --the first is alway the starter
            else
                dist = offset + Vector(seed * currentIndex, 0, 0) --the next cases will be randomly dropped at different distance
            end
            local drop = ents.Create("crate")
            drop:SetPos(dist)
            drop.flareColor = smokeColor
            drop.category = crateCategory
            drop.openingTime = openingTime
            drop:Spawn()
    
            self.hasBeenDropped = true
            
            currentIndex = currentIndex + 1
            isSpawning = true
    
            --to a maximum of 3 crate when dropped
            SpawnNextCrate(seed)
        end)
    end
    
    -- recursive function, will be repeated 3 times maximum 
    SpawnNextCrate()

end