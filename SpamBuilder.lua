local _, SRA = ...
SRA.Spam = {}
local SPAM_CHANNEL = "2. General"
local TABERNA_ID = 6578
local ANTI_MUTE_DELAY = 11
local lastSpam = 0
SRA.Spam.variants = {
 "LFM ICC 25H LK 25% 5.8k+ SR DBW/Testa - /w gs",
 "LFM ICC25H - LK25% - 5.8k+ - SR: DBW 50362 - /w",
 "ICC25H LFM - LK HM - Need 5.8k+ - SR disponible - /w para inv",
}
function SRA.Spam.GetRandom()
 return SRA.Spam.variants[math.random(1, #SRA.Spam.variants)]
end
function SRA.Spam.Send(msg)
 if not SRA_Options.antiMute then
  -- Sin anti-mute
  if SRA_Options.autoTaberna then
   JoinChannelByName(TABERNA_ID)
  end
  SendChatMessage(msg or SRA.Spam.GetRandom(), "CHANNEL", nil, GetChannelName(SPAM_CHANNEL))
  return
 end
 local now = time()
 if now - lastSpam < ANTI_MUTE_DELAY then
  local wait = ANTI_MUTE_DELAY - (now - lastSpam)
  print("|cffff8000SRA Anti-Mute:|r Espera "..wait.."s para evitar mute Naerzone")
  SRA.Utils.schedule(wait, function() SRA.Spam.Send(msg) end)
  return
 end
 lastSpam = now
 if SRA_Options.autoTaberna then
  JoinChannelByName(TABERNA_ID)
  -- Spamea en taberna tambien
  SendChatMessage(msg or SRA.Spam.GetRandom(), "CHANNEL", nil, TABERNA_ID)
 end
 -- Variante random para evitar mute
 local finalMsg = (msg or SRA.Spam.GetRandom())
 -- Agrega sufijo random invisible
 local suffixes = {" .", " !", " -", " +", " <>"}
 finalMsg = finalMsg..suffixes[math.random(1,#suffixes)]
 SendChatMessage(finalMsg, "CHANNEL", nil, GetChannelName(SPAM_CHANNEL))
 print("|cffff8000SRA Spam GOD:|r Enviado anti-mute 11s - Taberna 6578")
end
SLASH_LFM1 = "/lfm"
SlashCmdList["LFM"] = function(msg)
 SRA.Spam.Send(msg ~= "" and msg or nil)
end
SLASH_SRA_SPAM1 = "/sraspam"
SlashCmdList["SRA_SPAM"] = function(msg)
 SRA.Spam.Send(msg)
end
