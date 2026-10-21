-- SpamBuilder.lua - SethRaidArbiter v6.2 - GOD Naerzone
SRA105DB = SRA105DB or {}

local spamBuilderFrame = nil

local function SRA_BuildSpamText()
    local raid = _G["SRA_Spam_Raid"] and _G["SRA_Spam_Raid"]:GetText() or ""
    local mode = _G["SRA_Spam_Mode"] and _G["SRA_Spam_Mode"]:GetText() or ""
    local melee = _G["SRA_Spam_Melee"] and _G["SRA_Spam_Melee"]:GetText() or ""
    local caster = _G["SRA_Spam_Caster"] and _G["SRA_Spam_Caster"]:GetText() or ""
    local heal = _G["SRA_Spam_Heal"] and _G["SRA_Spam_Heal"]:GetText() or ""
    local tank = _G["SRA_Spam_Tank"] and _G["SRA_Spam_Tank"]:GetText() or ""
    local gs = _G["SRA_Spam_GS"] and _G["SRA_Spam_GS"]:GetText() or ""
    
    local parts = {}
    
    if raid ~= "" or mode ~= "" then
        table.insert(parts, "Se arma "..raid..mode..":")
    else
        table.insert(parts, "Se arma:")
    end
    
    local needParts = {}
    if melee ~= "" and melee ~= "0" then table.insert(needParts, melee.."Meles") end
    if caster ~= "" and caster ~= "0" then table.insert(needParts, caster.."Caster") end
    if heal ~= "" and heal ~= "0" then table.insert(needParts, heal.."Heal") end
    if tank ~= "" and tank ~= "0" then table.insert(needParts, tank.."Tanke") end
    
    if #needParts > 0 then
        table.insert(parts, "Need: "..table.concat(needParts, " "))
    end
    
    if gs ~= "" and gs ~= "0" then
        table.insert(parts, "GS :"..gs)
    end
    
    if SRA_GetNumRaid and SRA_GetNumRaid() > 0 then
        table.insert(parts, SRA_GetNumRaid().."/25")
    end
    
    local final = table.concat(parts, " ")
    
    if _G["SRA_Spam_Preview"] then
        _G["SRA_Spam_Preview"]:SetText(final)
        SRA105DB.lastSpamGenerated = final
    end
    
    return final
end

function SRA_ShowSpamBuilder()
    if spamBuilderFrame then
        if spamBuilderFrame:IsShown() then spamBuilderFrame:Hide() else spamBuilderFrame:Show() end
        return
    end
    
    local f = CreateFrame("Frame", "SRA_SpamBuilderFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(620, 260)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(s) s:StartMoving() end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    f.TitleText:SetText("Seth Spam Builder - Naerzone v6.2")
    spamBuilderFrame = f
    
    local function CreateLabel(text, x, y)
        local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 15 + x, -35 + y)
        lbl:SetText(text)
        return lbl
    end
    
    local function CreateEdit(name, w, x, y, default)
        local eb = CreateFrame("EditBox", name, f, "InputBoxTemplate")
        eb:SetSize(w, 24)
        eb:SetPoint("TOPLEFT", 15 + x, -50 + y)
        eb:SetAutoFocus(false)
        eb:SetText(default or "")
        eb:SetScript("OnEnterPressed", function(s) s:ClearFocus() SRA_BuildSpamText() end)
        return eb
    end
    
    CreateLabel("Raid:", 0, 0)
    CreateEdit("SRA_Spam_Raid", 70, 0, -15, "ICC")
    
    CreateLabel("Modo:", 80, 0)
    CreateEdit("SRA_Spam_Mode", 50, 80, -15, "25N")
    
    CreateLabel("Mele:", 145, 0)
    CreateEdit("SRA_Spam_Melee", 35, 145, -15, "5")
    
    CreateLabel("Caster:", 190, 0)
    CreateEdit("SRA_Spam_Caster", 35, 190, -15, "4")
    
    CreateLabel("Heal:", 235, 0)
    CreateEdit("SRA_Spam_Heal", 35, 235, -15, "3")
    
    CreateLabel("Tank:", 280, 0)
    CreateEdit("SRA_Spam_Tank", 35, 280, -15, "2")
    
    CreateLabel("GS:", 325, 0)
    CreateEdit("SRA_Spam_GS", 45, 325, -15, "5.5")
    
    CreateLabel("Preview (editable):", 0, -50)
    local preview = CreateFrame("EditBox", "SRA_Spam_Preview", f, "InputBoxTemplate")
    preview:SetSize(580, 24)
    preview:SetPoint("TOPLEFT", 15, -100)
    preview:SetAutoFocus(false)
    preview:SetText("Se arma ICC25N: Need: 5Meles 4Caster 3Heal 2Tanke GS :5.5 12/25")
    
    local btnGen = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnGen:SetSize(130, 28)
    btnGen:SetPoint("TOPLEFT", 15, -135)
    btnGen:SetText("GENERAR TEXTO")
    btnGen:SetScript("OnClick", SRA_BuildSpamText)
    
    local btnStart = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnStart:SetSize(130, 28)
    btnStart:SetPoint("TOPLEFT", 155, -135)
    btnStart:SetText("START SPAM")
    btnStart:SetScript("OnClick", function()
        local txt = SRA_BuildSpamText()
        if SRA_StartSpam then SRA_StartSpam(txt) end
    end)
    
    local btnStop = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnStop:SetSize(90, 28)
    btnStop:SetPoint("TOPLEFT", 295, -135)
    btnStop:SetText("STOP")
    btnStop:SetScript("OnClick", function() if SRA_StopSpam then SRA_StopSpam() end end)
    
    local btnAV = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnAV:SetSize(90, 28)
    btnAV:SetPoint("TOPLEFT", 395, -135)
    btnAV:SetText("AV 10")
    btnAV:SetScript("OnClick", function()
        _G["SRA_Spam_Raid"]:SetText("Archavon")
        _G["SRA_Spam_Mode"]:SetText("10")
        _G["SRA_Spam_Melee"]:SetText("")
        _G["SRA_Spam_Caster"]:SetText("")
        _G["SRA_Spam_Heal"]:SetText("2")
        _G["SRA_Spam_Tank"]:SetText("1")
        _G["SRA_Spam_GS"]:SetText("5k")
        SRA_BuildSpamText()
    end)
    
    f:Show()
end

SLASH_SRASPAM1 = "/spambuilder"
SlashCmdList["SRASPAM"] = SRA_ShowSpamBuilder
