local ggf = GottaGoFaster;
local utility = ggf.Utility;

function GottaGoFaster.InitTW(currentZoneID)
  if (GottaGoFasterInstanceInfo[currentZoneID]["TW"]) then
    utility.DebugPrint("Player Entered Timewalking Dungeon");
    GottaGoFaster.WipeTW();
    GottaGoFaster.SetupTW(currentZoneID);
    GottaGoFaster.UpdateTWTimer();
    GottaGoFaster.UpdateTWObjectives();
    GottaGoFaster.inCM = false;
    GottaGoFaster.inTW = true;
    GottaGoFasterFrame:SetScript("OnUpdate", GottaGoFaster.UpdateTW);
    -- Hiding Frames For Now
    GottaGoFaster.ShowFrames();
  end
end

function GottaGoFaster.SetupTW(currentZoneID)
  local _, _, steps = C_Scenario.GetStepInfo();
  GottaGoFaster.CurrentTW = {};
  GottaGoFaster.CurrentTW["StartTime"] = nil;
  GottaGoFaster.CurrentTW["CurrentTime"] = nil;
  GottaGoFaster.CurrentTW["Time"] = nil;
  GottaGoFaster.CurrentTW["LateStart"] = false;
  GottaGoFaster.CurrentTW["String"] = nil;
  GottaGoFaster.CurrentTW["Steps"] = steps;
  GottaGoFaster.CurrentTW["CurrentZoneID"] = currentZoneID;
  GottaGoFaster.CurrentTW["Completed"] = false;
  GottaGoFaster.CurrentTW["CurrentValues"] = {};
  GottaGoFaster.CurrentTW["FinalValues"] = {};
  GottaGoFaster.CurrentTW["ObjectiveTimes"] = {};
  GottaGoFaster.CurrentTW["Bosses"] = {};

  for i = 1, steps do
    local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
    name = string.gsub(name, " defeated", "");
    GottaGoFaster.CurrentTW["CurrentValues"][i] = curValue;
    GottaGoFaster.CurrentTW["FinalValues"][i] = finalValue;
    GottaGoFaster.CurrentTW["Bosses"][i] = name;
    if (curValue ~= 0) then
      GottaGoFaster.CurrentTW["LateStart"] = true;
      GottaGoFaster.StartTW();
    end
  end

  if (GottaGoFaster.CheckPositions(GottaGoFaster.CurrentTW["CurrentZoneID"])) then
    GottaGoFaster.CurrentTW["LateStart"] = true;
  end

  if (GottaGoFaster.CurrentTW["LateStart"] == true) then
    --GottaGoFaster:Print("Asked To Fix Timer");
    GottaGoFaster:SendCommMessage("GottaGoFasterTW", "FixTW", "PARTY", nil, "ALERT");
  end

  GottaGoFaster.HideObjectiveTracker();
end
