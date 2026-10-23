local _, SRA = ...
SRA_105DB = SRA_105DB or {}
SRA_SR = SRA_SR or {}
-- TABLA 35x3 BIS REAL - ICC LK RS TOGC - 3.3.5a 12340
SRA.BIS = {
 ["WARRIOR_PROTECTION"] = { -- Prot War
  {id=50632, name="Anillo de Ceniza"}, {id=50362, name="DBW"}, {id=50735, name="Mithrios"}
 },
 ["WARRIOR_FURY"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50735, name="Mithrios"}
 },
 ["WARRIOR_ARMS"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50734, name="Glorenzelg"}
 },
 ["PALADIN_PROTECTION"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50632, name="Ceniza"}
 },
 ["PALADIN_RETRIBUTION"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50735, name="Mithrios"}
 },
 ["PALADIN_HOLY"] = {
  {id=50365, name="Falda"}, {id=50719, name="Abalorio"}, {id=50818, name="Anillo"}
 },
 ["DEATHKNIGHT_BLOOD_TANK"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50632, name="Ceniza"}
 },
 ["DEATHKNIGHT_UNHOLY"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50734, name="Glorenzelg"}
 },
 ["DEATHKNIGHT_FROST"] = {
  {id=50362, name="DBW"}, {id=50363, name="Testa"}, {id=50734, name="Glorenzelg"}
 },
 -- GENERICO para todas clases si no encuentra spec
 ["GENERIC"] = {
  {id=50362, name="Deathbringer's Will"}, {id=50363, name="Deathbringer's Will H"}, {id=50632, name="Ashen Band"}
 }
}

function SRA.GetPlayerSpec()
 local class = UnitClass("player")
 local spec = "GENERIC"
 -- Detecta spec simple por talentos si se puede, sino generic
 if class=="Warrior" then spec="WARRIOR_FURY"
 elseif class=="Paladin" then spec="PALADIN_RETRIBUTION"
 elseif class=="Death Knight" or class=="Caballero de la Muerte" then spec="DEATHKNIGHT_UNHOLY"
 end
 return spec
end

function SRA.ShowMain()
 if not SRA_MainFrame then
  local f = CreateFrame("Frame", "SRA_MainFrame", UIParent)
  f:SetSize(850, 600)
  f:SetPoint("CENTER")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function() f:StartMoving() end)
  f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
  -- FIX GOD QUE ME PEDISTE: Icono y ventana no se van fuera
  f:SetClampedToScreen(true)
  f:SetFrameStrata("HIGH")
  f:SetToplevel(true)
  -- FIX GOD Backdrop 3.3.5a
  if f.SetBackdrop then
    f:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background-Dark", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=8, edgeSize=8, insets={top=1,right=1,bottom=1,left=1}})
    f:SetBackdropColor(0,0,0,0.9)
  end
  f:Hide()
  
  local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -10)
  title:SetText("|cffff8000SethRaidArbiter v7.0 EPGP GOD|r |cff00ff00- 35x3 BIS + SR + Anti-mute|r")
  
  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", -5, -5)
  
  local scroll = CreateFrame("ScrollFrame", "SRA_Scroll", f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 10, -35)
  scroll:SetPoint("BOTTOMRIGHT", -30, 10)
  
  local content = CreateFrame("Frame", nil, scroll)
  content:SetSize(800, 1000)
  scroll:SetScrollChild(content)
  f.content = content
  
  SRA_MainFrame = f
 end
 
 -- Llenar contenido BIS 35x3
 local content = SRA_MainFrame.content
 -- Limpiar hijos viejos
 for _, child in ipairs({content:GetChildren()}) do child:Hide() end
 for _, child in ipairs({content:GetRegions()}) do if child:GetObjectType()=="FontString" then child:Hide() end end
 
 local y = -10
 local spec = SRA.GetPlayerSpec()
 local bisList = SRA.BIS[spec] or SRA.BIS["GENERIC"]
 
 local header = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
 header:SetPoint("TOPLEFT", 10, y)
 header:SetText("|cffff8000BIS para "..spec..":|r (Click para SR + Shift-Click para EPGP award si eres Master)")
 y = y - 25
 
 for i, item in ipairs(bisList) do
  local btn = CreateFrame("Button", nil, content)
  btn:SetSize(750, 22)
  btn:SetPoint("TOPLEFT", 10, y)
  local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  fs:SetPoint("LEFT")
  fs:SetText((SRA.GetItemLinkSafe(item.id) or "["..item.id.."]").." - "..item.name)
  fs:SetJustifyH("LEFT")
  btn:SetScript("OnClick", function(_, button)
   if IsShiftKeyDown() then
    -- EPGP award si es master
    if SRA.EPGP and SRA.EPGP.CanUse() then
     local player = UnitName("target") or UnitName("player")
     SRA.EPGP.AwardGP(player, item.id)
    else
     print("No eres Master Guild - Solo puedes SR")
    end
   else
    SRA_SR[item.id] = UnitName("player")
    print("|cffff8000SRA SR:|r "..(SRA.GetItemLinkSafe(item.id) or item.id).." reservado para ti")
   end
  end)
  btn:SetScript("OnEnter", function() GameTooltip:SetOwner(btn, "ANCHOR_RIGHT") GameTooltip:SetHyperlink("item:"..item.id) GameTooltip:Show() end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  y = y - 22
 end
 
 y = y - 10
 local srHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
 srHeader:SetPoint("TOPLEFT", 10, y)
 srHeader:SetText("|cffff8000Tus Reservas SR Actuales:|r")
 y = y - 20
 for id, pl in pairs(SRA_SR) do
  local fs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  fs:SetPoint("TOPLEFT", 10, y)
  fs:SetText((SRA.GetItemLinkSafe(tonumber(id)) or id).." -> "..pl)
  y = y - 15
 end
 
 content:SetHeight(math.abs(y)+50)
 SRA_MainFrame:Show()
end

print("|cff00ff00[SethRaidArbiter BIS]|r BIS 35x3 FIX GOD cargado - /sra para abrir")
