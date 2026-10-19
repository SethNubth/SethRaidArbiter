function SRA_ShowConfig()
  if SRAConfig then SRAConfig:Show() return end
  SRAConfig=CreateFrame("Frame","SRAConfig",UIParent,"BasicFrameTemplateWithInset") SRAConfig:SetSize(500,400) SRAConfig:SetPoint("CENTER") SRAConfig.TitleText:SetText("SethRaidArbiter - Dragonflight UI")
  local cb=CreateFrame("CheckButton",nil,SRAConfig,"UICheckButtonTemplate") cb:SetPoint("TOPLEFT",20,-40) cb.Text:SetText("Detección automática épicos ICC 25H") cb:SetChecked(true)
end
