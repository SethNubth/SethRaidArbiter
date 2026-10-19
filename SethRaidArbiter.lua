SRA105DB = SRA105DB or {icc={}, icc_id={}, sr={}, sr_id={}, toc={}, toc_id={}, srList={}, config={minimap={}}}

local function initDB()
  for i=1,35 do
    SRA105DB.icc[i]=SRA105DB.icc[i] or "" SRA105DB.icc_id[i]=SRA105DB.icc_id[i] or ""
    SRA105DB.sr[i]=SRA105DB.sr[i] or "" SRA105DB.sr_id[i]=SRA105DB.sr_id[i] or ""
    SRA105DB.toc[i]=SRA105DB.toc[i] or "" SRA105DB.toc_id[i]=SRA105DB.toc_id[i] or ""
  end
  if SRA105DB.icc[1]=="" then SRA105DB.icc[1]="todo reservado por el lider" end
  if SRA105DB.sr[1]=="" then SRA105DB.sr[1]="ustedes son mis lacayos" end
  if SRA105DB.toc[1]=="" then SRA105DB.toc[1]="Mas miedo es no tener miedo" end
end
local f=CreateFrame("Frame") f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_,_,n) if n=="SethRaidArbiter" then initDB() if SRA_InitMinimap then SRA_InitMinimap() end end end)

function SRA_GetItemLink(id)
  if not id or id=="" then return "" end
  local _, link = GetItemInfo(tonumber(id)) if link then return link end
  return "\124cffa335ee\124Hitem:"..id..":0:0:0:0:0:0:0:0\124h[Item:"..id.."]\124h\124r"
end
function SRA_Launch(tbl)
  for i=1,35 do local t=SRA105DB[tbl][i] if t and t:trim()~="" then local l=SRA_GetItemLink(SRA105DB[tbl.."_id"][i]) SendChatMessage(l~="" and t.." "..l or t, "RAID_WARNING") end end
end
SLASH_SETH1="/seth" SlashCmdList["SETH"]=function() SRA_ShowMenu() end
SLASH_ICC1="/icc" SlashCmdList["ICC"]=function() SRA_Launch("icc") end
SLASH_SR1="/sr" SlashCmdList["SR"]=function() SRA_Launch("sr") end
SLASH_TOC1="/toc" SlashCmdList["TOC"]=function() SRA_Launch("toc") end
