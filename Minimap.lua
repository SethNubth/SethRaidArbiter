function SRA_InitMinimap()
    if SRAMinimap then return end -- evita duplicado
    if not Minimap then return end
    
    local btn=CreateFrame("Button","SRAMinimap",Minimap)
    btn:SetSize(28,28)
    btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)
    btn:SetFrameLevel(Minimap:GetFrameLevel()+5)
    btn:SetClampedToScreen(true)
    btn:EnableMouse(true)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    -- NO setMovable, da taint en raid

    local tex=btn:CreateTexture(nil,"BACKGROUND")
    tex:SetAllPoints()
    tex:SetTexture("Interface\\AddOns\\SethRaidArbiter\\Media\\agonia_rock.tga")
    
    -- Fallback si no existe el .tga
    C_Timer.After(0.5, function()
        if not tex:GetTexture() or tex:GetTexture()==" " then
            tex:SetTexture("Interface\\Icons\\INV_Misc_Rune_01")
        end
    end)

    btn:SetScript("OnClick", function(_,b)
        if b=="LeftButton" then
            if SRA_ShowMenu then pcall(SRA_ShowMenu) else print("|cffff0000Seth: Menu.lua no cargado|r") end
        else
            if SRA_ShowConfig then pcall(SRA_ShowConfig) else print("|cffff0000Seth: Config.lua no cargado|r") end
        end
    end)

    btn:SetScript("OnEnter", function(self)
        if InCombatLockdown() then return end
        GameTooltip:SetOwner(self,"ANCHOR_LEFT")
        GameTooltip:AddLine("SethRaidArbiter |cffff0000Naerzone|r",1,1,1)
        GameTooltip:AddLine("Izq: Panel | Der: Config",0.8,0.8,0.8)
        GameTooltip:AddLine("v6.2 Balance 3W 2DK Demo Obli",0,1,0)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    print("|cFF00FF00Seth: Minimap agonia_rock OK|r")
end

-- Auto init con delay para que cargue todo
C_Timer.After(2, function() pcall(SRA_InitMinimap) end)
