---@diagnostic disable: inject-field


local PANEL = PANEL or {}

function PANEL:Init()
	
    self:SetSize(ScrH() * 0.8, ScrH() * 0.8)
	self:Center()
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)
    self:SetDraggable(false)
	self:MakePopup()
	self:SetTitle("Airdrop Manager")

    self.container = vgui.Create("DScrollPanel", self)
	self.container:Dock(FILL)

end

function PANEL:Populate(tbl)

    self.index = {}

    for index, drops in ipairs(tbl) do

        self.index = self.container:Add("DPanel")
		self.index:Dock(TOP)
		self.index:SetHeight(64)
		self.index:DockMargin(20, 20, 20, 0)
		
		self.indexcontainer = self.container:Add("DPanel")
		self.indexcontainer:Dock(TOP)
		self.indexcontainer:SetHeight(40)
		self.indexcontainer:DockMargin(20, 0, 20, 20)

		self.indexcontainerdescription = self.indexcontainer:Add("DLabel")
		self.indexcontainerdescription:SetText("Description : ")
		self.indexcontainerdescription:Dock(LEFT)
		self.indexcontainerdescription:DockMargin(10, 0, 0, 10)
		self.indexcontainerdescription:SetColor(ix.config.Get("color", Color(0,0,0)))

		self.indexcontainerdescription.label = self.indexcontainer:Add("DLabel")
		self.indexcontainerdescription.label:SetText(drops.description)
		self.indexcontainerdescription.label:Dock(FILL)
		self.indexcontainerdescription.label:DockMargin(10, 0, 0, 10)

        self.index.leftPanel = self.index:Add("DPanel")
		self.index.leftPanel:Dock(LEFT)
		self.index.leftPanel:SetSize(300, 0)

        self.index.title = self.index.leftPanel:Add("DLabel")
		self.index.title:SetText(drops.title)
		self.index.title:Dock(TOP)
		self.index.title:DockMargin(10, 10, 0, 0)
		self.index.title:SetColor(ix.config.Get("color", Color(255,255,255)))

        self.index.id = self.index.leftPanel:Add("DLabel")
		self.index.id:SetText(tostring(drops.ID))
		self.index.id:Dock(TOP)
		self.index.id:DockMargin(10, 10, 0, 10)
		self.index.id:SetColor(ix.config.Get("color", Color(0,0,0)))
        
		self.index.teleport = vgui.Create("DButton", self.index)
		self.index.teleport:Dock(RIGHT)
		self.index.teleport:SetText("Goto")
		self.index.teleport.DoClick = function()
			net.Start("ixAirdropGoto")
				net.WriteVector(drops.position)
			net.SendToServer()
		end
		--self.index.teleport.Paint = function(self, w, h)
		--end

        self.index.remove = vgui.Create("DButton", self.index)
		self.index.remove:Dock(LEFT)
		self.index.remove:SetText("Remove")
		self.index.remove.DoClick = function()
			net.Start("ixAirdropRemove")
				net.WriteString(drops.title)
                net.WriteString(tostring(drops.ID))
			net.SendToServer()
            self:Remove()
		end

		self.index.spawn = vgui.Create("DButton", self.index)
		self.index.spawn:Dock(LEFT)
		self.index.spawn:SetText("Spawn")
		self.index.spawn.DoClick = function()
			net.Start("ixAirdropSpawn")
				net.WriteTable(drops)
			net.SendToServer()
		end

		self.index.editing = vgui.Create("DButton", self.index)
		self.index.editing:Dock(LEFT)
		self.index.editing:SetText("Edit")
		self.index.editing.DoClick = function()
			self:SetVisible(false)
			self.edit = vgui.Create("ixAirdropEditSpawn")
			self.edit:DropEdit(drops)
			self.edit.OnClose = function()
				self:SetVisible(true)
			end
		end


    end

end

vgui.Register("ixAirdropOpenManager", PANEL, "DFrame")
