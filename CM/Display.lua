function GottaGoFaster.UpdateCMTimer()
  if (GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM)) then
    if (GottaGoFaster.CurrentCM["Completed"] == false) then
      local time = "";
      local startMin, startSec, goldMin, goldSec;
      if (GottaGoFaster.CurrentCM["StartTime"] and GottaGoFaster.GetTrueTimer()) then
        local currentTime = GetTime();
        local deaths = GottaGoFaster.CurrentCM["Deaths"] * 5;
        local secs = currentTime - GottaGoFaster.CurrentCM["StartTime"];
        GottaGoFaster.CurrentCM["CurrentTime"] = secs;
        secs = secs + deaths;
        if (secs < 0) then
          startMin = "-00";
          if (GottaGoFaster.GetTimerType(nil) == "TrueTimerMS") then
            startSec = GottaGoFaster.FormatTimeMS(math.abs(secs));
          else
            startSec = GottaGoFaster.FormatTimeNoMS(math.abs(secs));
          end
        else
          startMin, startSec = GottaGoFaster.SecondsToTime(secs);
          startMin = GottaGoFaster.FormatTimeNoMS(startMin);
          if (GottaGoFaster.GetTimerType(nil) == "TrueTimerMS") then
            startSec = GottaGoFaster.FormatTimeMS(startSec);
          else
            startSec = GottaGoFaster.FormatTimeNoMS(startSec);
          end
        end
      else
        _, timeCM = GetWorldElapsedTime(1);
        GottaGoFaster.AskForTimer(timeCM);
        startMin, startSec = GottaGoFaster.SecondsToTime(timeCM);
        startMin = GottaGoFaster.FormatTimeNoMS(startMin);
        startSec = GottaGoFaster.FormatTimeNoMS(startSec);
      end
      time = startMin .. ":" .. startSec .. " ";
      GottaGoFaster.CurrentCM["Time"] = time;
      goldMin, goldSec = GottaGoFaster.SecondsToTime(GottaGoFaster.CurrentCM["GoldTimer"]);
      goldMin = GottaGoFaster.FormatTimeNoMS(goldMin);
      goldSec = GottaGoFaster.FormatTimeNoMS(goldSec);

      if (GottaGoFaster.db.profile.GoldTimer) then
        time = time .. "/ " .. goldMin .. ":" .. goldSec;
      end

      if (GottaGoFaster.db.profile.LevelInTimer and GottaGoFaster.CurrentCM["Level"]) then
        local depleted = "";
        if (GottaGoFaster.CurrentCM["Empowered"] == false) then
          depleted = "d";
        end
        time = "[" .. GottaGoFaster.CurrentCM["Level"] .. depleted .. "] " .. time;
      end

      -- Update Frame
      GottaGoFasterTimerFrame.font:SetText(GottaGoFaster.ColorTimer(time));
      GottaGoFaster.ResizeFrame();
    end
  end
end

function GottaGoFaster.UpdateCMObjectives()
  if (GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM)) then
    local empowered = GottaGoFaster.EmpoweredString();
    local objectiveString = "";
    local affixString = "";
    local increaseString = "";
    local goldMin, goldSec;
    local hasExtraDeathPenalty = false;
    local curCM = GottaGoFaster.CurrentCM;
    if (GottaGoFaster.db.profile.IncreaseInObjectives and next(GottaGoFaster.CurrentCM["IncreaseTimers"])) then
      for k, v in pairs(GottaGoFaster.CurrentCM["IncreaseTimers"]) do
        if (k ~= 1 or GottaGoFaster.db.profile.GoldTimer == false) then
          goldMin, goldSec = GottaGoFaster.SecondsToTime(v);
          goldMin = GottaGoFaster.FormatTimeNoMS(goldMin);
          goldSec = GottaGoFaster.FormatTimeNoMS(goldSec);
          increaseString = increaseString .. "+" .. k .. " = " .. goldMin .. ":" .. goldSec .. " / ";
        end
      end
      objectiveString = objectiveString .. GottaGoFaster.IncreaseColorString(GottaGoFaster.Utility.ShortenStr(increaseString, 3) .. "\n");
    end
    if (GottaGoFaster.db.profile.LevelInObjectives and GottaGoFaster.CurrentCM["Level"]) then
      objectiveString = objectiveString .. GottaGoFaster.ObjectiveExtraString("Level " .. GottaGoFaster.CurrentCM["Level"] .. " - (+" .. GottaGoFaster.CurrentCM["Bonus"] .. "%) - " .. empowered .. "\n", GottaGoFaster.db.profile.LevelColor);
    end
    if (GottaGoFaster.db.profile.AffixesInObjectives and next(GottaGoFaster.CurrentCM["Affixes"])) then
      for k, v in pairs(GottaGoFaster.CurrentCM["Affixes"]) do
        if k == 152 then -- Challenger's Peril
          hasExtraDeathPenalty = true
        end
        affixString = affixString .. v["name"] .. " - ";
      end
      objectiveString = objectiveString .. GottaGoFaster.ObjectiveExtraString(GottaGoFaster.Utility.ShortenStr(affixString, 3) .. "\n", GottaGoFaster.db.profile.AffixesColor);
    end
    if (GottaGoFaster.GetDeathInObjectives(nil) and GottaGoFaster.CurrentCM["Deaths"]) then
      local deathString = "";

      local deathPenaltyTime = 5;
      if (hasExtraDeathPenalty) then
        deathPenaltyTime = 15;
      end

      local deathMin, deathSec = GottaGoFaster.SecondsToTime((GottaGoFaster.CurrentCM["Deaths"] * deathPenaltyTime));
      deathMin = GottaGoFaster.FormatTimeNoMS(deathMin);
      deathSec = GottaGoFaster.FormatTimeNoMS(deathSec);
      if (GottaGoFaster.CurrentCM["StartTime"] ~= nil) then
        deathString = "Deaths: " .. curCM["Deaths"] .. " - Time Lost: " .. deathMin .. ":" .. deathSec;
      else
        deathString = "Deaths: " .. curCM["Deaths"] .. "* - Time Lost: " .. deathMin .. ":" .. deathSec;
      end
      deathString = deathString .. "\n";
      objectiveString = objectiveString .. GottaGoFaster.ObjectiveExtraString(deathString, GottaGoFaster.db.profile.DeathColor);
    end
    for i = 1, GottaGoFaster.CurrentCM["Steps"] do
      if (i == GottaGoFaster.CurrentCM["Steps"]) then
        -- Last Step Should Be Enemies
        objectiveString = objectiveString .. GottaGoFaster.ObjectiveEnemyString(GottaGoFaster.CurrentCM["Bosses"][i], GottaGoFaster.CurrentCM["CurrentValues"][i], GottaGoFaster.CurrentCM["FinalValues"][i]);
      else
        objectiveString = objectiveString .. GottaGoFaster.ObjectiveString(GottaGoFaster.CurrentCM["Bosses"][i], GottaGoFaster.CurrentCM["CurrentValues"][i], GottaGoFaster.CurrentCM["FinalValues"][i]);
      end
      if (GottaGoFaster.db.profile.ObjectiveCompleteInObjectives and GottaGoFaster.CurrentCM["ObjectiveTimes"][i]) then
        -- Completed Objective
        objectiveString = objectiveString .. GottaGoFaster.ObjectiveCompletedString(GottaGoFaster.CurrentCM["ObjectiveTimes"][i]);
      end
      objectiveString = objectiveString .. "\n";
    end
    GottaGoFasterObjectiveFrame.font:SetText(objectiveString);
    GottaGoFaster.ResizeFrame();
  end
end
