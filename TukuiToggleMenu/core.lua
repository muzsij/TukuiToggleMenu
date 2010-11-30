-- By Foof & Hydra at Tukui.org
-- modified by Gorlasch
-- modified by HyPeRnIcS

local buttonwidth = TukuiDB.Scale(TukuiCF.togglemenu.buttonwidth)
local buttonheight = TukuiDB.Scale(TukuiCF.togglemenu.buttonheight)
local defaultframelevel = 0

local addons = {
	["Recount"] = function()
		ToggleFrame(Recount.MainWindow)
		Recount.RefreshMainWindow()
	end,
	
	["Skada"] = function()
		Skada:ToggleWindow()
	end,
	
	["AtlasLoot"] = function()
		ToggleFrame(AtlasLootDefaultFrame)
	end,
	
	["Omen"] = function()
		ToggleFrame(Omen.Anchor)
	end,
	
	["DXE"] = function()
		_G.DXE:ToggleConfig()
	end,
	
	["DBM-Core"] = function()
		DBM:LoadGUI()
	end,
	
	["TinyDPS"] = function()
		ToggleFrame(tdpsFrame)
	end,
	
	["Tukui_ConfigUI"] = function()
		if not TukuiConfigUI or not TukuiConfigUI:IsShown() then
			CreateTukuiConfigUI()
		else
			TukuiConfigUI:Hide()
		end
	end,

	["Panda"] = function()
		ToggleFrame(PandaPanel)
	end,

	["ScrollMaster"] = function()
		LibStub("AceAddon-3.0"):GetAddon("ScrollMaster").GUI:OpenFrame(1)
	end,
}

local MenuBG = CreateFrame("Frame", "TTMenuBackground", UIParent)
if TukuiCF.togglemenu.positionnexttoMinimap == true then
	TukuiDB.CreatePanel(MenuBG, buttonwidth + TukuiDB.Scale(6), buttonheight * 5 + TukuiDB.Scale(18), "TOPRIGHT", TukuiMinimap, "TOPLEFT", TukuiDB.Scale(-3), 0)
else
	TukuiDB.CreatePanel(MenuBG, buttonwidth + TukuiDB.Scale(6), buttonheight * 5 + TukuiDB.Scale(18), "TOP", UIParent, "TOP", 0, TukuiDB.Scale(-15))
end
MenuBG:SetFrameLevel(defaultframelevel+0)
MenuBG:SetFrameStrata("HIGH")
MenuBG:Hide()
 
local AddonBG = CreateFrame("Frame", "TTMenuAddOnBackground", UIParent)
TukuiDB.CreatePanel(AddonBG, buttonwidth + TukuiDB.Scale(6), 1, "TOP", MenuBG, "TOP", 0, 0)
AddonBG:SetFrameLevel(defaultframelevel+0)
AddonBG:SetFrameStrata("HIGH")
AddonBG:Hide()

function ToggleMenu_Toggle()
	ToggleFrame(TTMenuBackground)
	if TTMenuAddOnBackground:IsShown() then TTMenuAddOnBackground:Hide() end
end

-- Integrate the menu into TukuiRightCube
if TukuiCubeRight and TukuiCF.togglemenu.useTukuiCubeRight == true then
	local ToggleCube = CreateFrame("Frame", "TukuiToggleCube", UIParent)
	TukuiDB.CreatePanel(ToggleCube, TukuiCubeRight:GetWidth(), TukuiCubeRight:GetHeight(), "CENTER", TukuiCubeRight, "CENTER", 0, 0)
	ToggleCube:SetFrameLevel(TukuiCubeRight:GetFrameLevel() + 1)
	ToggleCube:EnableMouse(true)
	ToggleCube:SetScript("OnMouseDown", function() ToggleMenu_Toggle() end)
end

-- Integrate the menu into the panel
if TukuiCF.togglemenu.useDataText and TukuiCF.togglemenu.useDataText > 0 then
	local DataText = CreateFrame("Frame")
	DataText:EnableMouse(true)
	DataText:SetFrameStrata("BACKGROUND")
	DataText:SetFrameLevel(3)
	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(TukuiCF.media.font, TukuiCF["datatext"].fontsize)
	TukuiDB.PP(TukuiCF.togglemenu.useDataText, Text)
	Text:SetText(TukuiCF.togglemenu.DataTextTitle)
	DataText:SetAllPoints(Text)
	DataText:SetScript("OnMouseDown", function() ToggleMenu_Toggle() end)
end

-- color sh*t
if TukuiCF.togglemenu.classcolor == true then
	local classcolor = RAID_CLASS_COLORS[TukuiDB.myclass]
	hovercolor = {classcolor.r,classcolor.g,classcolor.b,1}
end

local menu = CreateFrame("Button", "Menu", MenuBG) -- Main buttons
for i = 1, 5 do
	menu[i] = CreateFrame("Button", "Menu"..i, MenuBG)
	TukuiDB.CreatePanel(menu[i], buttonwidth, buttonheight, "BOTTOM", MenuBG, "BOTTOM", 0, TukuiDB.Scale(3))
	menu[i]:SetFrameLevel(defaultframelevel+1)
	menu[i]:SetFrameStrata("HIGH")
	if i == 1 then
		menu[i]:SetPoint("BOTTOM", MenuBG, "BOTTOM", 0, TukuiDB.Scale(3))
	else
		menu[i]:SetPoint("BOTTOM", menu[i-1], "TOP", 0, TukuiDB.Scale(3))
	end
	menu[i]:EnableMouse(true)
	menu[i]:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
	menu[i]:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor)) end)
	menu[i]:RegisterForClicks("AnyUp")
	Text = menu[i]:CreateFontString(nil, "LOW")
	Text:SetFont(TukuiCF.togglemenu.font, TukuiCF.togglemenu.fontsize)
	Text:SetPoint("CENTER", menu[i], 0, 0)
 
	if i == 1 then -- KeyRing
		Text:SetText("KeyRing")
		menu[i]:SetScript("OnMouseUp", function() ToggleKeyRing() end)
	elseif i == 2 then -- Reload UI
		Text:SetText("Reload UI")
		menu[i]:SetScript("OnClick", function() ReloadUI() end)
	elseif i == 3 then -- Calendar
		Text:SetText("Calendar")
		menu[i]:SetScript("OnMouseUp", function() ToggleCalendar() end)
	elseif i == 4 then -- AddOns
		Text:SetText("AddOns")
		menu[i]:SetScript("OnMouseUp", function() ToggleFrame(TTMenuAddOnBackground); ToggleFrame(TTMenuBackground); end)
	elseif i == 5 then -- Close Menu
		Text:SetText("Close Menu")
		menu[i]:SetScript("OnMouseUp", function() MenuBG:Hide() TTMenuAddOnBackground:Hide() end)
	end
end

local returnbutton = CreateFrame("Button", "AddonMenuReturnButton", AddonBG)
TukuiDB.CreatePanel(returnbutton, buttonwidth, buttonheight, "TOP", AddonBG, "TOP", 0, TukuiDB.Scale(-3))
returnbutton:EnableMouse(true)
returnbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
returnbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor)) end)
returnbutton:RegisterForClicks("AnyUp")
returnbutton:SetFrameLevel(defaultframelevel+1)
returnbutton:SetFrameStrata("HIGH")
Text = returnbutton:CreateFontString(nil, "LOW")
Text:SetFont(TukuiCF.togglemenu.font, TukuiCF.togglemenu.fontsize)
Text:SetPoint("CENTER", returnbutton, 0, 0)
Text:SetText("Return")
returnbutton:SetScript("OnMouseUp", function() ToggleFrame(TTMenuAddOnBackground); ToggleFrame(TTMenuBackground); end)

-- new stuff

local expandbutton = CreateFrame("Button", "AddonMenuExpandButton", AddonBG)
TukuiDB.CreatePanel(expandbutton, buttonwidth, buttonheight/2, "BOTTOM", AddonBG, "BOTTOM", 0, TukuiDB.Scale(3))
expandbutton:EnableMouse(true)
expandbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
expandbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor)) end)
expandbutton:RegisterForClicks("AnyUp")
expandbutton:SetFrameLevel(defaultframelevel+1)
expandbutton:SetFrameStrata("HIGH")
Text = expandbutton:CreateFontString(nil, "LOW")
Text:SetFont(TukuiCF.togglemenu.font, TukuiCF.togglemenu.fontsize)
Text:SetPoint("CENTER", expandbutton, 0, 0)
Text:SetText("v")
expandbutton.txt = Text

local collapsedAddons = {
	["DBM"]      = "DBM-Core",
	["Tukui"]    = "Tukui",
}

local addonInfo
local lastMainAddon = "XYZNonExistantDummyAddon"
local lastMainAddonID = 0
if not addonInfo then
	addonInfo = {{}}
	for i = 1,GetNumAddOns() do
		name,title,_, enabled, _, _, _ = GetAddOnInfo(i)
		if(name and enabled) then
			addonInfo[i] = {["enabled"] = true,  ["is_main"] = false, collapsed = true, ["parent"] = i}
		else
			addonInfo[i] = {["enabled"] = false, ["is_main"] = false, collapsed = true, ["parent"] = i}
		end
		-- check special addon list first
		local addonFound = false
		for key, value in pairs(collapsedAddons) do
			if strsub(name, 0, strlen(key)) == key then
				addonFound = true
				if name == value then
					lastMainAddon = name
					lastMainAddonID = i
					addonInfo[i].is_main = true
				else
					addonInfo[i].parent = lastMainAddonID
					for j = 1,GetNumAddOns() do
						name_j, _, _, _, _, _, _ = GetAddOnInfo(j)
						if name_j == value then
							addonInfo[i].parent = j
						end
					end
				end
			end
		end
		-- collapse addons with common prefix
		if not addonFound then
			if strsub(name, 0, strlen(lastMainAddon)) == lastMainAddon then
				addonInfo[lastMainAddonID].is_main = true
				addonInfo[i].parent = lastMainAddonID
			else
				lastMainAddon = name
				lastMainAddonID = i
			end
		end
	end
end

local addonmenuitems = {};

local function addonEnableToggle(self, i)
	local was_enabled = addonInfo[i].enabled
	for j = 1,GetNumAddOns() do
		if ((addonInfo[j].parent == i and addonInfo[i].collapsed) or (i==j and not addonInfo[addonInfo[i].parent].collapsed)) then
			if was_enabled then
				DisableAddOn(j)
				addonmenuitems[j]:SetBackdropColor(unpack(TukuiCF.media.bordercolor))
			else
				EnableAddOn(j)
				addonmenuitems[j]:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
			end
			addonInfo[j].enabled = not was_enabled
		end
	end
end

local function addonFrameToggle(self, i)
	local name, _,_, _, _, _, _ = GetAddOnInfo(i)
	if addons[name] then
		if IsAddOnLoaded(i) then
			addons[name]()
		end
	end
end

local addonToggleOnly = TukuiCF.togglemenu.defaultIsToggleOnly

local function refreshAddOnMenu()
	local lastMenuEntryID = 0
	local menusize = 1
	for i = 1,GetNumAddOns() do
		local name, _,_, _, _, _, _ = GetAddOnInfo(i)
		addonmenuitems[i]:Hide()		
		if (addonInfo[i].is_main or (addonInfo[i].parent == i) or not addonInfo[addonInfo[i].parent].collapsed) then
			if (not addonToggleOnly or (addons[name] and IsAddOnLoaded(i))) then
				addonmenuitems[i]:ClearAllPoints()
				if (menusize == 1) then
					addonmenuitems[i]:SetPoint( "TOP", returnbutton, "BOTTOM", 0, TukuiDB.Scale(-3))
				else
					addonmenuitems[i]:SetPoint( "TOP", addonmenuitems[lastMenuEntryID], "BOTTOM", 0, TukuiDB.Scale(-3))
				end
				addonmenuitems[i]:Show()
				lastMenuEntryID = i
				menusize = menusize + 1
			end
		end
		if addonInfo[i].is_main then
			if addonToggleOnly then
				addonmenuitems[i].expandbtn:Hide()
			else
				addonmenuitems[i].expandbtn:Show()
			end
		end
	end
	AddonBG:SetHeight(((menusize) * buttonheight) + buttonheight/2 + ((menusize + 2) * 3))
end

expandbutton:SetScript("OnMouseUp", function(self) 
	addonToggleOnly = not addonToggleOnly
	if addonToggleOnly then
		self.txt:SetText("v")
		self.txt:SetPoint("CENTER", self, 0, 0)
	else
		self.txt:SetText("^")
		self.txt:SetPoint("CENTER", self, 0, TukuiDB.Scale(-2))
	end
	refreshAddOnMenu()
end)

for i = 1,GetNumAddOns() do
	local name, _,_, _, _, _, _ = GetAddOnInfo(i)
	addonmenuitems[i] = CreateFrame("Button", "AddonMenu"..i, AddonBG)
	TukuiDB.CreatePanel(addonmenuitems[i], buttonwidth, buttonheight, "TOP", returnbutton, "BOTTOM", 0, TukuiDB.Scale(-3))
	addonmenuitems[i]:EnableMouse(true)
	addonmenuitems[i]:RegisterForClicks("AnyUp")
	addonmenuitems[i]:SetFrameLevel(defaultframelevel+1)
	addonmenuitems[i]:SetFrameStrata("HIGH")
	addonmenuitems[i]:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			addonEnableToggle(self, i)
		else
			addonFrameToggle(self, i)
		end				
	end)
	addonmenuitems[i]:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) 
		GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, 0)
		GameTooltip:AddLine("Addon "..name)
		GameTooltip:AddLine("Rightclick to enable or disable (needs UI reload)")			
		if addons[name] then
			if IsAddOnLoaded(i) then
				GameTooltip:AddLine("Leftclick to toggle addon window")
			end
		end
		GameTooltip:Show()
	end)
	addonmenuitems[i]:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor))
		GameTooltip:Hide()
	end)
	if addonInfo[i].enabled then
		addonmenuitems[i]:SetBackdropColor(unpack(TukuiCF.media.backdropcolor))
	else
		addonmenuitems[i]:SetBackdropColor(unpack(TukuiCF.media.bordercolor))
	end
	Text = addonmenuitems[i]:CreateFontString(nil, "LOW")
	Text:SetFont(TukuiCF.togglemenu.font, TukuiCF.togglemenu.fontsize)
	Text:SetPoint("CENTER", addonmenuitems[i], 0, 0)
	Text:SetText(GetAddOnInfo(i))
	if addonInfo[i].is_main then
		local expandAddonButton = CreateFrame("Button", "AddonMenuExpand"..i, addonmenuitems[i])
		TukuiDB.CreatePanel(expandAddonButton, buttonheight-TukuiDB.Scale(6), buttonheight-TukuiDB.Scale(6), "TOPLEFT", addonmenuitems[i], "TOPLEFT", TukuiDB.Scale(3), TukuiDB.Scale(-3))
		expandAddonButton:SetFrameLevel(defaultframelevel+2)
		expandAddonButton:SetFrameStrata("HIGH")
		expandAddonButton:EnableMouse(true)
		expandAddonButton:HookScript("OnEnter", function(self)
			self:SetBackdropBorderColor(unpack(hovercolor))
			GameTooltip:SetOwner(self, 'ANCHOR_NONE', 0, 0)
			if addonInfo[i].collapsed then
				GameTooltip:AddLine("Expand "..name.." addons")
			else
				GameTooltip:AddLine("Collapse "..name.." addons")
			end
			GameTooltip:Show()
		end)
		expandAddonButton:HookScript("OnLeave", function(self)
			self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor))
			GameTooltip:Hide()
			end)
		expandAddonButton:RegisterForClicks("AnyUp")
		Text = expandAddonButton:CreateFontString(nil, "LOW")
		Text:SetFont(TukuiCF.togglemenu.font, TukuiCF.togglemenu.fontsize)
		Text:SetPoint("CENTER", expandAddonButton, 0, 0)
		Text:SetText("+")
		expandAddonButton.txt = Text
		expandAddonButton:SetScript("OnMouseUp", function(self)
			addonInfo[i].collapsed = not addonInfo[i].collapsed
			if addonInfo[i].collapsed then
				self.txt:SetText("+")
			else
				self.txt:SetText("-")
			end
			refreshAddOnMenu()
		end)
		addonmenuitems[i].expandbtn = expandAddonButton
	end
	addonmenuitems[i]:Hide()
end

refreshAddOnMenu()
