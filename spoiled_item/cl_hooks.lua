local PLUGIN = PLUGIN

function PLUGIN:PopulateItemTooltip(tooltip, item)
    if (item.base == "base_food") then
        local expirationtime = item:GetData("expirationDate", nil)
        local daysleft = item:DaysLeft()

        if (expirationtime != nil) then
            if daysleft < 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText("Consommer un produit périmé est dangereux pour la santé.")
                display:SetBackgroundColor(derma.GetColor("Error", tooltip))
                display:SizeToContents()
            elseif daysleft == 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText("A consommer aujourd'hui.")
                display:SetBackgroundColor(Color(100,100,100))
                display:SizeToContents()
            elseif daysleft > 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText("A consommer sous " .. (daysleft or "Inconnu") .. " jour(s).")
                display:SetBackgroundColor(Color(100,100,100))
                display:SizeToContents()
            end
        end
    end
end