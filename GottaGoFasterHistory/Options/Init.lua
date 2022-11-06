function GottaGoFasterHistory:InitOptions()
  local defaults = {
    profile = {
      History = {},
      DayFix = false,
    },
  }
  GottaGoFasterHistory.db = LibStub("AceDB-3.0"):New("GottaGoFasterHistoryDB", defaults, true);
end

function GottaGoFasterHistory:DayFix()
  local history = GottaGoFasterHistory:GetHistory();

  for dungeonKey, dungeon in pairs(history) do
      local runs = dungeon["runs"];

      for runKey, run in pairs(runs) do
          if (GottaGoFasterHistory:RunHasBadTimeStamp(run)) then
              -- Perhaps Run Model Should Own This?
              GottaGoFasterHistory.db.profile.History[dungeonKey].runs[runKey]["timeStamp"]["day"] = 32;
          end
      end
  end
end

function GottaGoFasterHistory:BugFixes()
  -- Day Fix
  if (not GottaGoFasterHistory:GetDayFix()) then
    GottaGoFasterHistory:DayFix();

    GottaGoFasterHistory:SetDayFix(true);
  end
end