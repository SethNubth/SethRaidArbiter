local _, SRA = ...
SRA.Minimap = {}
SRA.Config = {}
SRA_DB = SRA_DB or {lastAlert=0}
SRA_Options = SRA_Options or {isLeader=true, isAyudante=false, isGuild=false, antiMute=true, autoTaberna=true, directLoot=true, epicAlert=true, screenshot=true, countdown=15}

-- FIX 3.3.5a: trim no existe
local function SRA_trim(s)
  if not s then return "" end
  if string.trim then return string.trim(s) end
  if strtrim then return strtrim(s) end
  return s:match("^%s*(.-)%s*$") or s
end

function SRA.Minimap:OnLoad(frame)
 frame:SetMovable(true)
 frame:RegisterForDrag("LeftButton")
 frame:SetScript("OnDragStart", function() frame:StartMoving() end)
 frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
 frame:SetClampedToScreen(true)
 frame:SetScript("OnClick", function(_, btn)
  if btn=="LeftButton" then
   if SRA_MainFrame and SRA_MainFrame:IsShown() then SRA_MainFrame:Hide() else if SRA.ShowMain then SRA.ShowMain() end end
  else
   if SRAConfig then
     if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
   else
     if SRA_ShowConfig then SRA_ShowConfig() end
   end
  end
 end)
end

function SRA.Config:OnLoad(frame)
 frame:SetMovable(true)
 frame:EnableMouse(true)
 frame:RegisterForDrag("LeftButton")
 frame:SetScript("OnDragStart", function() frame:StartMoving() end)
 frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
 frame:SetClampedToScreen(true)
end

function SRA.Config:OnSlider(slider, value)
 SRA_Options.countdown = value
 local txt = _G[slider:GetName().."Text"]
 if txt then txt:SetText("Countdown: "..value.."s") end
end

function SRA.Config:Save()
 local f = SRAConfig
 if not f then return end
 local function GetCheck(suffix)
   local cb = _G[f:GetName()..suffix]
   return cb and cb:GetChecked()
 end
 SRA_Options.isLeader = GetCheck("Lider")
 SRA_Options.isAyudante = GetCheck("Ayudante")
 SRA_Options.isGuild = GetCheck("Guild")
 SRA_Options.antiMute = GetCheck("AntiMute")
 SRA_Options.autoTaberna = GetCheck("AutoTaberna")
 SRA_Options.directLoot = GetCheck("DirectLoot")
 SRA_Options.epicAlert = GetCheck("EpicAlert")
 SRA_Options.screenshot = GetCheck("Screenshot")
 print("|cffff8000SRA v7.0|r Config guardada")
 f:Hide()
end

SLASH_SRA1 = "/sra"
SLASH_SRA2 = "/seth"
SlashCmdList["SRA"] = function(msg)
 msg = (msg or ""):lower()
 msg = SRA_trim(msg)
 if msg=="config" then
  if SRAConfig then
    if SRAConfig:IsShown() then SRAConfig:Hide() else SRAConfig:Show() end
  else
    if SRA_ShowConfig then SRA_ShowConfig() end
  end
 else
  if SRA_MainFrame and SRA_MainFrame:IsShown() then SRA_MainFrame:Hide() else if SRA.ShowMain then SRA.ShowMain() else if SRA_ShowConfig then SRA_ShowConfig() end end end
 end
end

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
 if SRA.Utils and SRA.Utils.run then SRA.Utils.run() end
end)

-- ICONO MINIMAPA GOD MOVIBLE - Ya no dependes de XML
if not SRA_MinimapButton then
  SRA_DB.minimapPos = SRA_DB.minimapPos or 220
  local btn = CreateFrame("Button", "SRA_MinimapButton", Minimap)
  btn:SetSize(33,33)
  btn:SetFrameStrata("MEDIUM")
  
  local function UpdatePos()
    local ang = math.rad(SRA_DB.minimapPos)
    btn:ClearAllPoints()
    btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(ang)*80, math.sin(ang)*80)
  end
  
  local tex = btn:CreateTexture(nil, "BACKGROUND")
  tex:SetSize(20,20)
  tex:SetPoint("CENTER", 1, 1)
  tex:SetTexture("Interface\\Icons\\INV_Hammer_03")
  tex:SetTexCoord(0.07,0.93,0.07,0.93)
  
  local border = btn:CreateTexture(nil, "OVERLAY")
  border:SetSize(53,53)
  border:SetPoint("CENTER")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  
  btn:EnableMouse(true)
  btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  btn:RegisterForDrag("LeftButton")
  btn:SetScript("OnDragStart", function(self) self.isDragging = true end)
  btn:SetScript("OnDragStop", function(self) self.isDragging = false end)
  btn:SetScript("OnUpdate", function(self)
    if self.isDragging then
      local mx, my = Minimap:GetCenter()
      local cx, cy = GetCursorPosition()
      local scale = UIParent:GetEffectiveScale()
      cx, cy = cx/scale, cy/scale
      SRA_DB.minimapPos = math.deg(math.atan2(cy-my, cx-mx))
      UpdatePos()
    end
  end)
  btn:SetScript("OnClick", function(_, b)
    if b=="LeftButton" then
      SlashCmdList["SRA"]("")
    else
      SlashCmdList["SRA"]("config")
    end
  end)
  btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("SethRaidArbiter v7.0 EPGP GOD",0,1,0)
    GameTooltip:AddLine("Left: Main | Right: Config",1,1,1)
    GameTooltip:AddLine("Drag: Mover alrededor minimapa",0.8,0.8,0.8)
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  
  UpdatePos()
  SRA_MinimapButton = btn
end

print("|cffff8000SethRaidArbiter v7.0 EPGP GOD|r Cargado - /sra - 12340 FIX trim + minimap GOD")
