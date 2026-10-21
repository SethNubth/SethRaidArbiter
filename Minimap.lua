-- SethRaidArbiter Minimap.lua - V1.1.1 WOTLK FIX - C_Timer FIX
-- COMPAT LAYER - Pega esto AL INICIO del archivo, antes de linea 47

if not C_Timer then
  C_Timer={}
  function C_Timer.After(delay, func)
    local frame=CreateFrame("Frame")
    local elapsed=0
    frame:SetScript("OnUpdate", function(self, e)
      elapsed=elapsed+e
      if elapsed>=delay then
        self:SetScript("OnUpdate", nil)
        self:Hide()
        pcall(func)
      end
    end)
    frame:Show()
  end
end

-- Tu codigo original desde linea 47 para abajo sigue igual
-- Ahora C_Timer.After ya existe en 3.3.5

local function CreateMinimapButton()
  local btn=CreateFrame("Button", "SethRaidArbiterMinimapButton", Minimap)
  btn:SetSize(32,32)
  btn:SetFrameStrata("MEDIUM")
  btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)
  local icon=btn:CreateTexture(nil, "BACKGROUND")
  icon:SetSize(20,20)
  icon:SetPoint("CENTER")
  icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
  btn:SetScript("OnClick", function()
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd700[SethRaidArbiter]|r v1.1 FINAL OK")
  end)
  return btn
end

local f=CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
  if arg1=="SethRaidArbiter" then
    C_Timer.After(2, function() pcall(CreateMinimapButton) end)
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
