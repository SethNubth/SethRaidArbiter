local _, SRA = ...
SRA.Loot = {}
local L = SRA.Loot
SRA_Options = SRA_Options or {}
function SRA.GetItemLinkSafe(itemID)
 if not itemID then return nil end
 local link = select(2, GetItemInfo(itemID))
 if not link then
  return "|cffa335ee|Hitem:"..itemID.."|h[Item "..itemID.."]|h|r"
 end
 return link
end
function SRA.IsEpic(itemID)
 local epic = {[50362]=true,[50363]=true,[50734]=true,[50735]=true,[50736]=true,[50632]=true,[50818]=true,[50819]=true,[50340]=true,[50341]=true,[50342]=true}
 return epic[itemID]
end
local lootFrame = CreateFrame("Frame")
lootFrame:RegisterEvent("LOOT_OPENED")
lootFrame:RegisterEvent("CHAT_MSG_LOOT")
lootFrame:SetScript("OnEvent", function(self, event, msg)
 if not SRA_Options.directLoot then return end
 if not SRA_Options.isLeader and not SRA_Options.isAyudante then return end
 if event=="CHAT_MSG_LOOT" then
  if not msg then return end
  if msg:find("has looted") or msg:find("ha
