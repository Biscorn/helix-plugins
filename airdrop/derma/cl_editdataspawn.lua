local PLUGIN = PLUGIN
local PANEL = PANEL or {}

function PANEL:Init()
    self:SetSize(ScrH() * 0.5, ScrW() * 0.3)
	self:Center()
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)
    self:SetDraggable(false)
	self:MakePopup()

    --self.container = vgui.Create("DFrame", self)
	--self.container:Dock(FILL)

end

function PANEL:DropEdit(drop)

    self:SetTitle("Editing - " .. drop.title .. " - ID : " .. drop.ID)

    local maxdelay
    local mindelay

    self.maxdelay = self:Add("DPanel")
	self.maxdelay:Dock(TOP)
	self.maxdelay:SetHeight(40)
	self.maxdelay:DockMargin(10, 10, 10, 10)

    self.maxdelay.label = self.maxdelay:Add("DLabel")
	self.maxdelay.label:SetWide(80)
	self.maxdelay.label:DockMargin(20, 0, 0, 0)
	self.maxdelay.label:SetText("Max delay : ")
	self.maxdelay.label:Dock(LEFT)

    self.maxdelay.input = self.maxdelay:Add("DTextEntry")
    self.maxdelay.input:SetNumeric(true)
	self.maxdelay.input:SetText(drop.delay.maximum)
	self.maxdelay.input:Dock(FILL)

    self.maxdelay.conversion = self.maxdelay:Add("DLabel")
    self.maxdelay.input.OnChange = function()
        if ! self.maxdelay.input:GetInt() then return self.maxdelay.conversion:SetText("") end
        maxdelay = self.maxdelay.input:GetInt()/60
        local seconds = self.maxdelay.input:GetInt() % 60
        self.maxdelay.conversion:SetText(string.format("= %d mins, %d secs", maxdelay, seconds))
    end
    self.maxdelay.conversion:SetText(string.format("= %d mins, %d secs", math.floor((self.maxdelay.input:GetInt()/60)), self.maxdelay.input:GetInt() % 60))
    self.maxdelay.conversion:SetWide(100)
    self.maxdelay.conversion:SetContentAlignment(5)
    self.maxdelay.conversion:DockMargin(10, 10, 10, 10)
    self.maxdelay.conversion:Dock(RIGHT)

    self.mindelay = self:Add("DPanel")
	self.mindelay:Dock(TOP)
	self.mindelay:SetHeight(40)
	self.mindelay:DockMargin(10, 10, 10, 10)

    self.mindelay.label = self.mindelay:Add("DLabel")
	self.mindelay.label:SetWide(80)
	self.mindelay.label:DockMargin(20, 0, 0, 0)
	self.mindelay.label:SetText("Min delay : ")
	self.mindelay.label:Dock(LEFT)

    self.mindelay.input = self.mindelay:Add("DTextEntry")
    self.mindelay.input:SetNumeric(true)
	self.mindelay.input:SetText(drop.delay.minimum)
	self.mindelay.input:Dock(FILL)

    self.mindelay.conversion = self.mindelay:Add("DLabel")
    self.mindelay.input.OnChange = function()
        if ! self.mindelay.input:GetInt() then return self.mindelay.conversion:SetText("") end
        mindelay = self.mindelay.input:GetInt()/60
        local seconds = self.mindelay.input:GetInt() % 60
        self.mindelay.conversion:SetText(string.format("= %d mins, %d secs", mindelay, seconds))
    end
    self.mindelay.conversion:SetText(string.format("= %d mins, %d secs", math.floor((self.mindelay.input:GetInt()/60)), self.mindelay.input:GetInt() % 60))
    self.mindelay.conversion:SetWide(100)
    self.mindelay.conversion:SetContentAlignment(5)
    self.mindelay.conversion:DockMargin(10, 10, 10, 10)
    self.mindelay.conversion:Dock(RIGHT)

    self.category = self:Add("DPanel")
	self.category:Dock(TOP)
	self.category:SetHeight(60)
	self.category:DockMargin(10, 10, 10, 10)

    self.category.label = self.category:Add("DLabel")
	self.category.label:SetWide(200)
	self.category.label:DockMargin(20, 0, 0, 0)
	self.category.label:SetText("Current category : " .. (drop.category))
	self.category.label:Dock(LEFT)

    self.category.choose = self.category:Add("DComboBox")
	self.category.choose:SetValue(drop.category)
    self.category.choose:AddChoice("Random")
    for _, crateData in pairs(PLUGIN.crate.crateType) do
        local var = self.category.choose:AddChoice(crateData.crateType)
        if drop.category == "Random" then
            self.category.choose:ChooseOptionID(1)
        elseif drop.category == crateData.crateType then
            self.category.choose:ChooseOptionID(var)
        end
    end
	self.category.choose:Dock(FILL)

    self.cratenumber = self:Add("DPanel")
	self.cratenumber:Dock(TOP)
	self.cratenumber:SetHeight(60)
	self.cratenumber:DockMargin(10, 10, 10, 10)

    self.cratenumber.label = self.cratenumber:Add("DLabel")
	self.cratenumber.label:SetWide(200)
	self.cratenumber.label:DockMargin(20, 0, 0, 0)
	self.cratenumber.label:SetText("Current crate drop : " .. (drop.crateDrop))
	self.cratenumber.label:Dock(LEFT)

    self.cratenumber.choose = self.cratenumber:Add("DComboBox")
	self.cratenumber.choose:SetText((tostring(drop.crateDrop)))
    for i = 1, 3 do
        self.cratenumber.choose:AddChoice(tostring(i))
        if i == drop.crateDrop then
            self.cratenumber.choose:ChooseOption(tostring(drop.crateDrop), i)
        end
    end
	self.cratenumber.choose:Dock(FILL)

    self.cratetimer = self:Add("DPanel")
	self.cratetimer:Dock(TOP)
	self.cratetimer:SetHeight(40)
	self.cratetimer:DockMargin(10, 10, 10, 10)

    self.cratetimer.label = self.cratetimer:Add("DLabel")
	self.cratetimer.label:SetWide(200)
	self.cratetimer.label:DockMargin(20, 0, 0, 0)
	self.cratetimer.label:SetText("Current opening time : " .. (drop.openingTime or 70))
	self.cratetimer.label:Dock(LEFT)

    self.cratetimer.input = self.cratetimer:Add("DTextEntry")
    self.cratetimer.input:SetNumeric(true)
	self.cratetimer.input:SetText(drop.openingTime)
	self.cratetimer.input:Dock(FILL)

    self.cratedescription = self:Add("DPanel")
	self.cratedescription:Dock(TOP)
	self.cratedescription:SetHeight(40)
	self.cratedescription:DockMargin(10, 10, 10, 10)

    self.cratedescription.input = self.cratedescription:Add("DTextEntry")
	self.cratedescription.input:SetText(drop.description)
	self.cratedescription.input:Dock(FILL)

    self.buttonsave = self:Add("DPanel")
	self.buttonsave:Dock(BOTTOM)
    
    self.buttonsave.save = self.buttonsave:Add("DButton")
	self.buttonsave.save:SetText("Save data")
	self.buttonsave.save:Dock(FILL)
    self.buttonsave.save.DoClick = function()

        if tonumber(self.mindelay.input:GetValue()) < ix.config.Get("airdropMinimumDelay", 300) then
            self.mindelay.input:SetValue(tonumber(ix.config.Get("airdropMinimumDelay", 300)))
            LocalPlayer():Notify("Minimum delay setup automatically to " .. ix.config.Get("airdropMinimumDelay", 300))
        end

        if tonumber(self.mindelay.input:GetValue()) > ix.config.stored["airdropMinimumDelay"].data.data.max then
            self.mindelay.input:SetValue(tonumber(ix.config.stored["airdropMinimumDelay"].data.data.max))
        end

        if tonumber(self.maxdelay.input:GetValue()) <= tonumber(self.mindelay.input:GetValue()) then
            return LocalPlayer():NotifyLocalized("Max delay <= Minimum delay")
        end

        if tonumber(self.cratetimer.input:GetValue()) < ix.config.Get("airdropMinimumOpeningBeep", 70) then
            self.cratetimer.input:SetValue(tonumber(ix.config.Get("airdropMinimumOpeningBeep", 70)))
        end

        if tonumber(self.cratetimer.input:GetValue()) > ix.config.stored["airdropMinimumOpeningBeep"].data.data.max then
            self.cratetimer.input:SetValue(tonumber(ix.config.stored["airdropMinimumOpeningBeep"].data.data.max))
        end

        if #self.cratedescription.input:GetValue() < 8 or #self.cratedescription.input:GetValue() > 200 then
            return LocalPlayer():NotifyLocalized("Description < 8 char ou > 200 char")
        end

		local tbl = {
			drop.ID,
			tonumber(self.mindelay.input:GetValue()),
            tonumber(self.maxdelay.input:GetValue()),
            tonumber(self.cratetimer.input:GetValue()),
			self.category.choose:GetSelected(),
            tonumber(self.cratenumber.choose:GetSelected()),
            self.cratedescription.input:GetValue()
		}
		net.Start("ixAirdropEdit")
			net.WriteTable(tbl)
		net.SendToServer()
        self:Remove()

	end

end

vgui.Register("ixAirdropEditSpawn", PANEL, "DFrame")
