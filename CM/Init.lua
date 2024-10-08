local ggf = GottaGoFaster;
local constants = ggf.Constants;
local utility = ggf.Utility;

function GottaGoFaster.SetupCM(CmID, currentZoneID)
  local _, _, steps = C_Scenario.GetStepInfo();
  local cmLevel, affixes, empowered = C_ChallengeMode.GetActiveKeystoneInfo();
  local cmID = C_ChallengeMode.GetActiveChallengeMapID();
  GottaGoFaster.CurrentCM = {};
  GottaGoFaster.CurrentCM["Name"], GottaGoFaster.CurrentCM["CmID"], GottaGoFaster.CurrentCM["GoldTimer"] = C_ChallengeMode.GetMapUIInfo(cmID);
  GottaGoFaster.CurrentCM["StartTime"] = nil;
  GottaGoFaster.CurrentCM["Time"] = nil;
  GottaGoFaster.CurrentCM["CurrentTime"] = nil;
  GottaGoFaster.CurrentCM["String"] = nil;
  GottaGoFaster.CurrentCM["ZoneID"] = currentZoneID;
  GottaGoFaster.CurrentCM["Deaths"] = 0;
  GottaGoFaster.CurrentCM["Steps"] = steps;
  GottaGoFaster.CurrentCM["Level"] = cmLevel;
  GottaGoFaster.CurrentCM["Empowered"] = empowered;
  GottaGoFaster.CurrentCM["Bonus"] = nil;
  GottaGoFaster.CurrentCM["Completed"] = false;
  GottaGoFaster.CurrentCM["AskedTime"] = nil;
  GottaGoFaster.CurrentCM["AskedForTimer"] = false;
  GottaGoFaster.CurrentCM["Version"] = constants.Version;
  GottaGoFaster.CurrentCM["Affixes"] = {};
  GottaGoFaster.CurrentCM["CurrentValues"] = {};
  GottaGoFaster.CurrentCM["FinalValues"] = {};
  GottaGoFaster.CurrentCM["ObjectiveTimes"] = {};
  GottaGoFaster.CurrentCM["Bosses"] = {};
  GottaGoFaster.CurrentCM["IncreaseTimers"] = {};
  GottaGoFaster.CurrentCM["BestRun"] = {};
  GottaGoFaster.CurrentCM["CurrentPull"] = {};

  if (cmLevel) then
    GottaGoFaster.CurrentCM["Bonus"] = C_ChallengeMode.GetPowerLevelDamageHealthMod(cmLevel);
  end

  if (GottaGoFaster.CurrentCM["Bonus"] == nil) then
    GottaGoFaster.CurrentCM["Bonus"] = "?"
  end

  for i, affixID in ipairs(affixes) do
    local affixName, affixDesc, affixNum = C_ChallengeMode.GetAffixInfo(affixID);
    GottaGoFaster.CurrentCM["Affixes"][affixID] = {};
    GottaGoFaster.CurrentCM["Affixes"][affixID]["name"] = affixName;
    GottaGoFaster.CurrentCM["Affixes"][affixID]["desc"] = affixDesc;
  end

  for i = 1, steps do
    local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(i);
    GottaGoFaster.CurrentCM["CurrentValues"][i] = tonumber(string.match(criteriaInfo.quantityString, "%d+"));
    GottaGoFaster.CurrentCM["FinalValues"][i] = criteriaInfo.totalQuantity;
    GottaGoFaster.CurrentCM["Bosses"][i] = string.gsub(criteriaInfo.description, " defeated", "");
  end

  if (GottaGoFaster.CurrentCM["GoldTimer"]) then
    GottaGoFaster.CurrentCM["IncreaseTimers"][1] = GottaGoFaster.CurrentCM["GoldTimer"];
    GottaGoFaster.CurrentCM["IncreaseTimers"][2] = GottaGoFaster.CurrentCM["GoldTimer"] * 0.8;
    GottaGoFaster.CurrentCM["IncreaseTimers"][3] = GottaGoFaster.CurrentCM["GoldTimer"] * 0.6;
  end

  GottaGoFaster.BuildCMTooltip();
  GottaGoFaster.HideObjectiveTracker();
  GottaGoFaster.CreateDungeon(GottaGoFaster.CurrentCM["Name"], GottaGoFaster.CurrentCM["CmID"], GottaGoFaster.CurrentCM["Bosses"]);
  GottaGoFaster.AskForBestRun(GottaGoFaster.CurrentCM["CmID"], GottaGoFaster.CurrentCM["Level"], GottaGoFaster.CurrentCM["Affixes"]);
end

function GottaGoFaster.SetupFakeCM()
  local affixes = {2, 7, 10};
  GottaGoFaster.CurrentCM = {};
  GottaGoFaster.CurrentCM["StartTime"] = GetTime() - (60*5);
  GottaGoFaster.CurrentCM["Time"] = nil;
  GottaGoFaster.CurrentCM["CurrentTime"] = nil;
  GottaGoFaster.CurrentCM["String"] = nil;
  GottaGoFaster.CurrentCM["Name"], GottaGoFaster.CurrentCM["CmID"], GottaGoFaster.CurrentCM["GoldTimer"] = C_ChallengeMode.GetMapUIInfo(206);
  GottaGoFaster.CurrentCM["ZoneID"] = 1492;
  GottaGoFaster.CurrentCM["Deaths"] = 4;
  GottaGoFaster.CurrentCM["Steps"] = 5;
  GottaGoFaster.CurrentCM["Level"] = 10;
  GottaGoFaster.CurrentCM["Empowered"] = true;
  GottaGoFaster.CurrentCM["Bonus"] = 100;
  GottaGoFaster.CurrentCM["Completed"] = false;
  GottaGoFaster.CurrentCM["AskedTime"] = nil;
  GottaGoFaster.CurrentCM["AskedForTimer"] = false;
  GottaGoFaster.CurrentCM["Version"] = constants.Version;
  GottaGoFaster.CurrentCM["Affixes"] = {};
  GottaGoFaster.CurrentCM["CurrentValues"] = {1, 1, 0, 0, 40};
  GottaGoFaster.CurrentCM["FinalValues"] = {1, 1, 1, 1, 160};
  GottaGoFaster.CurrentCM["ObjectiveTimes"] = {"1:15.460", "3:45.012"};
  GottaGoFaster.CurrentCM["Bosses"] = {"Rokmora", "Ularogg Cragshaper", "Naraxas", "Dargrul", "Forces"};
  GottaGoFaster.CurrentCM["IncreaseTimers"] = {};
  GottaGoFaster.CurrentCM["BestRun"] = {};

  for i, affixID in ipairs(affixes) do
    local affixName, affixDesc, affixNum = C_ChallengeMode.GetAffixInfo(affixID);
    GottaGoFaster.CurrentCM["Affixes"][affixID] = {};
    GottaGoFaster.CurrentCM["Affixes"][affixID]["name"] = affixName;
    GottaGoFaster.CurrentCM["Affixes"][affixID]["desc"] = affixDesc;
  end

  if (GottaGoFaster.CurrentCM["GoldTimer"]) then
    GottaGoFaster.CurrentCM["IncreaseTimers"][1] = GottaGoFaster.CurrentCM["GoldTimer"];
    GottaGoFaster.CurrentCM["IncreaseTimers"][2] = GottaGoFaster.CurrentCM["GoldTimer"] * 0.8;
    GottaGoFaster.CurrentCM["IncreaseTimers"][3] = GottaGoFaster.CurrentCM["GoldTimer"] * 0.6;
  end

  GottaGoFaster.BuildCMTooltip();
  GottaGoFaster.HideObjectiveTracker();
end
