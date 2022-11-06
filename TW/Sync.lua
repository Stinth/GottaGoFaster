function GottaGoFaster.CheckTWTimer()
  -- Someone asked for a timer, send it to them!
  if (GottaGoFaster.CurrentTW["LateStart"] == false and GottaGoFaster.CurrentTW["StartTime"] and GottaGoFaster.CurrentTW["CurrentTime"]) then
    local CurrentTWString = GottaGoFaster:Serialize(GottaGoFaster.CurrentTW);
    GottaGoFaster.Utility.DebugPrint("Timer Sent");
    GottaGoFaster:SendCommMessage("GottaGoFasterTW", CurrentTWString, "PARTY", nil, "ALERT");
  end
end

function GottaGoFaster.FixTWTimer(input)
  if (GottaGoFaster.inTW == true and GottaGoFaster.CurrentTW) then
    if (GottaGoFaster.CurrentTW["LateStart"] == true) then
      GottaGoFaster.Utility.DebugPrint("Replacing Timer");
      -- Set Table
      GottaGoFaster:Deserialize(input);
      local DIW, ETW = GottaGoFaster:Deserialize(input);
      if (DIW) then
        local CurrentTime = GetTime();
        ETW["StartTime"] = CurrentTime - ETW["CurrentTime"];
        GottaGoFaster.CurrentTW = ETW;
        -- Update Timer
        GottaGoFaster.UpdateTWTimer();
        GottaGoFaster.UpdateTWObjectives();
      end
    end
  end
end
