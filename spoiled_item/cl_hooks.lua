local PLUGIN = PLUGIN

function PLUGIN:PopulateItemTooltip(tooltip, item)
    if (item.base == "base_food") then
        local expirationtime = item:GetData("expirationDate", nil)
        local daysleft = item:DaysLeft()

        if (expirationtime != nil) then
            if daysleft < 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText(L"@consumeDangerousSpoiled")
                display:SetBackgroundColor(derma.GetColor("Error", tooltip))
                display:SizeToContents()
            elseif daysleft == 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText(L"@consumeTodaySpoiled")
                display:SetBackgroundColor(Color(100,100,100))
                display:SizeToContents()
            elseif daysleft > 0 then
                local display = tooltip:AddRow("spoiledFood")
                display:SetText(string.format(L("@consumptionLeftSpoiled"), (daysleft or "@unknownSpoiled")))
                display:SetBackgroundColor(Color(100,100,100))
                display:SizeToContents()
            end
        end
    end
end