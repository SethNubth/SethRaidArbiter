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
  
  SRAConfig=CreateFrame("Frame","SRAConfig",UIParent,"BasicFrameTemplateWithInset") 
  SRAConfig:SetSize(500,420) 
  SRAConfig:SetPoint("CENTER") 
  SRAConfig:SetMovable(true)
  SRAConfig:EnableMouse(true)
  SRAConfig:RegisterForDrag("LeftButton")
  SRAConfig:SetScript("OnDragStart", function(s) s:StartMoving() end)
  SRAConfig:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  SRAConfig.TitleText:SetText("SethRaidArbiter - Dragonflight UI v6.2 |cffff0000Naerzone|r")
  
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
  
  -- Slider: GS minimo - FIX NOMBRE
  local slider = CreateFrame("Slider", "SRA_GS_Slider", SRAConfig, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", 20, -150)
  slider:SetSize(200, 20)
  slider:SetMinMaxValues(5000, 6000)
  slider:SetValueStep(100)
  slider:SetObeyStepOnDrag(true)
  slider:SetValue(SRA105DB.minGS)
  _G[slider:GetName().."Low"]:SetText("5k")
  _G[slider:GetName().."High"]:SetText("6k")
  _G[slider:GetName().."Text"]:SetText("GS Mínimo: "..SRA105DB.minGS)
  slider:SetScript("OnValueChanged", function(self, val)
      SRA105DB.minGS = math.floor(val)
      _G[self:GetName().."Text"]:SetText("GS Mínimo: "..SRA105DB.minGS)
  end)
  
  -- Info
  local info = SRAConfig:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
  info:SetPoint("BOTTOMLEFT",20,20)
  info:SetWidth(460)
  info:SetJustifyH("LEFT")
  info:SetText("Seth v6.2 - Balance: 3 War / 2 DK / 2 Caza / 1 Rogue / Feral 1 / Retry 3\nDemo Obli + Pala Tank Obli | Spec check solo al susurro inv | 11s anti-mute taberna")
  info:SetTextColor(0,1,0)
  
  SRAConfig:Show()
  print("|cFF00FF00Seth: Config Dragonflight OK|r")
end
