-- Define Objects
-- Run
local Run = {}

function Run.New(corrupt, startTime, endTime, timeStamp, deaths, level, objectiveTimes, affixes, players)
  local self = {};
  self.active = false;
  self.corrupt = corrupt;
  self.startTime = startTime;
  self.endTime = endTime;
  self.timeStamp = timeStamp;
  self.deaths = deaths;
  self.level = level;
  self.objectiveTimes = objectiveTimes;
  self.affixes = affixes;
  self.players = players;
  return self
end

function Run.GetActive(self)
  return self.active
end

function Run.SetActive(self, active)
  self.active = active
end

function Run.GetCorrupt(self)
  return self.corrupt
end

function Run.SetCorrupt(self, corrupt)
  self.corrupt = corrupt
end

function Run.GetStartTime(self)
  return self.startTime
end

function Run.SetStartTime(self, startTime)
  self.startTime = startTime
end

function Run.GetEndTime(self)
  return self.endTime
end

function Run.SetEndTime(self, endTime)
  self.endTime = endTime
end

function Run.GetTimeStamp(self)
  return self.timeStamp
end

function Run.SetTimeStamp(self, timeStamp)
  self.timeStamp = timeStamp
end

function Run.GetDeaths(self)
  return self.deaths
end

function Run.SetDeaths(self, deaths)
  self.deaths = deaths
end

function Run.GetLevel(self)
  return self.level
end

function Run.SetLevel(self, level)
  self.level = level
end

function Run.GetObjectiveTimes(self)
  return self.objectiveTimes
end

function Run.SetObjectiveTimes(self, objectiveTimes)
  self.objectiveTimes = objectiveTimes
end

function Run.GetAffixes(self)
  return self.affixes
end

function Run.SetAffixes(self, affixes)
  self.affixes = affixes
end

function Run.GetPlayers(self)
  return self.players
end

function Run.SetPlayers(self, players)
  self.players = players
end

function GottaGoFasterHistory:InitModelRun()
  GottaGoFasterHistory.Models.Run = Run;
end

function GottaGoFasterHistory:RunHasBadTimeStamp(run)
  if (run["timeStamp"] ~= nil and run["timeStamp"]["day"] == nil) then
    return true;
  end

  return false;
end

function GottaGoFasterHistory:MatchAffixes(a1, a2)
  local affixes = {};
  local state = true;
  local counter = 0;
  for k, v in pairs(a1) do
    affixes[k] = true;
    counter = counter + 1;
  end
  for k, v in pairs(a2) do
    if (affixes[k] ~= true) then
      state = false;
    end
    counter = counter - 1;
  end
  return (state == true and counter == 0);
end

function GottaGoFasterHistory:FindBestRun(CmID, level, affixes)
  local history = GottaGoFasterHistory:GetHistory();
  local run = nil;
  local time = 9999;
  if (history[CmID] ~= nil and next(history[CmID]) ~= nil) then
    local dungeon = history[CmID];
    for k, v in pairs(dungeon["runs"]) do
      if (v["level"] == level and GottaGoFasterHistory:MatchAffixes(v["affixes"], affixes)) then
        local cTime = GottaGoFaster.CalculateRunTime(v["startTime"], v["endTime"], v["deaths"], v["corrupt"]);
        if (cTime < time) then
          run = v;
          time = cTime;
        end
      end
    end
  end
  return run;
end
