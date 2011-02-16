local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

-- By Foof & Hydra at Tukui.org
-- modified by Gorlasch
-- modified by HyPeRnIcS

if C.togglemenu.positionbelowMinimap == true then
	C.togglemenu.buttonwidth = TukuiMinimap:GetWidth() - 2 * C.togglemenu.buttonspacing
end

local function buttonwidth(num)
	return num * C.togglemenu.buttonwidth
end
local function buttonheight(num)
	return num * C.togglemenu.buttonheight
end
local function buttonspacing(num)
	return num * C.togglemenu.buttonspacing
end
local function borderwidth(num)
	return buttonwidth(num) + buttonspacing(num+1)
end
local function borderheight(num)
	return buttonheight(num) + buttonspacing(num+1)
end
local defaultframelevel = 0

local MenuBG = CreateFrame("Frame", "TTMenuBackground", UIParent)
if C.togglemenu.positionnexttoMinimap == true then
	MenuBG:CreatePanel("Default", borderwidth(1), borderheight(5), "TOPRIGHT", TukuiMinimap, "TOPLEFT", buttonspacing(-1), 0)
	if C.togglemenu.positionbelowMinimap == true then
		if TukuiMinimapStatsRight then
			MenuBG:CreatePanel("Default", borderwidth(1), borderheight(5), "TOPRIGHT", TukuiMinimapStatsRight, "BOTTOMRIGHT", 0, buttonspacing(-1))
		else
			MenuBG:CreatePanel("Default", borderwidth(1), borderheight(5), "TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", 0, buttonspacing(-1))
		end
	end
else
	MenuBG:CreatePanel("Default", borderwidth(1), borderheight(5), "TOP", UIParent, "TOP", 0, buttonspacing(-5))
end
MenuBG:SetFrameLevel(defaultframelevel+0)
MenuBG:SetFrameStrata("HIGH")
if not C.togglemenu.showByDefault then
	MenuBG:Hide()
end
 
local AddonBG = CreateFrame("Frame", "TTMenuAddOnBackground", UIParent)
if TukuiCF.togglemenu.positionnexttoMinimap == true then
	AddonBG:CreatePanel("Default", borderwidth(1), 1, "TOPRIGHT", MenuBG, "TOPRIGHT", 0, 0)
else
	AddonBG:CreatePanel("Default", borderwidth(1), 1, "TOP", MenuBG, "TOP", 0, 0)
end
AddonBG:SetFrameLevel(defaultframelevel+0)
AddonBG:SetFrameStrata("HIGH")
AddonBG:Hide()

function ToggleMenu_Toggle()
	ToggleFrame(TTMenuBackground)
	if TTMenuAddOnBackground:IsShown() then TTMenuAddOnBackground:Hide() end
end

-- Add slash command
SLASH_TUKUITOGGLEMENU1 = "/ttm"
SlashCmdList.TUKUITOGGLEMENU = ToggleMenu_Toggle

-- Integrate the menu into TukuiRightCube
if TukuiCubeRight and C.togglemenu.useTukuiCubeRight == true then
	local ToggleCube = CreateFrame("Frame", "TukuiToggleCube", UIParent)
	ToggleCube:CreatePanel("Default", TukuiCubeRight:GetWidth(), TukuiCubeRight:GetHeight(), "CENTER", TukuiCubeRight, "CENTER", 0, 0)
	ToggleCube:SetFrameLevel(TukuiCubeRight:GetFrameLevel() + 1)
	ToggleCube:EnableMouse(true)
	ToggleCube:SetScript("OnMouseDown", function() ToggleMenu_Toggle() end)
end

-- Integrate the menu into the panel
if C.togglemenu.useDataText and C.togglemenu.useDataText > 0 then
	local DataText = CreateFrame("Frame")
	DataText:EnableMouse(true)
	DataText:SetFrameStrata("BACKGROUND")
	DataText:SetFrameLevel(3)
	local Text  = TukuiInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C.media.font, C["datatext"].fontsize)
	TukuiDB.PP(C.togglemenu.useDataText, Text)
	Text:SetText(C.togglemenu.DataTextTitle)
	DataText:SetAllPoints(Text)
	DataText:SetScript("OnMouseDown", function() ToggleMenu_Toggle() end)
end

-- color sh*t
if C.togglemenu.classcolor == true then
	local classcolor = RAID_CLASS_COLORS[TukuiDB.myclass]
	hovercolor = {classcolor.r,classcolor.g,classcolor.b,1}
end

local menu = CreateFrame("Button", "Menu", MenuBG) -- Main buttons
for i = 1, 5 do
	menu[i] = CreateFrame("Button", "Menu"..i, MenuBG)
	menu[i]:CreatePanel("Default", buttonwidth(1), buttonheight(1), "BOTTOM", MenuBG, "BOTTOM", 0, buttonspacing(1))
	menu[i]:SetFrameLevel(defaultframelevel+1)
	menu[i]:SetFrameStrata("HIGH")
	if i == 1 then
		menu[i]:SetPoint("BOTTOM", MenuBG, "BOTTOM", 0, buttonspacing(1))
	else
		menu[i]:SetPoint("BOTTOM", menu[i-1], "TOP", 0, buttonspacing(1))
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
returnbutton:CreatePanel("Default", buttonwidth(1), buttonheight(1), "TOPLEFT", AddonBG, "TOPLEFT", buttonspacing(1), buttonspacing(-1))
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

local expandbutton = CreateFrame("Button", "AddonMenuExpandButton", AddonBG)
expandbutton:CreatePanel("Default", buttonwidth(1), buttonheight(1)/2, "BOTTOM", AddonBG, "BOTTOM", 0, buttonspacing(1))
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
	if C.toggleaddons[name] then
		if IsAddOnLoaded(i) then
			C.toggleaddons[name]()
		end
	end
end

local addonToggleOnly = C.togglemenu.defaultIsToggleOnly

local function refreshAddOnMenu()
	local menusize = 1
	for i = 1,GetNumAddOns() do
		local name, _, _, _, _, _, _ = GetAddOnInfo(i)
		if (addonInfo[i].is_main or (addonInfo[i].parent == i) or not addonInfo[addonInfo[i].parent].collapsed) then
			if (not addonToggleOnly or (C.toggleaddons[name] and IsAddOnLoaded(i))) then
				menusize = menusize + 1
			end
		end
	end
	if C.togglemenu.maxMenuEntries and C.togglemenu.maxMenuEntries > 0 then
		menuwidth  = ceil(menusize/C.togglemenu.maxMenuEntries)
	else
		menuwidth  = 1
	end
	menuheight = ceil(menusize/menuwidth)

	local lastMenuEntryID = 0
	menusize = 1
	for i = 1,GetNumAddOns() do
		local name, _,_, _, _, _, _ = GetAddOnInfo(i)
		addonmenuitems[i]:Hide()		
		if (addonInfo[i].is_main or (addonInfo[i].parent == i) or not addonInfo[addonInfo[i].parent].collapsed) then
			if (not addonToggleOnly or (C.toggleaddons[name] and IsAddOnLoaded(i))) then
				addonmenuitems[i]:ClearAllPoints()
				if (menusize == 1) then
					addonmenuitems[i]:SetPoint( "TOP", returnbutton, "BOTTOM", 0, buttonspacing(-1))
				elseif menusize % menuheight == 0 then
					addonmenuitems[i]:SetPoint( "LEFT", addonmenuitems[lastMenuEntryID], "RIGHT", buttonspacing(1), borderheight(menuheight - 1) - buttonspacing(1))
				else
					addonmenuitems[i]:SetPoint( "TOP", addonmenuitems[lastMenuEntryID], "BOTTOM", 0, buttonspacing(-1))
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
	AddonBG:SetHeight(borderheight(menuheight+1) - buttonheight(1)/2)
	AddonBG:SetWidth(borderwidth(menuwidth))
	expandbutton:SetWidth(buttonwidth(menuwidth) + buttonspacing(menuwidth-1))
end

expandbutton:SetScript("OnMouseUp", function(self) 
	addonToggleOnly = not addonToggleOnly
	if addonToggleOnly then
		self.txt:SetText("v")
		self.txt:SetPoint("CENTER", self, 0, 0)
	else
		self.txt:SetText("^")
		self.txt:SetPoint("CENTER", self, 0, -2)
	end
	refreshAddOnMenu()
end)

for i = 1,GetNumAddOns() do
	local name, _,_, _, _, _, _ = GetAddOnInfo(i)
	addonmenuitems[i] = CreateFrame("Button", "AddonMenu"..i, AddonBG)
	addonmenuitems[i]:CreatePanel("Default", buttonwidth(1), buttonheight(1), "TOP", returnbutton, "BOTTOM", 0, buttonspacing(-1))
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
		if C.toggleaddons[name] then
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
	Text:SetText(select(2,GetAddOnInfo(i)))
	if addonInfo[i].is_main then
		local expandAddonButton = CreateFrame("Button", "AddonMenuExpand"..i, addonmenuitems[i])
		expandAddonButton:CreatePanel("Default", buttonheight(1)-buttonspacing(2), buttonheight(1)-buttonspacing(2), "TOPLEFT", addonmenuitems[i], "TOPLEFT", buttonspacing(1), buttonspacing(-1))
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
