local PLUGIN = PLUGIN

PLUGIN.name = "Show CID command"
PLUGIN.author = "Hern"
PLUGIN.description = "Print the CID of the character in the chat."

ix.config.Add("distanceRecognition", 200, "Default recognition distance.", nil, {
	category = "chat"
})

ix.command.Add("ShowCID", {
	description = "@cmdShowCID",
	OnRun = function(self, client)

        if !client:Alive() then return end

		local cid = client:GetCharacter():GetInventory():HasItem("cid")

        if !cid then --if the character doesn't have a cid on him and the players runs the command on his current character
            ix.chat.Send(client, "me", "I am really sorry but I don't have any card on me...")
            return "@noCIDFound"
        end

        local character = client:GetCharacter()

        ix.chat.Send(client, "me", "displays his CID card and says, " .. client:GetCharacter():GetName() .. ", Citizen ID: " .. "#" .. cid:GetData("id") .. ".")

        for _, v in ipairs(ents.FindInSphere(client:GetPos(), ix.config.Get("distanceRecognition", 200))) do --so everyone around recognize the character
            if v:IsPlayer() and v != client then
                character:Recognize(v:GetCharacter())
            end
        end

        local cidNameData = "CID Name : " .. cid:GetData("name") .. " | " .. "CID : " .. cid:GetData("id") .. " | " .. "ITEM ID : " .. cid.id

		ix.log.Add(client, "chat", "Shows a CID", cidNameData) --just a log for admins
	end
})