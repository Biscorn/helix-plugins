include("shared.lua")

function ENT:Draw()
    self:DrawModel(STUDIO_RENDER + STUDIO_STATIC_LIGHTING)
    self:DrawShadow(false)
end