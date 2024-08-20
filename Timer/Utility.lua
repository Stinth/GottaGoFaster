function GottaGoFaster.StringToTime(time)
  time = GottaGoFaster.Utility.TrimStr(time);
  time = GottaGoFaster.Utility.ExplodeStr(":", time);
  if (time[1] ~= nil and time[2] ~= nil) then
    local mins = tonumber(time[1]);
    local secs = tonumber(time[2]);
    time = (mins * 60) + secs;
    time = GetTime() - time;
  else
    time = -1;
  end
  return time;
end

function GottaGoFaster.SecondsToTime(seconds)
  local min = math.floor(seconds/60);
  local sec = seconds - (min * 60);
  return min, sec;
end

function GottaGoFaster.FormatTimeNoMS(time)
  if (time < 10) then
    time = string.format("0%d", time);
  else
    time = string.format("%d", time);
  end
  return time;
end

function GottaGoFaster.FormatTimeMS(time)
  if (time < 10) then
    time = string.format("0%.3f", time);
  else
    time = string.format("%.3f", time);
  end
  return time;
end

function GottaGoFaster.SecsToTimeMS(secs)
  local startMin, startSec = GottaGoFaster.SecondsToTime(secs);
  startMin = GottaGoFaster.FormatTimeNoMS(startMin);
  startSec = GottaGoFaster.FormatTimeMS(startSec);
  return startMin .. ":" .. startSec;
end

function GottaGoFaster.CalculateRunTime(startTime, endTime, deaths, corrupt)
  local time = endTime - startTime;
  if (corrupt == false) then
    time = time + (deaths * 5);
  end
  return time;
end

function GottaGoFaster.RGBToHex(r, g, b, a)
	r = math.ceil(255 * r)
	g = math.ceil(255 * g)
	b = math.ceil(255 * b)
	if a == nil then
		return string.format("ff%02x%02x%02x", r, g, b)
	else
		a = math.ceil(255 * a)
		return string.format("%02x%02x%02x%02x", a, r, g, b)
	end
end

function GottaGoFaster.HexToRGB(hex)
	if string.len(hex) == 8 then
		return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255, tonumber("0x"..hex:sub(7,8)) / 255
	else
		return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255
	end
end

function GottaGoFaster.ObjectiveString(boss, curValue, finalValue)
  return string.format("|c%s%s - %d/%d|r", GottaGoFaster.db.profile.ObjectiveColor, boss, curValue, finalValue);
end

function GottaGoFaster.ObjectiveEnemyString(boss, curValue, finalValue)
  local currentPull = GottaGoFaster.CurrentCM["CurrentPull"]
  local percent = (curValue / finalValue) * 100;
  local currentPullCount, currentPullPercet = 0, 0
  if (currentPull ~= nil) then
    for _, value in pairs(currentPull) do 
      if value ~= "DEAD" then
        currentPullCount = currentPullCount + value[1]
        currentPullPercet = currentPullPercet + value[2]
      end
    end
  end
  if (GottaGoFaster.GetPullCountToggle(nil) and currentPullCount > 0) then
    if (GottaGoFaster.GetMobPoints(nil)) then
      return string.format("|c%s%s - %.1f%% (%d/%d) +%d [%.1f%%]|r", GottaGoFaster.db.profile.ObjectiveColor, "Forces", percent, curValue, finalValue, currentPullCount, currentPullPercet);
    else
      return string.format("|c%s%s - %.1f%% +[%.1f%%]|r", GottaGoFaster.db.profile.ObjectiveColor, "Forces", percent, currentPullPercet);
    end
  end
  if (GottaGoFaster.GetMobPoints(nil)) then
    return string.format("|c%s%s - %.1f%% (%d/%d)|r", GottaGoFaster.db.profile.ObjectiveColor, "Forces", percent, curValue, finalValue);
  else
    return string.format("|c%s%s - %.1f%%|r", GottaGoFaster.db.profile.ObjectiveColor, "Forces", percent);
  end
end


function GottaGoFaster.ObjectiveCompleteString(time)
  return string.format("%s", time);
end

function GottaGoFaster.ObjectiveExtraString(value, color)
  return string.format("|c%s%s|r", color, value);
end

function GottaGoFaster.ObjectiveCompletedString(time)
  return string.format("|c%s - |r|c%s%s|r", GottaGoFaster.db.profile.ObjectiveColor, GottaGoFaster.db.profile.ObjectiveCompleteColor, time);
end

function GottaGoFaster.ColorTimer(time)
  return string.format("|c%s%s|r", GottaGoFaster.db.profile.TimerColor, time);
end

function GottaGoFaster.IncreaseColorString(value)
  return string.format("|c%s%s|r", GottaGoFaster.db.profile.IncreaseColor, value);
end

function GottaGoFaster.HideObjectiveTracker()
  GottaGoFaster.originalObjectiveTrackerParent = ObjectiveTrackerFrame:GetParent()
  ObjectiveTrackerFrame:SetParent(GottaGoFasterHideFrame);
end

function GottaGoFaster.ShowObjectiveTracker()
  if ObjectiveTrackerFrame:GetParent() == GottaGoFasterHideFrame then
    ObjectiveTrackerFrame:SetParent(GottaGoFaster.originalObjectiveTrackerParent or UIParentRightManagedFrameContainer);
  end
end

function GottaGoFaster.ToggleDemoMode()
  if (GottaGoFaster.inCM == false and GottaGoFaster.inTW == false) then
    -- Demo Mode Goes Here
    if (GottaGoFaster.demoMode == false) then
      GottaGoFaster.SetupFakeCM();
      GottaGoFaster.UpdateCMTimer();
      GottaGoFaster.UpdateCMObjectives();
      GottaGoFasterFrame:SetScript("OnUpdate", GottaGoFaster.UpdateCM);
      GottaGoFaster.ShowFrames();
      GottaGoFaster.demoMode = true;
    else
      GottaGoFaster.ResetState();
      GottaGoFaster.demoMode = false;
    end
  end
end
