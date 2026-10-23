local btn = SRA_MinimapButton or CreateFrame("Button", "SRA_MinimapButton", Minimap)
btn:SetSize(32,32)
btn:SetFrameStrata("MEDIUM")
btn:SetMovable(true)
btn:RegisterForDrag("RightButton")
btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

btn:SetNormalTexture("Interface\\AddOns\\SethRaidArbiter\\hammer.tga")
if not btn:GetNormalTexture() then
  btn:SetNormalTexture("Interface\\Icons\\INV_Hammer_20")
end

-- Hacerlo movible alrededor del minimapa
local function UpdatePos()
  local angle = SRA_Options and SRA_Options.minimapAngle or 45
  local rad = math.rad(angle)
  local r = 80
  btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad)*r, math.sin(rad)*r)
end

btn:SetScript("OnDragStart", function(self)
  self.isMoving = true
  self:SetScript("OnUpdate", function()
    local mx, my = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    cx, cy = cx/scale, cy/scale
    local angle = math.deg(math.atan2(cy - my, cx - mx))
    SRA_Options = SRA_Options or {}
    SRA_Options.minimapAngle = angle
    UpdatePos()
  end)
end)

btn:SetScript("OnDragStop", function(self)
  self.isMoving = false
  self:SetScript("OnUpdate", nil)
end)

-- FIX GOD: Click izquierdo y derecho
btn:SetScript("OnClick", function(self, button)
  if self.isMoving then return end
  if button == "LeftButton" then
    if SRA_Toggle then SRA_Toggle() else SlashCmdList["SRA"]("") end
  elseif button == "RightButton" then
    -- Click derecho ahora ABRE CONFIG
    print("|cffff8000Seth:|r Click Derecho -> Config / Reset posición")
    if SRA_OpenConfig then SRA_OpenConfig() end
    -- Si quieres que solo reseteé posición, usa:
    -- SRA_Options.minimapAngle = 45 UpdatePos()
  end
end)

btn:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_LEFT")
  GameTooltip:AddLine("|cffff8000SethRaidArbiter|r")
  GameTooltip:AddLine("|cff00ff00Click Izq:|r Abrir/Cerrar BIS",1,1,1)
  GameTooltip:AddLine("|cff00ffffClick Der:|r Config + Mover (arrastrar)",1,1,1)
  GameTooltip:Show()
end)

btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

UpdatePos()
print("|cFF00FF00SethRaidArbiter v1.1.5 FINAL CLICK DER GOD - Boton listo|")
