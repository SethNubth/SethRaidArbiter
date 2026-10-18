-- Boton minimapa DragonUI
local btn = CreateFrame("Button", "SRA_MapButton", Minimap)
btn:SetSize(32,32)
btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT")
btn:SetNormalTexture("Interface\\AddOns\\SethRaidArbiter\\Media\\agonia_rock")
btn:SetScript("OnClick", function() print("SethRaidArbiter by SethNubth - Naerzone") end)
