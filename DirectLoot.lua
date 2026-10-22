local _, SRA = ...
SRA_SR = SRA_SR or {}
SRA_Options = SRA_Options or {}
function SRA.DirectLoot(player, itemID, lootSlot)
 if not player or not itemID then return end
 if not SRA.Utils.CanLoot() then return end
 local link = SRA.GetItemLinkSafe(itemID)
 local targetPlayer = player
 -- Buscar indice de raid
 local raidIndex = nil
 for i=1,GetNumRaidMembers() do
  local name = GetRaidRosterInfo(i)
  if name and name:lower()==player:lower() then
   raidIndex = i
   targetPlayer = name
   break
  end
 end
 if not raidIndex then
  -- Puede ser fuera de raid o nombre con acentos
  print("|cffff8000SRA SR:|r Jugador "..player.." no encontrado en raid")
  return
 end
 if SRA_Options.screenshot then
  Screenshot()
 end
 SendChatMessage(">> SR: "..link.." RESERVADO PARA "..targetPlayer.." - Trade auto", "RAID_WARNING")
 SendChatMessage(">> SR: "..targetPlayer.." gana "..link.." por SoftReserve", "RAID")
 SendChatMessage(">> Ganaste "..link.." por SR - Susurra al Master para trade", "WHISPER", nil, targetPlayer)
 if lootSlot then
  -- Dar loot directo si es master looter
  if GetLootMethod()=="master" then
   local master = select(1, GetLootMethod())
   if master==0 then -- player is master
    GiveMasterLoot(lootSlot, raidIndex)
   end
  end
 end
 -- Guardar en log
 SRA_Raids = SRA_Raids or {}
 table.insert(SRA_Raids, {time=date("%Y-%m-%d %H:%M"), player=targetPlayer, item=itemID, type="SR"})
 print("|cffff8000SRA DirectLoot GOD:|r "..link.." -> "..targetPlayer)
end
SLASH_SRASR1 = "/srasr"
SlashCmdList["SRASR"] = function(msg)
 local itemID, player = msg:match("(%d+)%s+(%S+)")
 if not itemID or not player then
  print("Uso: /srasr <itemID> <jugador> Ej: /srasr 50362 Seth")
  print("Actual SR: ")
  for id, pl in pairs(SRA_SR) do
   print("  "..(SRA.GetItemLinkSafe(tonumber(id)) or id).." -> "..pl)
  end
  return
 end
 SRA_SR[tonumber(itemID)] = player
 print("|cffff8000SRA SR:|r "..(SRA.GetItemLinkSafe(tonumber(itemID)) or itemID).." reservado para "..player)
end
SLASH_SRACLEARSR1 = "/sraclearsr"
SlashCmdList["SRACLEARSR"] = function()
 SRA_SR = {}
 print("|cffff8000SRA SR:|r Reservas limpiadas")
end
