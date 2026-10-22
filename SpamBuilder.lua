-- SpamBuilder.lua - SethRaidArbiter v8.4.1 MENU + ON/OFF GOD
SRA105DB = SRA105DB or {}
local spamBuilderFrame = nil
local lastSpamTime = 0
local ANTI_MUTE_DELAY = 11
local spamActivo = false
local spamTicker = nil

local function SRA_GetTabernaChannel()
 for i=1,20 do
  local _, name = GetChannelName(i)
  if name and name:lower():find("taberna") then return i end
 end
 return nil
end

local function SRA_JoinTaberna()
 if SRA_Options and not SRA_Options.autoTaberna then return end
 if not SRA_GetTabernaChannel() then JoinChannelByName("taberna") end
end

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
    if SRA_Options and SRA_Options.antiMute and now - lastSpamTime < ANTI_MUTE_DELAY then return end
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
    if _G["SRA_Spam_ToggleBtn"] then _G["SRA_Spam_ToggleBtn"]:SetText("ENVIAR SPAM: OFF") end
    if _G["SRA_Spam_Status"] then _G["SRA_Spam_Status"]:SetText("|cffff0000● APAGADO - No spamea|r") end
    print("|cffff8000SRA:|r Spam APAGADO")
end

function SRA_ToggleSpam()
    if not spamActivo then
        spamActivo = true
        local txt = SRA_BuildSpamText()
        SRA_StartSpam(txt)
        spamTicker = C_Timer.NewTicker(ANTI_MUTE_DELAY, function() SRA_StartSpam() end)
        if _G["SRA_Spam_ToggleBtn"] then _G["SRA_Spam_ToggleBtn"]:SetText("ENVIAR SPAM: ON") end
        if _G["SRA_Spam_Status"] then _G["SRA_Spam_Status"]:SetText("|cff00ff00● ENVIADO - Cada 11s Taberna /"..(SRA_GetTabernaChannel() or "?").." + General|r") end
    else
        SRA_StopSpam()
    end
end

function SRA_ShowSpamBuilder()
    if spamBuilderFrame then if spamBuilderFrame:IsShown() then spamBuilderFrame:Hide() else spamBuilderFrame:Show() end return end
    local f = CreateFrame("Frame", "SRA_SpamBuilderFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(620, 290) f:SetPoint("CENTER") f:SetMovable(true) f:EnableMouse(true) f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(s) s:StartMoving() end) f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    f.TitleText:SetText("Seth Spam Builder v8.4.1 - Menu + ON/OFF") spamBuilderFrame = f
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
    local btnToggle = CreateFrame("Button", "SRA_Spam_ToggleBtn", f, "UIPanelButtonTemplate") btnToggle:SetSize(200, 32) btnToggle:SetPoint("TOPLEFT", 15, -150) btnToggle:SetText("ENVIAR SPAM: OFF") btnToggle:SetScript("OnClick", SRA_ToggleSpam)
    local btnGen = CreateFrame("Button", nil, f, "UIPanelButtonTemplate") btnGen:SetSize(90, 28) btnGen:SetPoint("TOPLEFT", 225, -150) btnGen:SetText("GENERAR") btnGen:SetScript("OnClick", SRA_BuildSpamText)
    f:Show()
end

-- === AGREGAR BOTON AL MENU PRINCIPAL SRA ===
local function SRA_InjectMenuButton()
    if not _G["SRA_MainFrame"] and not _G["SethRaidFrame"] then return end
    local parent = _G["SRA_MainFrame"] or _G["SethRaidFrame"]
    if _G["SRA_Menu_SpamBtn"] then return end
    local btn = CreateFrame("Button", "SRA_Menu_SpamBtn", parent, "UIPanelButtonTemplate")
    btn:SetSize(130, 28)
    btn:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 15, 15)
    btn:SetText("SPAM BUILDER")
    btn:SetScript("OnClick", function() SRA_ShowSpamBuilder() end)
    print("|cffff8000SRA v8.4.1:|r Botón SPAM BUILDER agregado al menú")
end

-- Intenta agregar al cargar
C_Timer.After(2, SRA_InjectMenuButton)
C_Timer.After(5, SRA_InjectMenuButton)

SLASH_SRASPAM1 = "/spambuilder"
SLASH_SRASPAM2 = "/sraarmar"
SlashCmdList["SRASPAM"] = SRA_ShowSpamBuilder
