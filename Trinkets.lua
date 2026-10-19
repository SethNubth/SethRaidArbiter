SRA_TrinketDB={Testamento={40395,44577,50363}, Muerte={47115,47213,50362}, DBW={47303,47115}}
SRA_SRReserve={}
function SRA_AddSR(p,id) SRA_SRReserve[p]=id print("|cffff0000SR:|r "..p.." reservo "..SRA_GetItemLink(id)) end
function SRA_IsAlt(name) return SRA105DB.srList[name] and SRA105DB.srList[name].isAlt end
