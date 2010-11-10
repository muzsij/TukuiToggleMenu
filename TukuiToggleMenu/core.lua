 -- By Foof & Hydra at Tukui.org

if not TukuiCubeRight then return end

-- Config variables
font = TukuiCF.media.font            -- Font to be used for button text
fontsize = 12                        -- Size of font for button text
buttonwidth = TukuiDB.Scale(100)     -- Width of menu buttons
buttonheight = TukuiDB.Scale(20)     -- Height of menu buttons
classcolor = true                    -- Class color buttons
hovercolor = {0,.8,1,1}              -- Color of buttons on mouse-over (if classcolor is false)

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
}

local MenuBG = CreateFrame("Frame", "MenuBackground", UIParent)
TukuiDB.CreatePanel(MenuBG, buttonwidth + TukuiDB.Scale(6), buttonheight * 5 + TukuiDB.Scale(18), "TOP", UIParent, "TOP", 0, TukuiDB.Scale(-15))
MenuBG:SetFrameLevel(0)
MenuBG:Hide()
 
local AddonBG = CreateFrame("Frame", "AddOnBackground", UIParent)
TukuiDB.CreatePanel(AddonBG, buttonwidth + TukuiDB.Scale(6), 1, "TOP", MenuBG, "TOP", 0, 0)
AddonBG:SetFrameLevel(0)
AddonBG:Hide()

-- Integrate the menu into default Tukui
local ToggleCube = CreateFrame("Frame", "TukuiToggleCube", UIParent)
TukuiDB.CreatePanel(ToggleCube, TukuiCubeRight:GetWidth(), TukuiCubeRight:GetHeight(), "CENTER", TukuiCubeRight, "CENTER", 0, 0)
ToggleCube:SetFrameLevel(TukuiCubeRight:GetFrameLevel() + 1)
ToggleCube:EnableMouse(true)
ToggleCube:SetScript("OnMouseDown", function()
	ToggleFrame(MenuBackground)
	if AddOnBackground:IsShown() then AddOnBackground:Hide() end
end)

-- color sh*t
if classcolor == true then
	local classcolor = RAID_CLASS_COLORS[TukuiDB.myclass]
	hovercolor = {classcolor.r,classcolor.g,classcolor.b,1}
end

menu = CreateFrame("Button", "Menu", MenuBG) -- Main buttons
for i = 1, 5 do
	menu[i] = CreateFrame("Button", "Menu"..i, MenuBG)
	TukuiDB.CreatePanel(menu[i], buttonwidth, buttonheight, "BOTTOM", MenuBG, "BOTTOM", 0, TukuiDB.Scale(3))
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
	Text:SetFont(font, fontsize)
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
		menu[i]:SetScript("OnMouseUp", function() ToggleFrame(AddOnBackground); ToggleFrame(MenuBackground); end)
	elseif i == 5 then -- Close Menu
		Text:SetText("Close Menu")
		menu[i]:SetScript("OnMouseUp", function() MenuBG:Hide() AddOnBackground:Hide() end)
	end
end

local returnbutton = CreateFrame("Button", "AddonMenuReturnButton", AddonBG)
TukuiDB.CreatePanel(returnbutton, buttonwidth, buttonheight, "TOP", AddonBG, "TOP", 0, TukuiDB.Scale(-3))
returnbutton:EnableMouse(true)
returnbutton:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
returnbutton:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor)) end)
returnbutton:RegisterForClicks("AnyUp")
returnbutton:SetFrameLevel(1)
Text = returnbutton:CreateFontString(nil, "LOW")
Text:SetFont(font, fontsize)
Text:SetPoint("CENTER", returnbutton, 0, 0)
Text:SetText("Return")
returnbutton:SetScript("OnMouseUp", function() ToggleFrame(AddOnBackground); ToggleFrame(MenuBackground); end)

addonmenu = CreateFrame("Button", "AddonMenu", AddonBG)	-- AddOn page buttons
addonmenu[1] = returnbutton

for key, value in pairs(addons) do
	if IsAddOnLoaded(key) then
		local menuitem = CreateFrame("Button", "AddonMenu"..(#addonmenu + 1), AddonBG)
		TukuiDB.CreatePanel(menuitem, buttonwidth, buttonheight, "TOP", addonmenu[#addonmenu], "BOTTOM", 0, TukuiDB.Scale(-3))
		menuitem:EnableMouse(true)
		menuitem:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hovercolor)) end)
		menuitem:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(TukuiCF.media.bordercolor)) end)
		menuitem:RegisterForClicks("AnyUp")
		menuitem:SetFrameLevel(1)
		Text = menuitem:CreateFontString(nil, "LOW")
		Text:SetFont(font, fontsize)
		Text:SetPoint("CENTER", menuitem, 0, 0)
		Text:SetText(key)
		menuitem:SetScript("OnMouseUp", value)
		addonmenu[#addonmenu + 1] = menuitem
	end
end

AddonBG:SetHeight((#addonmenu * buttonheight) + ((#addonmenu + 1) * 3))