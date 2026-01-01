local PLUGIN = PLUGIN

net.Receive("ixAirdropOpenManager", function()
    vgui.Create("ixAirdropOpenManager"):Populate(net.ReadTable())
end)


net.Receive("ixAirdropSound",function()
    surface.PlaySound(net.ReadString())
end)