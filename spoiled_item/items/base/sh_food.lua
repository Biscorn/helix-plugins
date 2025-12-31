local PLUGIN = PLUGIN

ITEM.name = "Food Base"
ITEM.category = "Food"
--ITEM.description = [[Will help you to gain %s satiety and %s hydration.]] --quoted, unquote if you need to apply this to whole base_food items

if (CLIENT) then
	function ITEM:GetDescription()
		if self.description then
			return Format(self.description, self.satiety or 0, self.hydration or 0)
		end
	end
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("spawnedDateIX", ix.date.Get():normalize())
	item:SetData("expirationDate", PLUGIN:SetDays(item.expireDay))
end

function ITEM:GetExpirationDate()
	local data = ix.date.Construct(self:GetData("expirationDate")):normalize()
	return data
end

function ITEM:DaysLeft()
	local expirationDate = ix.date.Construct(self:GetData("expirationDate")):normalize()
	local getDate = ix.date.Get():normalize()

	local expireSerialized = ix.date.GetSerialized(expirationDate)
	local currentSerialized = ix.date.GetSerialized(getDate)

	local calculus = tonumber(expireSerialized[1]) - tonumber(currentSerialized[1])
	return calculus
end

ITEM.functions.Consume = {
	name = "Consommer",
	tip = "eatTip",
	icon = "icon16/world.png",
	OnRun = function(item)
		local client = item.player

		ply:SetAction(item.message, item.time, true, function()
			item:Remove()
			ply:SetHealth(ply:Health() + 10) --An example of what you can do - very simple for the demo
		end)

	end
}