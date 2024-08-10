local PLUGIN = PLUGIN or {}

PLUGIN.name = "Sprinting Rework"
PLUGIN.description = "Prevent player from sprinting in every direction except forward."
PLUGIN.author = "heRn"

ix.config.Add("sprintRework", true, "Whether or not sprint should be activated left, right, backward on the server.", nil, {
	category = "Sprint Rework"
})

function PLUGIN:SetupMove(client, mv, cmd)

    if ! ix.config.Get("sprintRework") then return end

    if mv:KeyDown(IN_SPEED) and mv:KeyDown(IN_FORWARD) and not (mv:KeyDown(IN_MOVELEFT) or mv:KeyDown(IN_BACK) or mv:KeyDown(IN_MOVERIGHT))  then
        client:SetRunSpeed(ix.config.Get("runSpeed", 200))
    else 
        client:SetRunSpeed(ix.config.Get("walkSpeed", 130))
    end

end