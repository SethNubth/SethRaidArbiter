-- Control Agonia - Solo 1ra cuenta - Seth Naerzone v6.2
SRA105DB = SRA105DB or {}
SRA105DB.srList = SRA105DB.srList or {}
SRA_L = SRA_L or {}

local AGONIA_ITEMS = {
    [45038]=true, -- Fragmento de Agonia
    [50274]=true, -- Agonia de Sombras
    [50276]=true, [50277]=true, [50278]=true, -- Infusion
}

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", function(self, event, msg)
    if event == "PLAYER_ENTERING_WORLD" then
        SRA105DB.mainAccount = SRA105DB.mainAccount or UnitName("player")
        return
    end

    if not msg then return end
    local id = msg:match("item:(%d+)")
    if not id then return end
    
    local numId = tonumber(id)
    if not AGONIA_ITEMS[numId] then return end

    local player = msg:match("^(.-) recibe bot") or msg:match("^(.-) recibe") or UnitName("player")
    
    pcall(function()
        -- Bloquea si es ALT
        if SRA_IsAlt and SRA_IsAlt(player) then
            local _, link = GetItemInfo(numId)
            link = link or SRA_L["AGONIA"]
            SendChatMessage(">> BLOQUEO AGONIA: "..player.." es ALT - Solo 1ra cuenta ["..(SRA105DB.mainAccount or "Main").."] <<", "RAID_WARNING")
            print("|cFFFF0000Seth: Bloqueo Agonia "..player.." es ALT - "..link.."|r")
            return
        end

        -- Si es main, permite
        local _, link = GetItemInfo(numId)
        link = link or SRA_L["AGONIA"]
        if IsInRaid() then
            SendChatMessage("AGONIA: "..link.." -> "..player.." - 1ra cuenta OK", "RAID")
        end
        print("|cFF00FF00Seth: Agonia OK "..player.." -> "..link.."|r")
    end)
end)

print("|cFFa335eeSeth: Control Agonia solo 1ra cuenta activo - Main: "..(SRA105DB.mainAccount or UnitName("player")).."|r")
