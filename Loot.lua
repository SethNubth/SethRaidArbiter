local epicICC={
    [40395]=true, -- Test de epicos que tenias
    [44577]=true, -- Llave heroica
    [47115]=true, [47116]=true,
    [47213]=true,
    [50362]=true, [50363]=true, -- DBW
    [50734]=true, [50735]=true, [50736]=true, -- Armas LK25H
    [50818]=true, [50819]=true, -- Anillos LK25H
    [50365]=true, [50366]=true, [50364]=true, -- Testamentos
    [47131]=true, [47132]=true, [47133]=true, -- Escamas etc
}

SRA105DB = SRA105DB or {}
local lastAlert = 0

local lootF=CreateFrame("Frame") 
lootF:RegisterEvent("CHAT_MSG_LOOT")
lootF:RegisterEvent("PLAYER_ENTERING_WORLD")

lootF:SetScript("OnEvent", function(self,event,msg)
  if event=="PLAYER_ENTERING_WORLD" then
      SRA105DB.autoEpic = SRA105DB.autoEpic == nil and true or SRA105DB.autoEpic
      return
  end
  
  if not SRA105DB.autoEpic then return end
  if InCombatLockdown() then return end
  if not IsInRaid() then return end
  
  local id=msg and msg:match("item:(%d+)")
  if not id then return end
  
  local numId = tonumber(id)
  if not numId then return end
  if not epicICC[numId] then return end
  
  -- Anti spam 11 segundos (taberna Naerzone)
  local now = GetTime()
  if now - lastAlert < 11 then return end
  lastAlert = now
  
  -- GetItemInfo puede ser nil si no está cacheado
  local itemName, link = GetItemInfo(numId)
  if not link then
      link = "|cFFa335ee|Hitem:"..numId.."::::::::80:::::|h["..(itemName or "Item:"..numId).."]|h|r"
  end
  
  if IsInRaid() then
      SendChatMessage("EPICO DETECTADO: "..link.." - Preparando roll SR [Seth v6.2]","RAID")
  else
      print("Seth: Epico: "..link)
  end
end)

print("|cFF00FF00Seth: Loot scan 11s OK|r")
