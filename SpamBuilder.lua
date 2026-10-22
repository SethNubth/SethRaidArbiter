-- SpamBuilder.lua - SethRaidArbiter v8.4.2 FINAL GOD
-- Menu + ON/OFF + Reset + Clear + Auto Taberna /5-/8

SRA105DB = SRA105DB or {}
local spamBuilderFrame = nil
local lastSpamTime = 0
local ANTI_MUTE_DELAY = 11
local spamActivo = false
local spamTicker = nil

-- === DETECTA TABERNA NAERZONE /5-/8 ===
local function SRA_GetTabernaChannel()
 for i=1,20 do
  local _, name = GetChannelName(i)
  if name and name:lower():find("taberna") then return i end
 end
 return nil
end

local function SRA_JoinTaberna()
 if SRA_Options and SRA_Options.autoTaberna == false then return end
 if not SRA_GetTabernaChannel() then JoinChannelByName("taberna") end
end

-- === BUILD SPAM - TU ESCRIBES LO QUE QUIERAS ARMAR ===
local function SRA_BuildSpamText()
    local raid = _G["SRA_Spam_Raid"] and _G["SRA_Spam_Raid"]:GetText() or ""
    local mode = _G["SRA_Spam_Mode"] and _G["SRA_Spam_Mode"]:GetText() or ""
    local melee = _G["SRA_Spam_Melee"] and _G["SRA_Spam_Melee"]:GetText() or ""
    local caster = _G["SRA_Spam_Caster"] and _G["SRA_Spam_Caster"]:GetText() or ""
    local heal = _G["SRA_Spam_Heal"] and _G["SRA_Spam_Heal"]:GetText() or ""
    local tank = _G["SRA_Spam_Tank"] and _G["SRA_Spam_Tank"]:GetText() or ""
    local gs = _G["SRA_Spam_GS"] and _G["SRA_Spam_GS"]:GetText() or ""
    local parts = {}
    if raid ~= "" or mode ~= "" then table.insert(parts, "Se arma "..raid..mode..":") else table.insert(parts, "Se arma:") end
    local needParts = {}
    if melee ~= "" and melee ~= "0" then table.insert(needParts, melee.." Meles") end
    if caster ~= "" and caster ~= "0" then table.insert(needParts, caster.." Caster") end
    if heal ~= "" and heal ~= "0" then table.insert(needParts, heal.." Heal") end
    if tank ~= "" and tank ~= "0" then table.insert(needParts, tank.." Tanke") end
    if #needParts > 0 then table.insert(parts, "Need: "..table.concat(needParts, " ")) end
    if gs ~= "" and gs ~= "0" then table.insert(parts, "GS: "..gs) end
    if SRA_GetNumRaid and SRA_GetNumRaid() > 0 then table.insert(parts, SRA_GetNumRaid().."/25") end
    local final = table.concat(parts, " ")
    if _G["SRA_Spam_Preview"] then _G["SRA_Spam_Preview"]:SetText(final) SRA105DB.lastSpamGenerated = final end
    return final
end

function SRA_StartSpam(text)
    if not spamActivo then return end
    SRA_JoinTaberna()
    local now = time()
    if SRA_Options and SRA_Options.antiMute ~= false and now - lastSpamTime < ANTI_MUTE_DELAY then return end
    lastSpamTime = now
    local msg = text or SRA_BuildSpamText()
    local tabChan = SRA_GetTabernaChannel()
    if tabChan then SendChatMessage(msg, "CHANNEL", nil, tabChan) end
    local genChan = GetChannelName("2. General") or 2
    SendChatMessage(msg, "CHANNEL", nil, genChan)
end

function SRA_StopSpam()
    spamActivo = false
    if spamTicker then spamTicker:Cancel() spamTicker = nil end
    if _G["SRA_Spam_ToggleBtn"] then _G["SRA_Spam_ToggleBtn"]:SetText("ENVIAR SPAM: OFF") _G["SRA_Spam_ToggleBtn"]:SetTextColor(1,0,0) end
    if _G["SRA_Spam_Status"] then _G["SRA_Spam_Status"]:SetText("|cffff0000● APAGADO - No spamea|r") end
    print("|cffff8000SRA:|r Spam APAGADO")
end

function SRA_ToggleSpam()
    if not spamActivo then
        spamActivo = true
        local txt = SRA_BuildSpamText()
        SRA_StartSpam(txt)
        spamTicker = C_Timer.NewTicker(ANTI_MUTE_DELAY, function() SRA_StartSpam() end)
        if _G["SRA_Spam_ToggleBtn"] then _G["SRA_Spam_ToggleBtn"]:SetText("ENVIAR SPAM: ON") _G["SRA_Spam_ToggleBtn"]:SetTextColor(0,1,0) end
        if _G["SRA_Spam_Status"] then _G["SRA_Spam_Status"]:SetText("|cff00ff00● ENVIADO - Cada 11s Taberna /"..(SRA_GetTabernaChannel() or "?").." + General|r") end
        print("|cff00ff00SRA:|r Spam ENCENDIDO")
    else
        SRA_StopSpam()
    end
end

-- === RESET / CLEAR ===
function SRA_ResetSpamBuilder()
    if _G["SRA_Spam_Raid"] then _G["SRA_Spam_Raid"]:SetText("ICC") end
    if _G["SRA_Spam_Mode"] then _G["SRA_Spam_Mode"]:SetText("25N") end
    if _G["SRA_Spam_Melee"] then _G["SRA_Spam_Melee"]:SetText("5") end
    if _G["SRA_Spam_Caster"] then _G["SRA_Spam_Caster"]:SetText("4") end
    if _G["SRA_Spam_Heal"] then _G["SRA_Spam_Heal"]:SetText("3") end
    if _G["SRA_Spam_Tank"] then _G["SRA_Spam_Tank"]:SetText("2") end
    if _G["SRA_Spam_GS"] then _G["SRA_Spam_GS"]:SetText("5.5") end
    SRA_StopSpam()
    SRA_BuildSpamText()
    print("|cffff8000SRA:|r Reset -> ICC 25N default")
end

function SRA_ClearSpamBuilder()
    if _G["SRA_Spam_Raid"] then _G["SRA_Spam_Raid"]:SetText("") end
    if _G["SRA_Spam_Mode"] then _G["SRA_Spam_Mode"]:SetText("") end
    if _G["SRA_Spam_Melee"] then _G["SRA_Spam_Melee"]:SetText("") end
    if _G["SRA_Spam_Caster"] then _G["SRA_Spam_Caster"]:SetText("") end
    if _G["SRA_Spam_Heal"] then _G["SRA_Spam_Heal"]:SetText("") end
    if _G["SRA_Spam_Tank"] then _G["SRA_Spam_Tank"]:SetText("") end
    if _G["SRA_Spam_GS"] then _G["SRA_Spam_GS"]:SetText("") end
    SRA_StopSpam()
    if _G["SRA_Spam_Preview"] then _G["SRA_Spam_Preview"]:SetText("") end
    print("|cffff8000SRA:|r Clear -> Todo vacío")
end

-- === FRAME PRINCIPAL ===
function SRA_ShowSpamBuilder()
    if spamBuilderFrame then if spamBuilderFrame:IsShown() then spamBuilderFrame:Hide() else spamBuilderFrame:Show() end return end
    local f = CreateFrame("Frame", "SRA_SpamBuilderFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(620, 320) f:SetPoint("CENTER") f:SetMovable(true) f:EnableMouse(true) f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(s) s:StartMoving() end) f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    f.TitleText:SetText("Seth Spam Builder v8.4.2 - FINAL GOD") spamBuilderFrame = f
    local function CreateLabel(text, x, y) local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall") lbl:SetPoint("TOPLEFT", 15 + x, -35 + y) lbl:SetText(text) return lbl end
    local function CreateEdit(name, w, x, y, default) local eb = CreateFrame("EditBox", name, f, "InputBoxTemplate") eb:SetSize(w, 24) eb:SetPoint("TOPLEFT", 15 + x, -50 + y) eb:SetAutoFocus(false) eb:SetText(default or "") eb:SetScript("OnTextChanged", function() SRA_BuildSpamText() end) return eb end
    CreateLabel("Raid:", 0, 0) CreateEdit("SRA_Spam_Raid", 70, 0, -15, "ICC")
    CreateLabel("Modo:", 80, 0) CreateEdit("SRA_Spam_Mode", 50, 80, -15, "25N")
    CreateLabel("Mele:", 145, 0) CreateEdit("SRA_Spam_Melee", 35, 145, -15, "5")
    CreateLabel("Caster:", 190, 0) CreateEdit("SRA_Spam_Caster", 35, 190, -15, "4")
    CreateLabel("Heal:", 235, 0) CreateEdit("SRA_Spam_Heal", 35, 235, -15, "3")
    CreateLabel("Tank:", 280, 0) CreateEdit("SRA_Spam_Tank", 35, 280, -15, "2")
    CreateLabel("GS:", 325, 0) CreateEdit("SRA_Spam_GS", 45, 325, -15, "5.5")
    CreateLabel("Preview (Tú escribes lo que deseas armar):", 0, -50)
    local preview = CreateFrame("EditBox", "SRA_Spam_Preview", f, "InputBoxTemplate") preview:SetSize(580, 24) preview:SetPoint("TOPLEFT", 15, -100) preview:SetAutoFocus(false) preview:SetText("Se arma ICC25N: Need: 5 Meles 4 Caster 3 Heal 2 Tanke GS: 5.5 12/25")
    local status = f:CreateFontString("SRA_Spam_Status", "OVERLAY", "GameFontNormalBold") status:SetPoint("TOPLEFT", 15, -130) status:SetText("|cffff0000● APAGADO - No spamea|r")
    local btnToggle = CreateFrame("Button", "SRA_Spam_ToggleBtn", f, "UIPanelButtonTemplate") btnToggle:SetSize(200, 36) btnToggle:SetPoint("TOPLEFT", 15, -150) btnToggle:SetText("ENVIAR SPAM: OFF") btnToggle:GetFontString():SetTextColor(1,0,0) btnToggle:SetScript("OnClick", SRA_ToggleSpam)
    local btnGen = CreateFrame("Button", nil, f, "UIPanelButtonTemplate") btnGen:SetSize(80, 28) btnGen:SetPoint("TOPLEFT", 225, -150) btnGen:SetText("GENERAR") btnGen:SetScript("OnClick", SRA_BuildSpamText)
    local btnReset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate") btnReset:SetSize(80, 28) btnReset:SetPoint("TOPLEFT", 315, -150) btnReset:SetText("RESET") btnReset:SetScript("OnClick", SRA_ResetSpamBuilder)
    local btnClear = CreateFrame("Button", nil, f, "UIPanelButtonTemplate") btnClear:SetSize(80, 28) btnClear:SetPoint("TOPLEFT", 405, -150) btnClear:SetText("CLEAR") btnClear:SetScript("OnClick", SRA_ClearSpamBuilder)
    local btnStop = CreateFrame("Button", nil, f, "UIPanelButtonTemplate") btnStop:SetSize(70, 28) btnStop:SetPoint("TOPLEFT", 495, -150) btnStop:SetText("STOP") btnStop:SetScript("OnClick", SRA_StopSpam)
    local help = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall") help:SetPoint("TOPLEFT", 15, -195) help:SetText("|cffaaaaaa/sra = Menú | /spambuilder = Abrir | /srareset = Reset | /sraclear = Vaciar | /sra stop = Apagar|r")
    f:Show()
end

-- === BOTON EN MENU PRINCIPAL SRA ===
local function SRA_InjectMenuButton()
    if _G["SRA_Menu_SpamBtn"] then return end
    local parent = _G["SRA_MainFrame"] or _G["SethRaidFrame"]
    if not parent then return end
    local btn = CreateFrame("Button", "SRA_Menu_SpamBtn", parent, "UIPanelButtonTemplate")
    btn:SetSize(130, 28) btn:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 15, 15)
    btn:SetText("SPAM BUILDER") btn:SetScript("OnClick", function() SRA_ShowSpamBuilder() end)
end

C_Timer.After(2, SRA_InjectMenuButton)
C_Timer.After(5, SRA_InjectMenuButton)

-- === COMANDOS ===
SLASH_SRASPAM1 = "/spambuilder"
SLASH_SRASPAM2 = "/sraarmar"
SLASH_SRASPAM3 = "/armar"
SlashCmdList["SRASPAM"] = SRA_ShowSpamBuilder

SLASH_SRARESET1 = "/srareset"
SLASH_SRARESET2 = "/sraclear"
SlashCmdList["SRARESET"] = function(msg)
    msg = msg and msg:lower() or ""
    if msg == "clear" or msg == "limpiar" or msg == "c" then
        SRA_ClearSpamBuilder()
    else
        SRA_ResetSpamBuilder()
    end
end

SLASH_SRASTOP1 = "/srastop"
SlashCmdList["SRASTOP"] = function() SRA_StopSpam() end

print("|cffff8000SethRaidArbiter v8.4.2 GOD cargado: /sra | /spambuilder | /srareset | /sraclear|r")
