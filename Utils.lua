local _, SRA = ...
SRA.Utils = {}
local U = SRA.Utils
function U.trim(s) return s:gsub("^%s*(.-)%s*$","%1") end
function U.shuffle(t)
 local n=#t
 while n>2 do
  local k=math.random(1,n)
  t[n], t[k]=t[k], t[n]
  n=n-1
 end
end
do
 local tasks={}
 function U.schedule(sec, func, ...)
  local t={time=time()+sec, func=func}
  for i=1,select("#",...) do t[i]=select(i,...) end
  table.insert(tasks, t)
 end
 function U.unschedule(func)
  for i=#tasks,1,-1 do if tasks[i].func==func then table.remove(tasks,i) break end end
 end
 function U.run()
  local now=time()
  for i=#tasks,1,-1 do
   local task=tasks[i]
   if task and task.time<=now then
    task.func(unpack(task))
    table.remove(tasks,i)
   end
  end
 end
end
function U.IsRaidLeader()
 if GetNumRaidMembers()==0 then return false end
 for i=1,GetNumRaidMembers() do
  local name, rank = GetRaidRosterInfo(i)
  if name==UnitName("player") then return rank>=1 end
 end
 return false
end
function U.CanLoot()
 local opt = SRA_Options or {}
 if opt.isLeader and not U.IsRaidLeader() then return false end
 return true
end
SRA_Options = SRA_Options or {isLeader=true, isAyudante=false, isGuild=false, antiMute=true, autoTaberna=true, directLoot=true, epicAlert=true, screenshot=true, countdown=15}
SRA_Raids = SRA_Raids or {}
SRA_SR = SRA_SR or {}
SRA_105DB = SRA_105DB or {}
SRA_DB = SRA_DB or {lastAlert=0}
SRA_EPGPLog = SRA_EPGPLog or {}
