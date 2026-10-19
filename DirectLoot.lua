function SRA_DirectLoot(player, itemID)
  local link=SRA_GetItemLink(itemID)
  SendChatMessage("Ganaste "..link.." - "..player, "RAID")
  SendChatMessage("Ganaste "..link.." - Loot Direct Naerzone activo", "WHISPER", nil, player)
end
function SRA_FinishRoll(itemID) for p,res in pairs(SRA_SRReserve) do if tostring(res)==tostring(itemID) then SRA_DirectLoot(p,itemID) return end end end
