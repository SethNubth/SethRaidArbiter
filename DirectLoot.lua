local _, SRA = ...
SRA_SR = SRA_SR or {}
SRA_Options = SRA_Options or {}
SRA_Raids = SRA_Raids or {}

function SRA.DirectLoot(player, itemID, lootSlot)
 if not player or not itemID then return end
 -- FIX GOD: Si Utils no existe, no bloquees
 if SRA.Utils and SRA.Utils.CanLoot and not SRA.Utils.CanLoot() then return end
 
 local link = SRA.GetItemLinkSafe(itemID)
 local targetPlayer = player
 
 -- Buscar indice de raid - FIX case insensitive + acentos
 local raidIndex = nil
 local numRaid = GetNumRaidMembers()
 if numRaid == 0 then
   -- Puede ser party o solo
   print("|cffff8000SRA SR:|r No estas en raid, no puedo dar loot")
   return
 end
 
 for i=1,numRaid do
  local name = GetRaidRosterInfo(i)
  if name then
    if name:lower()==player:lower() or name:find(player, 1, true) then
     raidIndex = i
     targetPlayer = name -- Nombre exacto con mayusculas
     break
    end
  end
 end
 
 if not raidIndex then
  print("|cffff8000SRA SR:|r Jugador "..player.." no encontrado en raid")
  -- Igual lo logueamos por si es reserva externa
  table.insert(SRA_Raids, {time=date("%Y-%m-%d %H:%M"), player=player, item=itemID, type="SR-NO-RAID"})
  return
 end
 
 if SRA_Options.screenshot then
  Screenshot()
 end
 
 SendChatMessage(">> SR: "..link.." RESERVADO PARA "..targetPlayer.." - Trade auto", "RAID_WARNING")
 SendChatMessage(">> SR: "..targetPlayer.." gana "..link.." por SoftReserve", "RAID")
 SendChatMessage(">> Ganaste "..link.." por SR - Susurra al Master para trade", "WHISPER", nil, targetPlayer)
 
 if lootSlot then
  -- FIX GOD: Solo si eres Master Looter de verdad
  local lootMethod, masterID = GetLootMethod()
  if lootMethod=="master" and masterID==0 then
    -- Delay pequeño para que el server registre el loot
    local f = CreateFrame("Frame")
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, e)
      elapsed = elapsed + e
      if elapsed > 0.5 then
        self:SetScript("OnUpdate", nil)
        GiveMasterLoot(lootSlot, raidIndex)
        print("|cFF00FF00SRA DirectLoot GOD:|r Loot dado a "..targetPlayer)
      end
    end)
  else
    print("|cffff8000SRA SR:|r No eres Master Looter, avisa manual")
  end
 end
 
 -- Guardar en log
 table.insert(SRA_Raids, {time=date("%Y-%m-%d %H:%M"), player=targetPlayer, item=itemID, type="SR"})
 print("|cffff8000SRA DirectLoot GOD:|r "..link.." -> "..targetPlayer)
end

SLASH_SRASR1 = "/srasr"
SlashCmdList["SRASR"] = function(msg)
 msg = msg or ""
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
