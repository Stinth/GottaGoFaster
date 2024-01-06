local constants = GottaGoFaster.Constants;

function GottaGoFaster.GetUnlocked(info)
  return GottaGoFaster.unlocked;
end

function GottaGoFaster.SetUnlocked(info, value)
  GottaGoFaster.unlocked = value;
  GottaGoFasterFrame:SetMovable(GottaGoFaster.unlocked);
  GottaGoFasterFrame:EnableMouse(GottaGoFaster.unlocked);
end

function GottaGoFaster.GetGoldTimer(info)
  return GottaGoFaster.db.profile.GoldTimer;
end

function GottaGoFaster.SetGoldTimer(info, value)
  GottaGoFaster.db.profile.GoldTimer = value;
  GottaGoFaster.UpdateCMTimer();
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetTimerType(info)
  return GottaGoFaster.db.profile.TimerType;
end

function GottaGoFaster.SetTimerType(info, value)
  GottaGoFaster.db.profile.TimerType = value;
  GottaGoFaster.UpdateCMTimer();
end

function GottaGoFaster.GetTrueTimer()
  local timerType = GottaGoFaster.GetTimerType(nil);
  if (timerType == "TrueTimerMS" or timerType == "TrueTimerNoMS") then
    return true;
  else
    return false;
  end
end

function GottaGoFaster.GetTimerX(info)
  return GottaGoFaster.db.profile.TimerX;
end

function GottaGoFaster.SetTimerX(info, value)
  GottaGoFaster.db.profile.TimerX = value;
  GottaGoFasterTimerFrame:ClearAllPoints();
  GottaGoFasterTimerFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.TimerX, GottaGoFaster.db.profile.TimerY);
end

function GottaGoFaster.GetTimerY(info)
  return GottaGoFaster.db.profile.TimerY;
end

function GottaGoFaster.SetTimerY(info, value)
  GottaGoFaster.db.profile.TimerY = value;
  GottaGoFasterTimerFrame:ClearAllPoints();
  GottaGoFasterTimerFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.TimerX, GottaGoFaster.db.profile.TimerY);
end

function GottaGoFaster.GetTimerFont(info)
  return GottaGoFaster.db.profile.TimerFont;
end

function GottaGoFaster.SetTimerFont(info, value)
  GottaGoFaster.db.profile.TimerFont = value;
  GottaGoFasterTimerFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.TimerFont), GottaGoFaster.db.profile.TimerFontSize, GottaGoFaster.db.profile.TimerFontFlag);
end

function GottaGoFaster.GetObjectiveFont(info)
  return GottaGoFaster.db.profile.ObjectiveFont;
end

function GottaGoFaster.SetObjectiveFont(info, value)
  GottaGoFaster.db.profile.ObjectiveFont = value;
  GottaGoFasterObjectiveFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.ObjectiveFont), GottaGoFaster.db.profile.ObjectiveFontSize, GottaGoFaster.db.profile.ObjectiveFontFlag);
end

function GottaGoFaster.GetTimerFontSize(info)
  return GottaGoFaster.db.profile.TimerFontSize;
end

function GottaGoFaster.SetTimerFontSize(info, value)
  GottaGoFaster.db.profile.TimerFontSize = value;
  GottaGoFasterTimerFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.TimerFont), GottaGoFaster.db.profile.TimerFontSize, GottaGoFaster.db.profile.TimerFontFlag);
end

function GottaGoFaster.GetTimerAlign(info)
  return GottaGoFaster.db.profile.TimerAlign;
end

function GottaGoFaster.SetTimerAlign(info, value)
  GottaGoFaster.db.profile.TimerAlign = value;
  GottaGoFasterTimerFrame.font:SetJustifyH(GottaGoFaster.db.profile.TimerAlign);
  GottaGoFaster.UpdateCMTimer();
end

function GottaGoFaster.GetObjectiveX(info)
  return GottaGoFaster.db.profile.ObjectiveX;
end

function GottaGoFaster.SetObjectiveX(info, value)
  GottaGoFaster.db.profile.ObjectiveX = value;
  GottaGoFasterObjectiveFrame:ClearAllPoints();
  GottaGoFasterObjectiveFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.ObjectiveX, GottaGoFaster.db.profile.ObjectiveY);
end

function GottaGoFaster.GetObjectiveY(info)
  return GottaGoFaster.db.profile.ObjectiveY;
end

function GottaGoFaster.SetObjectiveY(info, value)
  GottaGoFaster.db.profile.ObjectiveY = value;
  GottaGoFasterObjectiveFrame:ClearAllPoints();
  GottaGoFasterObjectiveFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.ObjectiveX, GottaGoFaster.db.profile.ObjectiveY);
end

function GottaGoFaster.GetObjectiveFontSize(info)
  return GottaGoFaster.db.profile.ObjectiveFontSize;
end

function GottaGoFaster.SetObjectiveFontSize(info, value)
  GottaGoFaster.db.profile.ObjectiveFontSize = value;
  GottaGoFasterObjectiveFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.ObjectiveFont), GottaGoFaster.db.profile.ObjectiveFontSize, GottaGoFaster.db.profile.ObjectiveFontFlag);
end

function GottaGoFaster.GetObjectiveAlign(info)
  return GottaGoFaster.db.profile.ObjectiveAlign;
end

function GottaGoFaster.SetObjectiveAlign(info, value)
  GottaGoFaster.db.profile.ObjectiveAlign = value;
  GottaGoFasterObjectiveFrame.font:SetJustifyH(GottaGoFaster.db.profile.ObjectiveAlign);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetObjectiveCollapsed(info)
  return GottaGoFaster.db.profile.ObjectiveCollapsed;
end

function GottaGoFaster.SetObjectiveCollapsed(info, value)
  GottaGoFaster.db.profile.ObjectiveCollapsed = value;
end

function GottaGoFaster.GetTimerColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.TimerColor);
  return r, g, b, a;
end

function GottaGoFaster.SetTimerColor(info, r, g, b, a)
  GottaGoFaster.db.profile.TimerColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMTimer();
end

function GottaGoFaster.GetObjectiveColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.ObjectiveColor);
  return r, g, b, a;
end

function GottaGoFaster.SetObjectiveColor(info, r, g, b, a)
  GottaGoFaster.db.profile.ObjectiveColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetObjectiveCompleteColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.ObjectiveCompleteColor);
  return r, g, b, a;
end

function GottaGoFaster.SetObjectiveCompleteColor(info, r, g, b, a)
  GottaGoFaster.db.profile.ObjectiveCompleteColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetIncreaseColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.IncreaseColor);
  return r, g, b, a;
end

function GottaGoFaster.SetIncreaseColor(info, r, g, b, a)
  GottaGoFaster.db.profile.IncreaseColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetAffixesColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.AffixesColor);
  return r, g, b, a;
end

function GottaGoFaster.SetAffixesColor(info, r, g, b, a)
  GottaGoFaster.db.profile.AffixesColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetLevelColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.LevelColor);
  return r, g, b, a;
end

function GottaGoFaster.SetLevelColor(info, r, g, b, a)
  GottaGoFaster.db.profile.LevelColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetDeathColor(info)
  local a, r, g, b = GottaGoFaster.HexToRGB(GottaGoFaster.db.profile.DeathColor);
  return r, g, b, a;
end

function GottaGoFaster.SetDeathColor(info, r, g, b, a)
  GottaGoFaster.db.profile.DeathColor = GottaGoFaster.RGBToHex(r, g, b, a);
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetLevelInTimer(info)
  return GottaGoFaster.db.profile.LevelInTimer;
end

function GottaGoFaster.SetLevelInTimer(info, value)
  GottaGoFaster.db.profile.LevelInTimer = value;
  GottaGoFaster.UpdateCMTimer();
end

function GottaGoFaster.GetLevelInObjectives(info)
  return GottaGoFaster.db.profile.LevelInObjectives;
end

function GottaGoFaster.SetLevelInObjectives(info, value)
  GottaGoFaster.db.profile.LevelInObjectives = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetAffixesInObjectives(info)
  return GottaGoFaster.db.profile.AffixesInObjectives;
end

function GottaGoFaster.SetAffixesInObjectives(info, value)
  GottaGoFaster.db.profile.AffixesInObjectives = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetIncreaseInObjectives(info)
  return GottaGoFaster.db.profile.IncreaseInObjectives;
end

function GottaGoFaster.SetIncreaseInObjectives(info, value)
  GottaGoFaster.db.profile.IncreaseInObjectives = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetObjectiveCompleteInObjectives(info)
  return GottaGoFaster.db.profile.ObjectiveCompleteInObjectives;
end

function GottaGoFaster.SetObjectiveCompleteInObjectives(info, value)
  GottaGoFaster.db.profile.ObjectiveCompleteInObjectives = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetDeathInObjectives(info)
  return GottaGoFaster.db.profile.DeathInObjectives;
end

function GottaGoFaster.SetDeathInObjectives(info, value)
  GottaGoFaster.db.profile.DeathInObjectives = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetMobPoints(info)
  return GottaGoFaster.db.profile.MobPoints;
end

function GottaGoFaster.SetMobPoints(info, value)
  GottaGoFaster.db.profile.MobPoints = value;
  GottaGoFaster.UpdateCMObjectives();
end

function GottaGoFaster.GetIndividualMobValue(info)
  return GottaGoFaster.db.profile.IndividualMobValue;
end

function GottaGoFaster.SetIndividualMobValue(info, value)
  GottaGoFaster.db.profile.IndividualMobValue = value;
end

function GottaGoFaster.GetUseMdt(info)
  return GottaGoFaster.db.profile.UseMdt;
end

function GottaGoFaster.SetUseMdt(info, value)
  GottaGoFaster.db.profile.UseMdt = value;
end

function GottaGoFaster.GetTimerFontFlag(info)
  return GottaGoFaster.db.profile.TimerFontFlag;
end

function GottaGoFaster.SetTimerFontFlag(info, value)
  GottaGoFaster.db.profile.TimerFontFlag = value;
  GottaGoFasterTimerFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.TimerFont), GottaGoFaster.db.profile.TimerFontSize, GottaGoFaster.db.profile.TimerFontFlag);
end

function GottaGoFaster.GetObjectiveFontFlag(info)
  return GottaGoFaster.db.profile.ObjectiveFontFlag;
end

function GottaGoFaster.SetObjectiveFontFlag(info, value)
  GottaGoFaster.db.profile.ObjectiveFontFlag = value;
  GottaGoFasterObjectiveFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.ObjectiveFont), GottaGoFaster.db.profile.ObjectiveFontSize, GottaGoFaster.db.profile.ObjectiveFontFlag);
end

function GottaGoFaster.GetDebugMode(info)
  return GottaGoFaster.db.profile.DebugMode;
end

function GottaGoFaster.SetDebugMode(info, value)
  GottaGoFaster.db.profile.DebugMode = value;
  GottaGoFaster:Print("Debug Mode = " .. tostring(value));
end

function GottaGoFaster.GetVersion(info)
  return GottaGoFaster.db.profile.Version;
end

function GottaGoFaster.SetVersion(info, value)
  GottaGoFaster.db.profile.Version = value;
end

function GottaGoFaster.GetTimerTooltip(info)
  return GottaGoFaster.db.profile.TimerTooltip;
end

function GottaGoFaster.SetTimerTooltip(info, value)
  GottaGoFaster.db.profile.TimerTooltip = value;
  if (value) then
    GottaGoFasterTimerFrame:SetScript("OnEnter", GottaGoFaster.TooltipOnEnter);
    GottaGoFasterTimerFrame:SetScript("OnLeave", GottaGoFaster.TooltipOnLeave);
  else
    GottaGoFasterTimerFrame:SetScript("OnEnter", nil);
    GottaGoFasterTimerFrame:SetScript("OnLeave", nil);
  end
end

function GottaGoFaster.GetPullCountToggle(info)
  return GottaGoFaster.db.profile.PullCountToggle;
end

function GottaGoFaster.SetPullCountToggle(info, value)
  GottaGoFaster.db.profile.PullCountToggle = value;
end

function GottaGoFaster.GetAutoDialog(info)
  return GottaGoFaster.db.profile.AutoDialog;
end

function GottaGoFaster.SetAutoDialog(info, value)
  GottaGoFaster.db.profile.AutoDialog = value;
end

function GottaGoFaster.GetSpyHelper(info)
  return GottaGoFaster.db.profile.SpyHelper;
end

function GottaGoFaster.SetSpyHelper(info, value)
  GottaGoFaster.db.profile.SpyHelper = value;
end

function GottaGoFaster.GetBestReport(info)
  return GottaGoFaster.db.profile.BestReport;
end

function GottaGoFaster.SetBestReport(info, value)
  GottaGoFaster.db.profile.BestReport = value;
end

function GottaGoFaster.GetAutoSlotKeystone(info)
  return GottaGoFaster.db.profile.AutoSlotKeystone;
end

function GottaGoFaster.SetAutoSlotKeystone(info, value)
  GottaGoFaster.db.profile.AutoSlotKeystone = value;
end

function GottaGoFaster.History()
  local data = {["msg"] = "OpenHistory"};
  local dataString = GottaGoFaster:Serialize(data);
  GottaGoFaster:SendCommMessage(constants.HistoryPrefix, dataString, "WHISPER", GetUnitName("player"), "ALERT")
end
