SRA105DB = SRA105DB or {}
SRA105DB.srList = SRA105DB.srList or {}
SRA_SRReserve = SRA_SRReserve or {}
SRA_TrinketDB = SRA_TrinketDB or {}

-- DB Correcta ICC Naerzone
SRA_TrinketDB={
    Testamento={ [40395]=true, [44577]=true, [50363]=true, [50365]=true, [50366]=true, [47131]=true }, -- H/L Normal
    Muerte={ [47115]=true, [47213]=true, [50362]=true, [50364]=true, [47132]=true }, -- Eleccion + Escama
    DBW={ [47303]=true, [47115]=true, [50362]=true, [50363]=true }, -- DBW fix
    BIS={ [50734]=true, [50735]=true, [50736]=true, [50818]=true, [50819]=true }, -- LK25H
}

local function SRA_GetItemLinkSafe(id)
    if not id then return "[Item ?]" end
    if SRA_GetItemLink then
        local ok, link = pcall(SRA_GetItemLink, id)
        if ok and link and link~="" then return link end
    end
    local num = tonumber(id)
    if num then
        local _, link = GetItemInfo(num)
        return link or ("|cFFa335ee|Hitem:"..num.."::::::::80:::::|h[Item:"..num.."]|h|r")
    end
    return tostring(id)
end

function SRA_AddSR(p,id)
    SRA105DB.srList = SRA105DB.srList or {}
    SRA_SRReserve = SRA_SRReserve or {}
    
    if not p or not id then print("|cFFFF0000Seth: SR sin player/id|r") return end
    
    pcall(function()
        SRA_SRReserve[p]=id
        SRA105DB.srList[p] = SRA105DB.srList[p] or {}
        SRA105DB.srList[p].id = id
        SRA105DB.srList[p].time = date("%H:%M:%S")
        
        local link = SRA_GetItemLinkSafe(id)
        print("|cffff0000SR:|r "..p.." reservo "..link)
        if IsInRaid() then SendChatMessage("SR: "..p.." -> "..link, "RAID") end
    end)
end

function SRA_IsAlt(name)
    if not name then return false end
    SRA105DB.srList = SRA105DB.srList or {}
    if not SRA105DB.srList[name] then return false end
    return SRA105DB.srList[name].isAlt == true
end

function SRA_GetTrinketType(itemID)
    if not itemID then return nil end
    local num = tonumber(itemID)
    if not num then return nil end
    for tipo, db in pairs(SRA_TrinketDB) do
        if db[num] then return tipo end
    end
    return nil
end

print("|cFF00FF00Seth: Trinkets v6.2 DB OK - 3War 2DK balance|r")
