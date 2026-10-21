-- SethRaidArbiter Minimap.lua V1.1.3 ANTI-SPAM GOD - by SethNubth
-- FIX: C_Timer + Icono + Spam

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

local function CreateButton()
  if alreadyLoaded then return end
  alreadyLoaded=true

  local btn=CreateFrame("Button", "SethRaidArbiterMiniBtn", Minimap)
  btn:SetSize(31,31)
  btn:SetFrameStrata("MEDIUM")
  btn:SetFrameLevel(8)
  btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
  btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  
  local icon=btn:CreateTexture(nil, "ARTWORK")
  icon:SetSize(20,20)
  icon:SetPoint("CENTER", 0, 1)
  icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
  
  local border=btn:CreateTexture(nil, "OVERLAY")
  border:SetSize(52,52)
  border:SetPoint("TOPLEFT", 0, 0)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

  btn:SetScript("OnClick", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd700[SethRaidArbiter]|r Menu - v1.1.3")
  end)

  btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("SethRaidArbiter v1.1.3\nAnti-Spam OK")
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

  -- Un solo mensaje al cargar
  DEFAULT_CHAT_FRAME:AddMessage("|cffffd700[SethRaidArbiter]|r v1.1.3 FINAL OK - Boton creado")
end

local f=CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
  if event=="ADDON_LOADED" and arg1=="SethRaidArbiter" and not alreadyLoaded then
    -- Solo 1 vez, delay 3s
    C_Timer.After(3, function() pcall(CreateButton) end)
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
