local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

C["togglemenu"] = {
    ["font"] = C.media.font,                    -- Font to be used for button text
    ["fontsize"] = 12,                          -- Size of font for button text
    ["buttonwidth"] = 190,                      -- Width of menu buttons
    ["buttonheight"] = 20,                      -- Height of menu buttons
    ["buttonspacing"] = 3,                      -- Spacing of menu buttons
    ["positionnexttoMinimap"] = true,           -- Show the menu next to the minimap
    ["positionbelowMinimap"] = false,           -- Show the menu below minimap (false - left of minimap), sets buttonwidth to width of minimap
    ["classcolor"] = true,                      -- Class color buttons
    ["hovercolor"] = {0,.8,1,1},                -- Color of buttons on mouse-over (if classcolor is false)
    ["defaultIsToggleOnly"] = true,             -- Sets the default value for the addon menu (true - toggle-only, false - enhanced version)
    ["useTukuiCubeRight"] = true,               -- Toggle the menu if click on TukuiCubeRight
    ["useDataText"] = 0,                        -- Place the toggle menu on the panel (0 - turn off)
    ["DataTextTitle"] = 'Menu',                 -- Use this text on panel
    ["maxMenuEntries"] = 30,                    -- Maximum number of menu entries per column (0 - unlimited number)
    ["showByDefault"] = false,                  -- Show menu 
}

C["toggleaddons"] = {
    ["Recount"] = function()
        ToggleFrame(Recount.MainWindow)
        Recount.RefreshMainWindow()
    end,
    
    ["Skada"] = function()
        Skada:ToggleWindow()
    end,
    
    ["GatherMate2"] = function()
        GatherMate2.db.profile["showMinimap"] = not GatherMate2.db.profile["showMinimap"]
        GatherMate2.db.profile["showWorldMap"] = not GatherMate2.db.profile["showWorldMap"]
        GatherMate2:GetModule("Config"):UpdateConfig()
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
        SlashCmdList.CONFIG()
    end,

    ["Panda"] = function()
        ToggleFrame(PandaPanel)
    end,

    ["PallyPower"] = function()
        ToggleFrame(PallyPowerFrame)
    end,

    ["ACP"] = function()
        ToggleFrame(ACP_AddonList)
    end,

    ["ScrollMaster"] = function()
        LibStub("AceAddon-3.0"):GetAddon("ScrollMaster").GUI:OpenFrame(1)
    end,
}
