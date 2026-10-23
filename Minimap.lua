-- SethRaidArbiter Minimap.lua V1.1.4 MOVIBLE GOD - by SethNubth
-- FIX: C_Timer + Icono Movable + Anti-Spam + Drag alrededor minimapa

if not C_Timer then
  C_Timer={}
  function C_Timer.After(delay, func)
    local f=CreateFrame("Frame")
    local t=0
    f:SetScript("OnUpdate", function(self, e)
      t=t+e
      if t>=delay then
        self:SetScript("OnUpdate", nil)
        self:Hide()
        pcall(func)
      end
    end)
    f:Show()
  end
end

local alreadyLoaded=false
SRA_DB = SRA_DB or {}
SRA_DB.minimapPos = SRA_DB.minimapPos or 220

local function CreateButton()
  if alreadyLoaded then return end
  alreadyLoaded=true

  local btn=CreateFrame("Button", "SethRaidArbiterMiniBtn", Minimap)
  btn:SetSize(31,31)
  btn:SetFrameStrata("MEDIUM")
  btn:SetFrameLevel(8)
  btn:SetClampedToScreen(true)
  
  -- FIX GOD: Posicion alrededor minimapa
  local function UpdatePos()
    local ang = math.rad(SRA_DB.minimapPos)
    btn:ClearAllPoints()
    btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(ang)*80, math.sin(ang)*80)
  end
  
  UpdatePos()
  btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  
  local icon=btn:CreateTexture(nil, "ARTWORK")
  icon:SetSize(20,20)
  icon:SetPoint("CENTER", 1, 1)
  icon:SetTexture("Interface\\Icons\\INV_Hammer_03")
  icon:SetTexCoord(0.08,0.92,0.08,0.92)
  
  local border=btn:CreateTexture(nil, "OVERLAY")
  border:SetSize(52,52)
  border:SetPoint("TOPLEFT", 0, 0)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

  -- FIX GOD: MOVIBLE ALREDEDOR MINIMAPA
  btn:EnableMouse(true)
  btn:RegisterForDrag("LeftButton")
  btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  
  btn:SetScript("OnDragStart", function(self)
    self.isDragging = true
    self:SetScript("OnUpdate", function(self)
      local mx, my = Minimap:GetCenter()
      local cx, cy = GetCursorPosition()
      local scale = UIParent:GetEffectiveScale()
      cx, cy = cx/scale, cy/scale
      SRA_DB.minimapPos = math.deg(math.atan2(cy-my, cx-mx))
      UpdatePos()
    end)
  end)
  
  btn:SetScript("OnDragStop", function(self)
    self.isDragging = false
    self:SetScript("OnUpdate", nil)
  end)

  btn:SetScript("OnClick", function(_, button)
    if button=="LeftButton" then
      if SRA_MainFrame and SRA_MainFrame:IsShown() then SRA_MainFrame:Hide() else if SRA and SRA.ShowMain then SRA.ShowMain() end end
    else
      if SRAConfig then
        if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
      else
        if SRA_ShowConfig then SRA_ShowConfig() end
      end
    end
  end)

  btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("SethRaidArbiter v7.0",1,0.8,0)
    GameTooltip:AddLine("Left: Main BIS 35x3 | Right: Config",1,1,1)
    GameTooltip:AddLine("Drag: Mover alrededor minimapa",0.6,0.8,1)
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

  -- Un solo mensaje al cargar
  DEFAULT_CHAT_FRAME:AddMessage("|cffffd700[SethRaidArbiter]|r v1.1.4 FINAL MOVIBLE GOD - Boton martillo listo")
end

local f=CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
  if event=="ADDON_LOADED" and arg1=="SethRaidArbiter" and not alreadyLoaded then
    -- Solo 1 vez, delay 2s
    C_Timer.After(2, function() pcall(CreateButton) end)
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
