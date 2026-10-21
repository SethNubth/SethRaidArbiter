-- SethRaidArbiter.lua FINAL v1.2 - Naerzone 11s AntiMute + Auto Grupos + SpamBuilder GOD
local ADDON_NAME = "SethRaidArbiter"
if not SRA105DB then SRA105DB = {} end
SRA105DB.scanFreq = 11
SRA105DB.spamActive = SRA105DB.spamActive or false

-- FIX 30300 GLOBAL para SpamBuilder
function SRA_GetNumRaid()
    if GetNumGroupMembers then
        return GetNumGroupMembers()
    else
        return GetNumRaidMembers()
    end
end

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

-- === RAID SPAM CORE 11s Anti-Mute Naerzone ===
SRA105DB.spamChannel = SRA105DB.spamChannel or "AUTO"
local spamFrame = CreateFrame("Frame")
local spamTicker = 0
local lastSpamMsg = ""

local function SRA_GetSpamChannel()
    local channels = {GetChannelList()}
    for i=1, #channels, 2 do
        local name = channels[i+1] and string.lower(channels[i+1]) or ""
        if name:find("taberna") then return channels[i] end
        if name:find("6578") or name:find("world") then return channels[i] end
    end
    for i=1, #channels, 2 do
        local name = channels[i+1] and string.lower(channels[i+1]) or ""
        if name:find("comercio") or name:find("trade") then return channels[i] end
    end
    return 2
end

local function SRA_DoSpam()
    if not SRA105DB.spamActive then return end
    if not SRA105DB.spamText or SRA105DB.spamText == "" then return end
    if InCombatLockdown() then return end
    local msg = SRA105DB.spamText
    if msg == lastSpamMsg then msg = msg.." " end
    lastSpamMsg = SRA105DB.spamText
    local chanID = SRA_GetSpamChannel()
    SendChatMessage(msg, "CHANNEL", nil, chanID)
    print("|cFF00FF00Seth Spam:|r -> Canal "..chanID.." : "..msg)
end

spamFrame:SetScript("OnUpdate", function(self, elapsed)
    if not SRA105DB.spamActive then return end
    spamTicker = spamTicker + elapsed
    if spamTicker >= (SRA105DB.scanFreq or 11) then
        spamTicker = 0
        SRA_DoSpam()
    end
end)

function SRA_StartSpam(text)
    if not text or text == "" then print("|cFFFF0000Seth: Sin texto spam|r") return end
    SRA105DB.spamText = text
    SRA105DB.spamActive = true
    spamTicker = 0
    local found = false
    for _, name in ipairs({GetChannelList()}) do
        if type(name)=="string" and (string.lower(name):find("taberna") or name:find("6578")) then found=true end
    end
    if not found then
        JoinChannelByName("Taberna")
        print("|cFFFFFF00Seth: Auto Join Taberna|r")
        C_Timer.After(1, function() SRA_DoSpam() end)
    else
        SRA_DoSpam()
    end
    print("|cFF00FF00Seth: Spam 11s ON en Taberna/6578|r")
end

function SRA_StopSpam()
    SRA105DB.spamActive = false
    print("|cFFFF0000Seth: Spam OFF|r")
end

-- CORE FRAME
local coreFrame = CreateFrame("Frame")
coreFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
coreFrame:RegisterEvent("RAID_ROSTER_UPDATE")
coreFrame:RegisterEvent("CHAT_MSG_WHISPER")
coreFrame:RegisterEvent("ADDON_LOADED")

coreFrame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        SRA105DB.scanFreq = 11
        return
    end
    if event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE" then
        if not SRA105DB.spamActive then return end
        local current = SRA_GetNumRaid()
        if current == 0 then current = 1 end
        if SRA105DB.spamText then
            local newText = SRA105DB.spamText:gsub("(%d+)/25", current.."/25")
            newText = newText:gsub("(%d+)/10", current.."/10")
            SRA105DB.spamText = newText
            if _G.SpamTextBox then _G.SpamTextBox:SetText(newText) end
            if _G.SRA_Spam_Preview then _G.SRA_Spam_Preview:SetText(newText) end
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
                SendChatMessage("Seth: "..name.." -> G"..SRA_GetTargetGroup(role).." ("..role..")", "RAID")
                break
            end
        end
    end
end)

SLASH_SRA1 = "/sra"
SLASH_SRA2 = "/seth"
SlashCmdList["SRA"] = function(msg)
    msg = msg and msg:lower() or ""
    local raw = msg
    if msg:find("stop") then
        SRA_StopSpam()
    elseif msg:find("spam") or msg:find("start") then
        local text = raw:gsub("spam", ""):gsub("start", "")
        text = text:gsub("^%s+", "")
        if text ~= "" then SRA_StartSpam(text) else print("Uso: /sra spam Se arma ICC25N Need 5Meles...") end
    elseif msg:find("builder") or msg:find("menu") then
        if SRA_ShowSpamBuilder then SRA_ShowSpamBuilder() end
    else
        print("|cffffd700SethRaidArbiter v1.2|r: /sra spam <texto> | /sra stop | /spambuilder")
    end
end

print("|cFF00FF00SethRaidArbiter|r v1.2 FINAL - SpamBuilder GOD + 11s AntiMute - Heal5/Caster4/3/Tank3/Mele1/2 OK")
