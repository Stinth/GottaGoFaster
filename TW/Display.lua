function GottaGoFaster.UpdateTWInformation()
  if (GottaGoFaster.CurrentTW) then
    if (GottaGoFaster.CurrentTW["Completed"] == false) then
      for i = 1, GottaGoFaster.CurrentTW["Steps"] do
        local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(i);
        if (not criteriaInfo) then
          return false;
        end
        if (criteriaInfo.totalQuantity == 0 or not criteriaInfo.totalQuantity) then
          -- Final Value = 0 Means TW Complete
          GottaGoFaster.CompleteTW();
          return false;
        end
        local curValue = tonumber(string.match(criteriaInfo.quantityString, "%d+"));
        if (GottaGoFaster.CurrentTW["CurrentValues"][i] ~= curValue) then
          -- Update Value
          GottaGoFaster.CurrentTW["CurrentValues"][i] = curValue;
          if (curValue == criteriaInfo.totalQuantity) then
            -- Add Objective Time
            GottaGoFaster.CurrentTW["ObjectiveTimes"][i] = GottaGoFaster.ObjectiveCompleteString(GottaGoFaster.CurrentTW["Time"]);
          end
        end


        if (GottaGoFaster.CurrentTW["CurrentValues"][i] == GottaGoFaster.CurrentTW["FinalValues"][i] and not GottaGoFaster.CurrentTW["ObjectiveTimes"][i]) then
          -- Objective Already Complete But No Time Filled Out (Re-Log / Re-Zone)
          GottaGoFaster.CurrentTW["ObjectiveTimes"][i] = "?";
        end
      end
    end
  end
end

function GottaGoFaster.UpdateTWTimer()
  if (GottaGoFaster.CurrentTW and GottaGoFaster.CurrentTW["StartTime"]) then
    if (GottaGoFaster.CurrentTW["Completed"] == false) then
      local time = "";
      local startMin, startSec;
      local currentTime = GetTime();
      local secs = currentTime - GottaGoFaster.CurrentTW["StartTime"];
      GottaGoFaster.CurrentTW["CurrentTime"] = secs;
      startMin, startSec = GottaGoFaster.SecondsToTime(secs);
      if (GottaGoFaster.CurrentTW["StartTime"] and GottaGoFaster.GetTimerType(nil) == "TrueTimerMS") then
        startMin = GottaGoFaster.FormatTimeNoMS(startMin);
        startSec = GottaGoFaster.FormatTimeMS(startSec);
      else
        startMin = GottaGoFaster.FormatTimeNoMS(startMin);
        startSec = GottaGoFaster.FormatTimeNoMS(startSec);
      end
      time = startMin .. ":" .. startSec;
      if (GottaGoFaster.CurrentTW["LateStart"] == true) then
        time = time .. "*";
      end
      time = time .. " ";
      GottaGoFaster.CurrentTW["Time"] = time;
      -- Update Frame
      GottaGoFasterTimerFrame.font:SetText(GottaGoFaster.ColorTimer(time));
      GottaGoFaster.ResizeFrame();
    else
      GottaGoFasterTimerFrame.font:SetText(GottaGoFaster.ColorTimer(GottaGoFaster.CurrentTW["Time"]));
    end
  else
    GottaGoFasterTimerFrame.font:SetText(GottaGoFaster.ColorTimer("00:00"));
  end
end
