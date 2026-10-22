local _, SRA = ...
SRA.EPGP = {}
SRA_EPGPLog = SRA_EPGPLog or {}
SRA_Options = SRA_Options or {}
-- Precios GP tu guild - AJUSTA SEGUN TU GUILD
SRA.EPGP.Prices = {
 [40395]=1500, [50362]=2000, [50363]=2200, [50734]=3000, [50735]=3000, [50736]=3000,
 [50632]=2500, [50818]=2200, [50819]=2200, [50340]=1800, [50341]=1800, [50342]=1800,
 [50365]=1500, [50719]=2000, [50182]=2000,
}
function SRA.EPGP.IsMaster()
 if not IsInGuild() then return false end
 if IsGuildLeader() then return true end
 if EPGP and EPGP.CanChangeRule and EPGP:CanChangeRule() then return true end
 local rankIndex = select(3, GetGuildInfo("player"))
 if rankIndex and rankIndex <=1 then return true end
 return false
end
function SRA.EPGP.CanUse()
 if not SRA_Options.isLeader then return false end
 return SRA.EPGP.IsMaster()
end
function SRA.EPGP.GetPlayerEPGP(player)
 if not EPGP or not EPGP.GetEPGP then return nil end
 local EP, GP, main = EPGP:GetEPGP(player)
 if not EP then return nil end
 local PR = 0
 if GP and GP>0 then PR=EP/GP else PR=EP end
 return EP, GP, PR
end
function SRA.EPGP.AwardGP(player, itemID, customGP)
 if not SRA.EPGP.CanUse() then
  print("|cffff0000SRA EPGP:|r No tienes Rango Master/Oficial Guild para descontar EPGP")
  print("|cffff0000Solo Master Guild o Rango Oficial puede usar EPGP|")
  return false
 end
 local gpCost = customGP or SRA.EPGP.Prices[itemID] or 1000
 local EP, GP, PR = SRA.EPGP.GetPlayerEPGP(player)
 if EPGP and EPGP.IncGPBy then
  local reason = "SRA v7.0 - Item "..itemID.." - "..(SRA.GetItemLinkSafe(itemID) or itemID)
  EPGP:IncGPBy(player, reason, gpCost)
  local newEP, newGP = EPGP:GetEPGP(player)
  local newPR = newEP/newGP
  SendChatMessage(">> EPGP: "..player.." -"..gpCost.." GP por "..SRA.GetItemLinkSafe(itemID).." | EP:"..newEP.." GP:"..newGP.." PR:"..string.format("%.2f",newPR), "OFFICER")
  SendChatMessage(">> Ganaste "..SRA.GetItemLinkSafe(itemID).." -"..gpCost.." GP - PR: "..string.format("%.2f",newPR), "WHISPER", nil, player)
  if SRA_Options.screenshot then Screenshot() end
  table.insert(SRA_EPGPLog, {time=date("%Y-%m-%d %H:%M"), player=player, item=itemID, gp=gpCost, ep=EP, pr=PR})
  print("|cffff8000SRA EPGP GOD:|r "..player.." -"..gpCost.." GP | PR "..string.format("%.2f",PR).." -> "..string.format("%.2f",newPR))
  return true
 else
  print("|cffff0000SRA:|r EPGP addon no encontrado - Instala EPGP (dkp reloaded)")
  return false
 end
end
function SRA.EPGP.AddEP(player, amount, reason)
 if not SRA.EPGP.CanUse() then print("|cffff0000SRA EPGP:|r Solo Master puede agregar EP") return false end
 if EPGP and EPGP.IncEPBy then
  EPGP:IncEPBy(player, reason or "SRA v7.0 - Raid EP", amount)
  SendChatMessage(">> EPGP: +"..amount.." EP para "..player.." - "..(reason or "Raid"), "OFFICER")
  return true
 end
 return false
end
-- Hook DirectLoot para auto descuento GP si es Master
local oldDirectLootFn = SRA.DirectLoot
function SRA.DirectLoot(player, itemID, lootSlot)
 if oldDirectLootFn then oldDirectLootFn(player, itemID, lootSlot) end
 if SRA.EPGP.IsMaster() and SRA_Options.directLoot then
  SRA.Utils.schedule(1, function() SRA.EPGP.AwardGP(player, itemID) end)
 end
end
SLASH_SRAEPGP1 = "/sraepgp"
SLASH_SRAEPGP2 = "/sepgp"
SlashCmdList["SRAEPGP"] = function(msg)
 msg = (msg or ""):trim()
 if msg=="" then
  local EP, GP, PR = SRA.EPGP.GetPlayerEPGP(UnitName("player"))
  if EP then print("|cffff8000SRA EPGP:|r Tu EP: "..EP.." | GP: "..GP.." | PR: "..string.format("%.2f",PR)) else print("|cffff0000SRA EPGP:|r No EPGP - ¿Tienes addon EPGP instalado?") end
  return
 end
 local cmd, rest = msg:match("^(%S+)%s*(.*)$")
 if cmd=="award" then
  local itemID, player, gp = rest:match("(%d+)%s+(%S+)%s*(%d*)")
  if itemID and player then SRA.EPGP.AwardGP(player, tonumber(itemID), tonumber(gp)) else print("Uso: /sraepgp award <itemID> <jugador> [GP] Ej: /sraepgp award 50362 Seth 2000") end
 elseif cmd=="ep" then
  local player, amount = rest:match("(%S+)%s+(%d+)")
  if player and amount then SRA.EPGP.AddEP(player, tonumber(amount), "SRA Manual EP") else print("Uso: /sraepgp ep <jugador> <cantidad> Ej: /sraepgp ep Seth 1000") end
 elseif cmd=="check" then
  local player = rest:match("(%S+)") or UnitName("player")
  local EP, GP, PR = SRA.EPGP.GetPlayerEPGP(player)
  if EP then print("|cffff8000EPGP "..player..":|r EP:"..EP.." GP:"..GP.." PR:"..string.format("%.2f",PR)) else print("No EPGP para "..player) end
 else
  print("Comandos: /sraepgp (ver tu EP) | /sraepgp award <ID> <jug> [GP] | /sraepgp ep <jug> <cant> | /sraepgp check <jug>")
 end
end
print("|cffff8000SRA EPGP Bridge v7.0|r Cargado - Master: "..tostring(SRA.EPGP.IsMaster()).." - Usa /sraepgp")
