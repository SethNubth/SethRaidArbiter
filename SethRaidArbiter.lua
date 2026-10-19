-- SethRaidArbiter FINAL - Naerzone Fix 11s + Auto Grupos
local f = CreateFrame("Frame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("RAID_ROSTER_UPDATE")
f:RegisterEvent("CHAT_MSG_WHISPER")

-- 1. FIX MUTE 11s
if not SRA105DB then SRA105DB = {} end
SRA105DB.scanFreq = 11 -- Naerzone: si es 10s te mutea 15s

-- Funcion para mover segun tus grupos
local function SRA_GetTargetGroup(role)
    if role == "HEAL" then return 5 -- Heal 5
    elseif role == "TANK" then return 3 -- 2 tanks al 3
    elseif role == "MELE" then
        local c1, c2 = 0, 0
        for i=1, GetNumGroupMembers() do
            local _, _, s = GetRaidRosterInfo(i)
            if s == 1 then c1=c1+1 end
            if s == 2 then c2=c2+1 end
        end
        return (c1 <= c2) and 1 or 2 -- Meles 1/2
    elseif role == "RNGS" or role == "RDOS" or role == "CASTER" then
        local c3, c4 = 0, 0
        for i=1, GetNumGroupMembers() do
            local _, _, s = GetRaidRosterInfo(i)
            if s == 3 then c3=c3+1 end
            if s == 4 then c4=c4+1 end
        end
        return (c3 <= c4) and 4 or 3 -- Caster 4/3
    end
    return 5
end

f:SetScript("OnEvent", function(self, event, arg1, arg2)
    if not SRA105DB.spamActive then return end

    -- A) AUTO UPDATE de 12/25 cuando entra gente
    if event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE" then
        local current = GetNumGroupMembers()
        if current == 0 then current = 1 end
        if SRA105DB.spamText then
            local newText = SRA105DB.spamText:gsub("(%d+)/25", current.."/25")
            newText = newText:gsub("GROUPS %d+", "GROUPS "..current)
            newText = newText:gsub("GRUPS %d+", "GRUPS "..current)
            SRA105DB.spamText = newText
            if SpamTextBox then SpamTextBox:SetText(newText) end
        end
        if currentCountText then
            currentCountText:SetText("current in Rgds: "..(25-current))
        end
        return
    end

    -- B) AUTO SORT por susurro - Heal 5 / Caster 4/3 / Tank 3 / Mele 1/2
    if event == "CHAT_MSG_WHISPER" then
        if not IsInRaid() then return end
        if not IsRaidLeader() and not IsRaidOfficer() then return end
        local msg = arg1:lower()
        local sender = arg2
        local role = nil
        if msg:find("heal") then role = "HEAL"
        elseif msg:find("tank") or msg:find("tanke") then role = "TANK"
        elseif msg:find("mele") or msg:find("war") or msg:find("dk") or msg:find("rogue") or msg:find("pala ret") then role = "MELE"
        elseif msg:find("caster") or msg:find("mago") or msg:find("lock") or msg:find("rango") or msg:find("hunt") then role = "RNGS"
        end
        if not role then return end
        for i=1, GetNumGroupMembers() do
            local name = GetRaidRosterInfo(i)
            if name and sender:find(name) then
                SetRaidSubgroup(i, SRA_GetTargetGroup(role))
                SendChatMessage("Seth: "..name.." -> G"..SRA_GetTargetGroup(role).." ("..role..")", "RAID")
                break
            end
        end
    end
end)

-- C) Tu funcion de rol manual
function SRA_MoveToRoleGroup(role)
    if not IsRaidLeader() and not IsRaidOfficer() then return end
    for i=1, GetNumGroupMembers() do
        if GetRaidRosterInfo(i) == UnitName("player") then
            SetRaidSubgroup(i, SRA_GetTargetGroup(role))
            break
        end
    end
end

print("|cFF00FF00SethRaidArbiter FINAL cargado - 11s AntiMute - Grupos Heal5/Caster4/3/Tank3/Mele1/2|r")
