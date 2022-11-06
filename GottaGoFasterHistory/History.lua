local ggf = GottaGoFaster;
local ggfh = GottaGoFasterHistory;
local utility = GottaGoFaster.Utility;

function GottaGoFasterHistory:InitModels()
  GottaGoFasterHistory.Models = {};
  GottaGoFasterHistory:InitModelPlayer();
  GottaGoFasterHistory:InitModelDungeon();
  GottaGoFasterHistory:InitModelRun();
  GottaGoFasterHistory:InitModelTimeStamp();
end

function GottaGoFasterHistory:InitDungeon(name, zoneID, objectives)
  if (GottaGoFasterHistory:FindDungeonByZoneID(zoneID) == nil and name ~= nil and zoneID ~= nil and next(objectives) ~= nil) then
    GottaGoFasterHistory.db.profile.History[zoneID] = GottaGoFasterHistory.Models.Dungeon.New(name, zoneID, objectives);
  end
end

function GottaGoFasterHistory:StoreRun(cCM)
  if (cCM and next(cCM) ~= nil and cCM["ZoneID"]) then
    local k, d = GottaGoFasterHistory:FindDungeonByZoneID(cCM["ZoneID"]);
    if (cCM["Completed"] == true and d ~= nil) then
      local corrupt = false;

      -- Get Date Info
      local hours, mins = GetGameTime();
      local dateInfo = C_DateAndTime.GetCurrentCalendarTime();

      local deaths = cCM["Deaths"];
      local startTime = cCM["StartTime"];
      local endTime = GetTime();
      local timeStamp = GottaGoFasterHistory.Models.TimeStamp.New(dateInfo.month, dateInfo.monthDay, dateInfo.year, hours, mins);
      local level = cCM["Level"];
      local objectiveTimes = cCM["ObjectiveTimes"];
      local affixes = cCM["Affixes"];
      local players = GottaGoFasterHistory:GetPlayersFromGroup();
      if (startTime == nil) then
        corrupt = true;
        startTime = GottaGoFaster.StringToTime(cCM["Time"]);
      end
      if (startTime ~= nil and endTime ~= nil and deaths ~= nil and level ~= nil and next(objectiveTimes) ~= nil and next(players) ~= nil and next(timeStamp) ~= nil) then
        local run = GottaGoFasterHistory.Models.Run.New(corrupt, startTime, endTime, timeStamp, deaths, level, objectiveTimes, affixes, players);
        GottaGoFasterHistory.Models.Dungeon.AddRun(k, run);
      end
    end
  end
end

function GottaGoFasterHistory:InitHistory(data)
  data["msg"] = nil;
  ggfh:SetHistory(data);
  utility.DebugPrint("Sync'd History");
end

function GottaGoFasterHistory:SendBestRun(run)
  local data = {};
  data["msg"] = "BestRun";
  data["run"] = "NF";
  if (run ~= nil) then
    data["run"] = run;
  end
  local dataString = GottaGoFasterHistory:Serialize(data);
  GottaGoFasterHistory:SendCommMessage("GottaGoFasterCM", dataString, "WHISPER", GetUnitName("player"), "ALERT");
end