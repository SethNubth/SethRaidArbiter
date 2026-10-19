local frame, currentTab
local function createMenu()
  if frame then return frame end
  frame=CreateFrame("Frame","SRAFrame",UIParent,"BasicFrameTemplateWithInset")
  frame:SetSize(820,580) frame:SetPoint("CENTER") frame:SetMovable(true) frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton") frame:SetScript("OnDragStart", frame.StartMoving) frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame.TitleText:SetText("SethRaidArbiter - 35x3 + BIS")
  local content=CreateFrame("Frame",nil,frame) content:SetPoint("TOPLEFT",15,-60) content:SetPoint("BOTTOMRIGHT",-15,15)
  local scroll=CreateFrame("ScrollFrame",nil,content,"UIPanelScrollFrameTemplate") scroll:SetPoint("TOPLEFT",0,-30) scroll:SetPoint("BOTTOMRIGHT",-25,0)
  local inner=CreateFrame("Frame",nil,scroll) inner:SetSize(750,1350) scroll:SetScrollChild(inner)
  local function build(tab)
    currentTab=tab:lower() for _,c in ipairs({inner:GetChildren()}) do c:Hide() end
    local db=SRA105DB[currentTab] local dbId=SRA105DB[currentTab.."_id"]
    for i=1,35 do
      local row=CreateFrame("Frame",nil,inner) row:SetSize(740,32) row:SetPoint("TOPLEFT",0,-(i-1)*36) row:Show()
      local lbl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") lbl:SetPoint("LEFT",0,0) lbl:SetWidth(30) lbl:SetText(i)
      local eb=CreateFrame("EditBox",nil,row,"InputBoxTemplate") eb:SetSize(420,24) eb:SetPoint("LEFT",35,0) eb:SetAutoFocus(false) eb:SetText(db[i] or "")
      eb:SetScript("OnEnterPressed", function(s) SRA105DB[currentTab][i]=s:GetText() s:ClearFocus() end) eb:SetScript("OnEditFocusLost", function(s) SRA105DB[currentTab][i]=s:GetText() end)
      local eb2=CreateFrame("EditBox",nil,row,"InputBoxTemplate") eb2:SetSize(90,24) eb2:SetPoint("LEFT",eb,"RIGHT",8,0) eb2:SetAutoFocus(false) eb2:SetText(dbId[i] or "")
      eb2:SetScript("OnEnterPressed", function(s) SRA105DB[currentTab.."_id"][i]=s:GetText() s:ClearFocus() end)
      local btn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate") btn:SetSize(75,22) btn:SetPoint("LEFT",eb2,"RIGHT",8,0) btn:SetText("LANZAR")
      btn:SetScript("OnClick", function() local txt=SRA105DB[currentTab][i] local idTxt=SRA105DB[currentTab.."_id"][i] if txt and txt~="" then local link=SRA_GetItemLink(idTxt) SendChatMessage(link~="" and txt.." "..link or txt,"RAID_WARNING") end end)
    end
  end
  for idx,name in ipairs({"ICC","SR","TOC"}) do local b=CreateFrame("Button",nil,content,"UIPanelButtonTemplate") b:SetSize(80,22) b:SetPoint("TOPLEFT",(idx-1)*90,0) b:SetText(name) b:SetScript("OnClick", function() build(name) end) end
  build("ICC") frame:Hide() return frame
end
function SRA_ShowMenu() local m=createMenu() if m:IsShown() then m:Hide() else m:Show() end end
