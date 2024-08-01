local PLUGIN = PLUGIN

PLUGIN.name = "Show CID command"
PLUGIN.author = "Hern"
PLUGIN.description = "Print CID character in the chat."

ix.command.Add("ShowCID", {
	description = "@cmdShowCID",
	OnRun = function(self, client)

        if !client:Alive() then return end

		local cid = client:GetCharacter():GetInventory():HasItem("cid")

        if !cid then 
            ix.chat.Send(client, "me", "I am really sorry but I don't have any card on me...")
            return "@noCIDFound"
        end

        local character = client:GetCharacter()

        ix.chat.Send(client, "me", "displays his CID card and says, " .. client:GetCharacter():GetName() .. ", Citizen ID: " .. "#" .. cid:GetData("id") .. ".")

        local nearbyPlayers = ents.FindInSphere(client:GetPos(), 200)
        for _, v in ipairs(nearbyPlayers) do
            if v:IsPlayer() and v != client then
                character:Recognize(v:GetCharacter())
            end
        end

        local cidNameData = "CID Name : " .. cid:GetData("name") .. " | " .. "CID : " .. cid:GetData("id") .. " | " .. "ITEM ID : " .. cid.id

		ix.log.Add(client, "chat", "Shows a CID", cidNameData)
	end
})