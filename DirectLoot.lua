SRA_SRReserve = SRA_SRReserve or {}
SRA105DB = SRA105DB or {}

local function SRA_GetItemLinkSafe(id)
    if not id then return "|cFFFF0000Item desconocido|r" end
    if SRA_GetItemLink then
        local ok, link = pcall(SRA_GetItemLink, id)
        if ok and link and link~="" then return link end
    end
    local num = tonumber(id)
    if num then
        local _, link = GetItemInfo(num)
        if link then return link end
        return "|cFFa335ee|Hitem:"..num.."::::::::80:::::|h[Item:"..num.."]|h|r"
    end
    return tostring(id)
end

function SRA_DirectLoot(player, itemID)
    if not player or not itemID then print("|cFFFF0000Seth: DirectLoot sin player/item|r") return end
    if not IsInRaid() and not IsInGroup() then print("|cFFFF0000Seth: No en grupo|r") return end
    
    local link=SRA_GetItemLinkSafe(itemID)
    
    pcall(function()
        if IsInRaid() then
            SendChatMessage(">> Ganaste "..link.." - "..player.." - Loot Direct <<", "RAID_WARNING")
            SendChatMessage("Ganaste "..link.." - "..player, "RAID")
        end
        SendChatMessage("Ganaste "..link.." - Loot Direct Naerzone activo - Tradeame", "WHISPER", nil, player)
        print("|cFF00FF00Seth: Direct Loot "..player.." -> "..link.."|r")
    end)
end

function SRA_FinishRoll(itemID)
    if not itemID then return end
    SRA_SRReserve = SRA_SRReserve or {}
    
    pcall(function()
        for p,res in pairs(SRA_SRReserve) do
            if tostring(res)==tostring(itemID) then 
                SRA_DirectLoot(p,itemID) 
                SRA_SRReserve[p]=nil -- limpia SR
                return 
            end
        end
        print("|cFFFFFF00Seth: Nadie reservo item "..tostring(itemID).."|r")
    end)
end
