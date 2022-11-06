function GottaGoFaster.UpdateTW()
  if (GottaGoFaster.CurrentTW) then
    if (not GottaGoFaster.CurrentTW["StartTime"]) then
      GottaGoFaster.CheckPositions(GottaGoFaster.CurrentTW["CurrentZoneID"]);
    end
    GottaGoFaster.UpdateTWTimer();
  end
end

function GottaGoFaster.UpdateTWObjectives()
  if (GottaGoFaster.CurrentTW) then
    local objectiveString = "";
    for i = 1, GottaGoFaster.CurrentTW["Steps"] do
      objectiveString = objectiveString .. GottaGoFaster.ObjectiveString(GottaGoFaster.CurrentTW["Bosses"][i], GottaGoFaster.CurrentTW["CurrentValues"][i], GottaGoFaster.CurrentTW["FinalValues"][i]);
      if (GottaGoFaster.CurrentTW["ObjectiveTimes"][i]) then
        -- Completed Objective
        objectiveString = objectiveString .. GottaGoFaster.ObjectiveCompletedString(GottaGoFaster.CurrentTW["ObjectiveTimes"][i]);
      end
      objectiveString = objectiveString .. "\n";
    end
    GottaGoFasterObjectiveFrame.font:SetText(objectiveString);
    GottaGoFaster.ResizeFrame();
  end
end

function GottaGoFaster.TWFinalParse()
  if (GottaGoFaster.CurrentTW) then
    for i = 1, GottaGoFaster.CurrentTW["Steps"] do
      GottaGoFaster.CurrentTW["CurrentValues"][i] = GottaGoFaster.CurrentTW["FinalValues"][i];
      if (not GottaGoFaster.CurrentTW["ObjectiveTimes"][i]) then
        GottaGoFaster.CurrentTW["ObjectiveTimes"][i] = GottaGoFaster.ObjectiveCompleteString(GottaGoFaster.CurrentTW["Time"]);
      end
    end
  end
end

function GottaGoFaster.CompleteTW()
  if (GottaGoFaster.CurrentTW) then
    GottaGoFaster.CurrentTW["Completed"] = true;
    GottaGoFaster.TWFinalParse();
  end
end

function GottaGoFaster.WipeTW()
  if (GottaGoFaster.CurrentTW) then
    GottaGoFaster.CurrentTW = table.wipe(GottaGoFaster.CurrentTW);
  end
end

function GottaGoFaster.StartTW()
  if (GottaGoFaster.CurrentTW) then
    GottaGoFaster.CurrentTW["StartTime"] = GetTime();
  end
end
