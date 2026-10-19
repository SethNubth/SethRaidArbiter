local frame, currentTab

local function SRA_SafeInitDB(tab)
    tab = tab:lower()
    SRA105DB = SRA105DB or {}
    SRA105DB[tab] = SRA105DB[tab] or {}
    SRA105DB[tab.."_id"] = SRA105DB[tab.."_id"] or {}
    for i=1,35 do
        SRA105DB[tab][i] = SRA105DB[tab][i] or ""
        SRA105DB[tab.."_id"][i] = SRA105DB[tab.."_id"][i] or ""
    end
end

local function SRA_GetItemLinkSafe(idTxt)
    if not idTxt or idTxt=="" then return "" end
    if SRA_GetItemLink then
        local ok, link = pcall(SRA_GetItemLink, idTxt)
        if ok and link then return link end
    end
    local id = tonumber(idTxt)
    if id then
        local _, link = GetItemInfo(id)
        return link or ""
    end
    return ""
end

local function createMenu()
  if frame then return frame end
  SRA105DB = SRA105DB or {}
  
  frame=CreateFrame("Frame","SRAFrame",UIParent,"BasicFrameTemplateWithInset")
  frame:SetSize(820,580) frame:SetPoint("CENTER") 
  frame:SetMovable(true) frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton") 
  frame:SetScript("OnDragStart", function(s) if not InCombatLockdown() then s:StartMoving() end end) 
  frame:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  frame.TitleText:SetText("SethRaidArbiter - 35x3 + BIS v6.2 |cffff0000Naerzone|r")
  frame:Hide()
  
  local content=CreateFrame("Frame",nil,frame) 
  content:SetPoint("TOPLEFT",15,-60) content:SetPoint("BOTTOMRIGHT",-15,15)
  
  local scroll=CreateFrame("ScrollFrame",nil,content,"UIPanelScrollFrameTemplate") 
  scroll:SetPoint("TOPLEFT",0,-30) scroll:SetPoint("BOTTOMRIGHT",-25,0)
  
  local inner=CreateFrame("Frame",nil,scroll) 
  inner:SetSize(750,1350) 
  scroll:SetScrollChild(inner)

  local function build(tab)
    if InCombatLockdown() then print("|cFFFF0000Seth: No en combate|r") return end
    currentTab=tab:lower()
    SRA_SafeInitDB(currentTab)
    
    -- Limpia hijos sin error
    local children = {inner:GetChildren()}
    for _,c in ipairs(children) do if c then c:Hide() c:SetParent(nil) end end
    
    local db=SRA105DB[currentTab]
    local dbId=SRA105DB[currentTab.."_id"]
    
    for i=1,35 do
      local row=CreateFrame("Frame",nil,inner) 
      row:SetSize(740,32) row:SetPoint("TOPLEFT",0,-(i-1)*36) row:Show()
      
      local lbl=row:CreateFontString(nil,"OVERLAY","GameFontNormalSmall") 
      lbl:SetPoint("LEFT",0,0) lbl:SetWidth(30) lbl:SetText(i)
      
      local eb=CreateFrame("EditBox",nil,row,"InputBoxTemplate") 
      eb:SetSize(420,24) eb:SetPoint("LEFT",35,0) eb:SetAutoFocus(false) 
      eb:SetText(db[i] or "")
      eb:SetScript("OnEnterPressed", function(s) 
          if SRA105DB[currentTab] then SRA105DB[currentTab][i]=s:GetText() end
          s:ClearFocus() 
      end) 
      eb:SetScript("OnEditFocusLost", function(s) 
          if SRA105DB[currentTab] then SRA105DB[currentTab][i]=s:GetText() end
      end)
      
      local eb2=CreateFrame("EditBox",nil,row,"InputBoxTemplate") 
      eb2:SetSize(90,24) eb2:SetPoint("LEFT",eb,"RIGHT",8,0) eb2:SetAutoFocus(false) 
      eb2:SetText(dbId[i] or "")
      eb2:SetScript("OnEnterPressed", function(s) 
          if SRA105DB[currentTab.."_id"] then SRA105DB[currentTab.."_id"][i]=s:GetText() end
          s:ClearFocus() 
      end)
      
      local btn=CreateFrame("Button",nil,row,"UIPanelButtonTemplate") 
      btn:SetSize(75,22) btn:SetPoint("LEFT",eb2,"RIGHT",8,0) btn:SetText("LANZAR")
      btn:SetScript("OnClick", function() 
          local txt = SRA105DB[currentTab] and SRA105DB[currentTab][i] or ""
          local idTxt = SRA105DB[currentTab.."_id"] and SRA105DB[currentTab.."_id"][i] or ""
          if txt and txt~="" then 
              local link=SRA_GetItemLinkSafe(idTxt) 
              local msg = link~="" and txt.." "..link or txt
              if IsInRaid() then SendChatMessage(msg,"RAID_WARNING") else SendChatMessage(msg,"SAY") end
          end 
      end)
    end
  end
  
  for idx,name in ipairs({"ICC","SR","TOC"}) do 
      local b=CreateFrame("Button",nil,content,"UIPanelButtonTemplate") 
      b:SetSize(80,22) b:SetPoint("TOPLEFT",(idx-1)*90,0) b:SetText(name) 
      b:SetScript("OnClick", function() build(name) end) 
  end
  
  build("ICC") 
  return frame
end

function SRA_ShowMenu() 
    if InCombatLockdown() then print("|cFFFF0000Seth: No abras menú en combate - taint|r") return end
    local ok, m = pcall(createMenu)
    if not ok or not m then print("|cFFFF0000Seth Error Menu:|r "..tostring(m)) return end
    if m:IsShown() then m:Hide() else m:Show() end 
end
