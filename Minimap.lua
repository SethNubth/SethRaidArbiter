function SRA_InitMinimap()
  local btn=CreateFrame("Button","SRAMinimap",Minimap) btn:SetSize(28,28) btn:SetPoint("TOPLEFT",Minimap,"TOPLEFT",0,0) btn:SetMovable(true) btn:EnableMouse(true) btn:RegisterForDrag("LeftButton")
  local tex=btn:CreateTexture(nil,"BACKGROUND") tex:SetAllPoints()
  tex:SetTexture("Interface\\AddOns\\SethRaidArbiter\\Media\\agonia_rock.tga")
  if not tex:GetTexture() then tex:SetTexture("Interface\\Icons\\INV_Misc_Rune_01") end -- fallback
  btn:SetScript("OnClick", function(_,b) if b=="LeftButton" then SRA_ShowMenu() else if SRA_ShowConfig then SRA_ShowConfig() end end end)
  btn:SetScript("OnDragStart", btn.StartMoving) btn:SetScript("OnDragStop", btn.StopMovingOrSizing)
  btn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self,"ANCHOR_LEFT") GameTooltip:AddLine("SethRaidArbiter") GameTooltip:AddLine("Izq: Panel | Der: Config") GameTooltip:Show() end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
