ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Caisse larguée"
ENT.Author = "heRn"
ENT.Category = "Largage - Apocalypse"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true
ENT.PhysgunDisabled = false --Put this in true if you need, with true bool you will be able to take it with your physgun (if you have the right ofc)
ENT.DisableDuplicator = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Ground")
end