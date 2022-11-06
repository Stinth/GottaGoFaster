local ggf = GottaGoFaster;
local constants = ggf.Constants;
local utility = ggf.Utility;
local version = constants.Version;

function GottaGoFaster.VersionCheck()
  local lastVersion = ggf.GetVersion(nil);
  utility.DebugPrint("Last Version: " .. lastVersion);
  utility.DebugPrint("Current Version: " .. version);
  if (lastVersion == nil or lastVersion == 0) then
    -- First Time Run
    ggf.VersionFirstRun();
  elseif (lastVersion < version) then
    if (lastVersion < 40000) then
      GottaGoFaster.SetUseMdt(nil, false)
    end
    ggf:Print("Welcome To v" .. constants.VersionName);
    ggf:Print("Check The Changelog For Information About The Update!");
  end
  ggf.SetVersion(nil, version);
end

function GottaGoFaster.VersionFirstRun()
  utility.DebugPrint("First Run");
  GottaGoFaster.SendHistoryFlag = true;
end
