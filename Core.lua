function SRA_ShowConfig()
  if InCombatLockdown() then print("|cFFFF0000Seth: No config en combate|r") return end
  
  if SRAConfig then 
      if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
      return 
  end
  
  SRA105DB = SRA105DB or {}
  SRA105DB.autoEpic = SRA105DB.autoEpic == nil and true or SRA105DB.autoEpic
  SRA105DB.scanFreq = SRA105DB.scanFreq or 11
  SRA105DB.minGS = SRA105DB.minGS or 5300
  
  -- FIX GOD 3.3.5a: BasicFrameTemplateWithInset no existe, usamos BasicFrameTemplate
  SRAConfig=CreateFrame("Frame","SRAConfig",UIParent,"BasicFrameTemplate") 
  SRAConfig:SetSize(500,420) 
  SRAConfig:SetPoint("CENTER") 
  SRAConfig:SetMovable(true)
  SRAConfig:EnableMouse(true)
  SRAConfig:RegisterForDrag("LeftButton")
  SRAConfig:SetScript("OnDragStart", function(s) s:StartMoving() end)
  SRAConfig:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  SRAConfig:SetClampedToScreen(true) -- FIX para que no se vaya fuera
  if SRAConfig.TitleText then
    SRAConfig.TitleText:SetText("SethRaidArbiter - Dragonflight UI v6.2 |cffff0000Naerzone|r")
  end
  
  local title= SRAConfig:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
  title:SetPoint("TOPLEFT",20,-35)
  title:SetText("Configuración Naerzone Edition")
  
  -- Check 1: Auto epicos
  local cb=CreateFrame("CheckButton",nil,SRAConfig,"UICheckButtonTemplate") 
  cb:SetPoint("TOPLEFT",20,-70) 
  cb.Text:SetText("Detección automática épicos ICC 25H") 
  cb:SetChecked(SRA105DB.autoEpic)
  cb:SetScript("OnClick", function(self) 
      SRA105DB.autoEpic = self:GetChecked()
      print("Seth: Auto epic "..(SRA105DB.autoEpic and "ON" or "OFF"))
  end)
  
  -- Check 2: OffKick
  local cb2=CreateFrame("CheckButton",nil,SRAConfig,"UICheckButtonTemplate") 
  cb2:SetPoint("TOPLEFT",20,-100) 
  cb2.Text:SetText("Kick automático OFFLINE (60s)") 
  cb2:SetChecked(SRA105DB.offKick == nil and true or SRA105DB.offKick)
  cb2:SetScript("OnClick", function(self) SRA105DB.offKick = self:GetChecked() end)
  
  -- Slider: GS minimo - FIX NOMBRE para 3.3.5a
  local slider = CreateFrame("Slider", "SRA_GS_Slider", SRAConfig, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", 20, -150)
  slider:SetSize(200, 20)
  slider:SetMinMaxValues(5000, 6000)
  slider:SetValueStep(100)
  slider:SetObeyStepOnDrag(true)
  slider:SetValue(SRA105DB.minGS)
  if _G[slider:GetName().."Low"] then
    _G[slider:GetName().."Low"]:SetText("5k")
    _G[slider:GetName().."High"]:SetText("6k")
    _G[slider:GetName().."Text"]:SetText("GS Mínimo: "..SRA105DB.minGS)
  end
  slider:SetScript("OnValueChanged", function(self, val)
      SRA105DB.minGS = math.floor(val)
      if _G[self:GetName().."Text"] then
        _G[self:GetName().."Text"]:SetText("GS Mínimo: "..SRA105DB.minGS)
      end
  end)
  
  -- Info
  local info = SRAConfig:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
  info:SetPoint("BOTTOMLEFT",20,20)
  info:SetWidth(460)
  info:SetJustifyH("LEFT")
  info:SetText("Seth v6.2 - Balance: 3 War / 2 DK / 2 Caza / 1 Rogue / Feral 1 / Retry 3\nDemo Obli + Pala Tank Obli | Spec check solo al susurro inv | 11s anti-mute taberna")
  info:SetTextColor(0,1,0)
  
  SRAConfig:Show()
  print("|cFF00FF00Seth: Config Dragonflight OK - FIX 3.3.5a|r")
end

-- EXTRA GOD: Icono minimapa para que no se te pierda
if not SRA_MinimapIcon then
  local icon = CreateFrame("Button", "SRA_MinimapIcon", Minimap)
  icon:SetSize(32,32)
  icon:SetPoint("CENTER", Minimap, "CENTER", 80, 40)
  icon:SetMovable(true)
  icon:EnableMouse(true)
  icon:RegisterForDrag("LeftButton")
  icon:SetClampedToScreen(true)
  local tex = icon:CreateTexture(nil, "BACKGROUND")
  tex:SetSize(20,20)
  tex:SetPoint("CENTER")
  tex:SetTexture("Interface\\Icons\\INV_Hammer_03")
  local border = icon:CreateTexture(nil, "OVERLAY")
  border:SetSize(53,53)
  border:SetPoint("CENTER")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  icon:SetScript("OnDragStart", function(s) s:StartMoving() end)
  icon:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  icon:SetScript("OnClick", function() SRA_ShowConfig() end)
  icon:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("SethRaidArbiter v6.2",0,1,0)
    GameTooltip:AddLine("Click: Abrir config",1,1,1)
    GameTooltip:AddLine("Drag: Mover icono",1,1,1)
    GameTooltip:Show()
  end)
  icon:SetScript("OnLeave", function() GameTooltip:Hide() end)
  SRA_MinimapIcon = icon
end
