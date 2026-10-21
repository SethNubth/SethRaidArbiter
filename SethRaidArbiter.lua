-- SethRaidArbiter.lua FINAL v1.1 - Naerzone 11s AntiMute + Auto Grupos Heal5/Caster4/3/Tank3/Mele1/2
local ADDON_NAME = "SethRaidArbiter"
if not SRA105DB then SRA105DB = {} end
SRA105DB.scanFreq = 11
SRA105DB.spamActive = SRA105DB.spamActive or false

local function SRA_GetNumRaid()
    -- Fix 30300 vs 30403
    if GetNumGroupMembers then
        return GetNumGroupMembers()
    else
        return GetNumRaidMembers()
    end
end

local coreFrame = CreateFrame("Frame")
coreFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
coreFrame:RegisterEvent("RAID_ROSTER_UPDATE")
coreFrame:RegisterEvent("CHAT_MSG_WHISPER")
coreFrame:RegisterEvent("ADDON_LOADED")

local function SRA_GetTargetGroup(role)
    if role == "HEAL" then return 5
    elseif role == "TANK" then return 3
    elseif role == "MELE" then
        local c1, c2 = 0, 0
        for i=1, SRA_GetNumRaid() do
            local _, _, s = GetRaidRosterInfo(i)
            if s == 1 then c1=c1+1 end
            if s == 2 then c2=c2+1 end
        end
        return (c1 <= c2) and 1 or 2
    elseif role == "RNGS" or role == "RDOS" or role == "CASTER" then
        local c3, c4 = 0, 0
        for i=1, SRA_GetNumRaid() do
            local _, _, s = GetRaidRosterInfo(i)
            if s == 3 then c3=c3+1 end
            if s == 4 then c4=c4+1 end
        end
        return (c3 <= c4) and 4 or 3
    end
    return 5
end

function SRA_MoveToRoleGroup(role)
    if not IsInRaid() then return end
    if not (IsRaidLeader() or IsRaidOfficer()) then return end
    for i=1, SRA_GetNumRaid() do
        local name = GetRaidRosterInfo(i)
        if name == UnitName("player") then
            SetRaidSubgroup(i, SRA_GetTargetGroup(role))
            print("|cFF00FF00Seth:|r Movido a Grupo "..SRA_GetTargetGroup(role).." ("..role..")")
            break
        end
    end
end

coreFrame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        SRA105DB.scanFreq = 11
        return
    end

    if event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE" then
        if not SRA105DB.spamActive then return end
        local current = SRA_GetNumRaid()
        if current == 0 then current = 1 end
        if SRA105DB.spamText and _G.SpamTextBox then
            local newText = SRA105DB.spamText:gsub("(%d+)/25", current.."/25")
            newText = newText:gsub("GROUPS %d+", "GROUPS "..current)
            SRA105DB.spamText = newText
            _G.SpamTextBox:SetText(newText)
        end
        if _G.currentCountText then
            _G.currentCountText:SetText("current in Rgds: "..(25-current))
        end
        return
    end

    if event == "CHAT_MSG_WHISPER" then
        if not IsInRaid() then return end
        if not (IsRaidLeader() or IsRaidOfficer()) then return end
        local msg = string.lower(arg1 or "")
        local sender = arg2 or ""
        local role = nil
        if msg:find("heal") then role = "HEAL"
        elseif msg:find("tank") or msg:find("tanke") or msg:find("tanq") then role = "TANK"
        elseif msg:find("mele") or msg:find("war") or msg:find("dk") or msg:find("rogue") or msg:find("ret") then role = "MELE"
        elseif msg:find("caster") or msg:find("mago") or msg:find("lock") or msg:find("rango") or msg:find("hunt") or msg:find("boomie") then role = "RNGS"
        end
        if not role then return end
        for i=1, SRA_GetNumRaid() do
            local name = GetRaidRosterInfo(i)
            if name and sender:find(name) then
                SetRaidSubgroup(i, SRA_GetTargetGroup(role))
                SendChatMessage("Seth: "..name.." -> G"..SRA_GetTargetGroup(role).." ("..role..") Heal5/Caster4/3/Tank3/Mele1/2", "RAID")
                break
            end
        end
    end
end)

print("|cFF00FF00SethRaidArbiter|r v1.1 FINAL - 11s AntiMute - Heal5/Caster4/3/Tank3/Mele1/2 OK")
