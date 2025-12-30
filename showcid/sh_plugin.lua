local PLUGIN = PLUGIN

PLUGIN.name = "Show CID command"
PLUGIN.author = "Hern"
PLUGIN.description = "Print the CID of the character in the chat."

ix.config.Add("distanceRecognition", 200, "Recognition distance.", nil, {
	category = "Show CID command"
})

ix.config.Add("shouldRecognize", true, "Wether or not players will recognize the one who has used the command when they are in the same area.", nil, {
	category = "Show CID command"
})

ix.config.Add("canLie", true, "If players are allowed to lie about their CID numbers.", nil, {
	category = "Show CID command"
})

ix.command.Add("ShowCID", {
	description = "@cmdShowCID",
	OnRun = function(self, client)

        if !client:Alive() then return end
		
		local character = client:GetCharacter()
		local cid = character:GetInventory():HasItem("cid")
		
		if !cid then
			if ix.config.Get("canLie", true) then
				ix.chat.Send(client, "apply", cid, true)
				return "@noCIDFound"
			else
				ix.chat.Send(client, "apply", cid, false)
				return "@noCIDFound"
			end
		end
		
		if ix.config.Get("shouldRecognize", true) and !lie then 
			for _, v in ipairs(ents.FindInSphere(client:GetPos(), ix.config.Get("distanceRecognition", 200))) do --so everyone around recognize the character
				if v:IsPlayer() and v != client then
					character:Recognize(v:GetCharacter())
				end
			end
		end

		ix.chat.Send(client, "apply", cid:GetData("id"))

        local cidNameData = "CID Name : " .. cid:GetData("name") .. " | " .. "CID : " .. cid:GetData("id") .. " | " .. "ITEM ID : " .. cid.id .. " | is Lying :" .. lie
		ix.log.Add(client, "chat", "Shows a CID", cidNameData) --just a log for admins
		
	end
})

ix.chat.Register("apply", {
	format = "displays his CID card and says, name : %s, ID : %s."
	color = Color(108, 191, 163),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = false,
	OnChatAdd = function(self, speaker, cid, lie)

		local lie = lie or false

		if lie and !cid then
			chat.AddText(self.color, "** " .. string.format(self.format, speaker:Name(), tostring(math.random(00000, 99999))))
		elseif !lie and !cid then
			chat.AddText(self.color, "** " .. string.format("says my name is %s and I forgot my card...", speaker:Name()))
		else
			chat.AddText(self.color, "** " .. string.format(self.format, speaker:Name(), cid))
		end
	
	end
})