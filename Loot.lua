local epicICC={[40395]=true,[44577]=true,[47115]=true,[47116]=true,[47213]=true,[50362]=true,[50363]=true}
local lootF=CreateFrame("Frame") lootF:RegisterEvent("CHAT_MSG_LOOT")
lootF:SetScript("OnEvent", function(_,_,msg)
  local id=msg:match("item:(%d+)")
  if id and epicICC[tonumber(id)] then local _,link=GetItemInfo(id) SendChatMessage("EPICO DETECTADO: "..(link or id).." - Preparando roll SR","RAID_WARNING") end
end)
