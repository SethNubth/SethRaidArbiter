local _, SRA = ...
SRA.Minimap = {}
SRA.Config = {}
SRA_DB = SRA_DB or {lastAlert=0}
SRA_Options = SRA_Options or {isLeader=true, isAyudante=false, isGuild=false, antiMute=true, autoTaberna=true, directLoot=true, epicAlert=true, screenshot=true, countdown=15}
function SRA.Minimap:OnLoad(frame)
 frame:SetMovable(true)
 frame:RegisterForDrag("LeftButton")
 frame:SetScript("OnDragStart", function() frame:StartMoving() end)
 frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
 frame:SetScript("OnClick", function(_, btn)
  if btn=="LeftButton" then
   if SRA_MainFrame and SRA_MainFrame:IsShown() then SRA_MainFrame:Hide() else SRA.ShowMain() end
  else
   if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
  end
 end)
end
function SRA.Config:OnLoad(frame)
 frame:RegisterForDrag("LeftButton")
 frame:SetScript("OnDragStart", function() frame:StartMoving() end)
 frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
end
function SRA.Config:OnSlider(slider, value)
 SRA_Options.countdown = value
 _G[slider:GetName().."Text"]:SetText("Countdown: "..value.."s")
end
function SRA.Config:Save()
 local f = SRAConfig
 SRA_Options.isLeader = _G[f:GetName().."Lider"]:GetChecked()
 SRA_Options.isAyudante = _G[f:GetName().."Ayudante"]:GetChecked()
 SRA_Options.isGuild = _G[f:GetName().."Guild"]:GetChecked()
 SRA_Options.antiMute = _G[f:GetName().."AntiMute"]:GetChecked()
 SRA_Options.autoTaberna = _G[f:GetName().."AutoTaberna"]:GetChecked()
 SRA_Options.directLoot = _G[f:GetName().."DirectLoot"]:GetChecked()
 SRA_Options.epicAlert = _G[f:GetName().."EpicAlert"]:GetChecked()
 SRA_Options.screenshot = _G[f:GetName().."Screenshot"]:GetChecked()
 print("|cffff8000SRA v7.0|r Config guardada")
 f:Hide()
end
SLASH_SRA1 = "/sra"
SLASH_SRA2 = "/seth"
SlashCmdList["SRA"] = function(msg)
 msg = (msg or ""):lower():trim()
 if msg=="config" then
  if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
 else
  if SRA_MainFrame and SRA_MainFrame:IsShown() then SRA_MainFrame:Hide() else SRA.ShowMain() end
 end
end
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
 if SRA.Utils and SRA.Utils.run then SRA.Utils.run() end
end)
print("|cffff8000SethRaidArbiter v7.0 EPGP GOD|r Cargado - /sra - 12340/30300 - Master Guild EPGP")
