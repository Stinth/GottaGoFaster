local ggf = GottaGoFaster;
local constants = ggf.Constants;
local utility = ggf.Utility;

function GottaGoFaster.AskForTimer(timeCM)
  if (GottaGoFaster.CurrentCM["StartTime"] == nil and timeCM > 1 and GottaGoFaster.CurrentCM["AskedForTimer"] == false) then
    GottaGoFaster.Utility.DebugPrint("Asking For Timer");
    GottaGoFaster.CurrentCM["AskedTime"] = GetTime();
    GottaGoFaster.CurrentCM["AskedForTimer"] = true;
    GottaGoFaster:SendCommMessage("GottaGoFasterCM", "FixCM", "PARTY", nil, "ALERT");
  end
end

function GottaGoFaster.CheckCMTimer()
  if (GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM) ~= nil and GottaGoFaster.CurrentCM["StartTime"] ~= nil and GottaGoFaster.CurrentCM["Steps"] ~= 0 and GottaGoFaster.CurrentCM["CurrentTime"] ~= nil) then
    local CurrentCMString = GottaGoFaster:Serialize(GottaGoFaster.CurrentCM);
    GottaGoFaster.Utility.DebugPrint("CM Timer Sent");
    GottaGoFaster:SendCommMessage("GottaGoFasterCM", CurrentCMString, "PARTY", nil, "ALERT");
  end
end

function GottaGoFaster.FixCMTimer(input)
  if (GottaGoFaster.inCM == true and GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM) ~= nil) then
    if (GottaGoFaster.CurrentCM["StartTime"] == nil and GottaGoFaster.CurrentCM["AskedTime"] ~= nil) then
      GottaGoFaster.Utility.DebugPrint("Replacing CM Timer");
      local status, newCM = GottaGoFaster:Deserialize(input);
      if (status and newCM and newCM["CurrentTime"] and newCM["Version"] ~= nil and newCM["Version"] >= constants.Version) then
        newCM["StartTime"] = GottaGoFaster.CurrentCM["AskedTime"] - newCM["CurrentTime"];
        GottaGoFaster.CurrentCM = newCM;
        -- Update Timer
        GottaGoFaster.UpdateCMTimer();
        GottaGoFaster.UpdateCMObjectives();
      end
    end
  end
end

function GottaGoFaster.CreateDungeon(name, CmID, objectives)
  local data = {};
  data["name"] = name;
  data["CmID"] = CmID;
  data["objectives"] = objectives;
  data["msg"] = "CreateDungeon";
  local dataString = GottaGoFaster:Serialize(data);
  GottaGoFaster:SendCommMessage(constants.HistoryPrefix, dataString, "WHISPER", GetUnitName("player"), "ALERT");
end

function GottaGoFaster.CreateRun(data)
  -- Why was this called twice?
  data["msg"] = "CreateRun";
  local dataString = GottaGoFaster:Serialize(data);
  GottaGoFaster:SendCommMessage(constants.HistoryPrefix, dataString, "WHISPER", GetUnitName("player"), "ALERT");
end

function GottaGoFaster.SendHistory(data)
  if (data ~= nil and next(data) ~= nil) then
    data["msg"] = "InitHistory";
    local dataString = GottaGoFaster:Serialize(data);
    utility.DebugPrint("Sending History For Sync");
    GottaGoFaster:SendCommMessage(constants.HistoryPrefix, dataString, "WHISPER", GetUnitName("player"), "ALERT")
    utility.DebugPrint("Clearing History");
    ggf.db.profile.History = {};
  end
end

function GottaGoFaster.AskForBestRun(CmID, level, affixes)
  local data = {};
  data["msg"] = "AskForBestRun";
  data["CmID"] = CmID;
  data["level"] = level;
  data["affixes"] = affixes;
  local dataString = GottaGoFaster:Serialize(data);
  utility.DebugPrint("Asking For Best Run");
  GottaGoFaster:SendCommMessage(constants.HistoryPrefix, dataString, "WHISPER", GetUnitName("player"), "ALERT");
end
