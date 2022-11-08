local ggf = GottaGoFaster;
local utility = ggf.Utility;
local debugPrint = utility.DebugPrint;

function GottaGoFaster:OnInitialize()
    -- Called when the addon is loaded
    -- Register Frames
    GottaGoFasterFrame = CreateFrame("Frame", "GottaGoFasterFrame", UIParent);
    GottaGoFasterTimerFrame = CreateFrame("Frame", "GottaGoFasterTimerFrame", GottaGoFasterFrame);
    GottaGoFasterObjectiveFrame = CreateFrame("Frame", "GottaGoFasterObjectiveFrame", GottaGoFasterFrame);
    GottaGoFasterHideFrame = CreateFrame("Frame");
    GottaGoFasterHideFrame:Hide();
end

function GottaGoFaster:OnEnable()
    -- Called when the addon is enabled
    -- Register Events
    C_ChatInfo.RegisterAddonMessagePrefix("GottaGoFaster");
    C_ChatInfo.RegisterAddonMessagePrefix("GottaGoFasterCM");
    C_ChatInfo.RegisterAddonMessagePrefix("GottaGoFasterTW");
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    self:RegisterEvent("CHALLENGE_MODE_RESET");
    self:RegisterEvent("CHALLENGE_MODE_START")
    self:RegisterEvent("GOSSIP_SHOW");
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("SCENARIO_POI_UPDATE");
    self:RegisterEvent("WORLD_STATE_TIMER_START");
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterChatCommand("ggf", "ChatCommand");
    self:RegisterChatCommand("GottaGoFaster", "ChatCommand");
    self:RegisterComm("GottaGoFaster", "ChatComm");
    self:RegisterComm("GottaGoFasterCM", "CMChatComm");
    self:RegisterComm("GottaGoFasterTW", "TWChatComm");
    -- self:SecureHookScript(GameTooltip, "OnTooltipSetUnit", "GameTooltip_OnTooltipSetUnit")
    if C_TooltipInfo then
      TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, GottaGoFaster.OnTooltipSetUnit)
    else
      GameTooltip:HookScript("OnTooltipSetUnit", GottaGoFaster.OnTooltipSetUnit_Prepath)
    end

    -- Setup AddOn
    GottaGoFaster.InitState();
    GottaGoFaster.InitOptions();
    GottaGoFaster.InitFrame();
    GottaGoFaster.VersionCheck();

end



function GottaGoFaster:OnDisable()
  -- Called when the addon is disabled
end

function GottaGoFaster:CHALLENGE_MODE_COMPLETED()
  GottaGoFaster.Utility.DebugPrint("CM Complete");
  GottaGoFaster.CompleteCM();
  if (GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM) ~= nil) then
    GottaGoFaster.PrintNewBest(GottaGoFaster.CurrentCM);
    GottaGoFaster.CreateRun(GottaGoFaster.CurrentCM);
  end
end

function GottaGoFaster:CHALLENGE_MODE_RESET()
  GottaGoFaster.Utility.DebugPrint("CM Reset")
  GottaGoFaster.ResetState()
  GottaGoFaster.HideObjectiveTracker()
end

function GottaGoFaster:CHALLENGE_MODE_START()
  GottaGoFaster.Utility.DebugPrint("CM Start")
  GottaGoFaster.ResetState()
  GottaGoFaster.HideObjectiveTracker()
end

function GottaGoFaster:PLAYER_ENTERING_WORLD()
  GottaGoFaster.Utility.DebugPrint("Player Entering World");
  GottaGoFaster.WhereAmI()
end

function GottaGoFaster:SCENARIO_POI_UPDATE()
  if (GottaGoFaster.inCM) then
    GottaGoFaster.Utility.DebugPrint("Scenario POI Update");
    if (GottaGoFaster.CurrentCM["Steps"] == 0 and GottaGoFaster.CurrentCM["Completed"] == false and next(GottaGoFaster.CurrentCM["Bosses"]) == nil) then
      GottaGoFaster.WhereAmI();
    end
    GottaGoFaster.UpdateCMInformation();
    GottaGoFaster.UpdateCMObjectives();
  end
end

function GottaGoFaster:WORLD_STATE_TIMER_START()
  GottaGoFaster.Utility.DebugPrint("World Start Timer Start")
  if (ggf.inCM == false or GottaGoFaster.CurrentCM == nil or next(GottaGoFaster.CurrentCM) == nil or GottaGoFaster.CurrentCM["Steps"] == 0) then
    GottaGoFaster.WhereAmI()
  end
  if (ggf.inCM and GottaGoFaster.CurrentCM["Completed"] == false) then
      local _, timeCM = GetWorldElapsedTime(1);
      if (timeCM ~= nil and timeCM <= 2) then
        GottaGoFaster.StartCM(0);
        GottaGoFaster.UpdateCMObjectives();
      elseif (GottaGoFaster.CurrentCM["Deaths"]) then
        GottaGoFaster.CurrentCM["Deaths"] = GottaGoFaster.CurrentCM["Deaths"] + 1;
        GottaGoFaster.UpdateCMObjectives();
      end
  end
end

function GottaGoFaster:GOSSIP_SHOW()
  if (ggf.inCM == true and ggf.CurrentCM ~= nil and next(ggf.CurrentCM) ~= nil) then
    GottaGoFaster.HandleGossip();
  end
end

function GottaGoFaster:ZONE_CHANGED_NEW_AREA()
  GottaGoFaster.Utility.DebugPrint("Zone Changed New Area")
  GottaGoFaster.WhereAmI();
end

function GottaGoFaster.OnTooltipSetUnit(tooltip, data)
  if  (ggf.inCM == true and ggf.GetIndividualMobValue(nil) == true and GottaGoFaster.GetMobPoints(nil) and ggf.CurrentCM ~= nil and next(ggf.CurrentCM) ~= nil) then
    GottaGoFaster.AddMobPointsToTooltip();
  end
end
function GottaGoFaster.OnTooltipSetUnit_Prepath()
  if  (ggf.inCM == true and ggf.GetIndividualMobValue(nil) == true and GottaGoFaster.GetMobPoints(nil) and ggf.CurrentCM ~= nil and next(ggf.CurrentCM) ~= nil) then
    GottaGoFaster.AddMobPointsToTooltip();
  end
end

function GottaGoFaster:ChatCommand(input)
  if (string.lower(input) == "debugmode") then
    --local setting = not GottaGoFaster.GetDebugMode(nil);
    GottaGoFaster.SetDebugMode(nil, (not GottaGoFaster.GetDebugMode(nil)));
  elseif (string.lower(input) == "changelog") then
    GottaGoFaster.Changelog();
  else
    InterfaceOptionsFrame_OpenToCategory(GottaGoFaster.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(GottaGoFaster.optionsFrame);
  end
end

function GottaGoFaster:ChatComm(prefix, input, distribution, sender)
  GottaGoFaster.Utility.DebugPrint("History Message (From History Addon) Received");
  if (prefix == "GottaGoFaster" and input == "HistoryLoaded") then
    GottaGoFaster.Utility.DebugPrint("Input: History Loaded")
    if (GottaGoFaster.SendHistoryFlag == true) then
      GottaGoFaster.SendHistory(ggf.db.profile.History);
    end
  end
end

function GottaGoFaster:CMChatComm(prefix, input, distribution, sender)
  -- Right Now This Is Only Used For Syncing Timer
  GottaGoFaster.Utility.DebugPrint("CM Message Received");
  if (prefix == "GottaGoFasterCM" and input == "FixCM" and GottaGoFaster.inCM == true and GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM) ~= nil) then
    GottaGoFaster.CheckCMTimer();
  elseif (prefix == "GottaGoFasterCM" and GottaGoFaster.inCM == true and GottaGoFaster.CurrentCM and next(GottaGoFaster.CurrentCM) ~= nil) then
    local status, data = GottaGoFaster:Deserialize(input);
    if (data["msg"] == "BestRun") then
      utility.DebugPrint("Received Best Run");
      GottaGoFaster.AddBestRun(data["run"]);
    else
      -- Received Timer, See If You Need It, Then Update
      GottaGoFaster.FixCMTimer(input)
    end
  end
end

function GottaGoFaster:TWChatComm(prefix, input, distribution, sender)
  -- Right Now This Is Only Used For Syncing Timer
  GottaGoFaster.Utility.DebugPrint("TW Message Received");
  if (prefix == "GottaGoFasterTW" and input == "FixTW" and GottaGoFaster.inTW == true and GottaGoFaster.CurrentTW and next(GottaGoFaster.CurrentTW) ~= nil) then
    GottaGoFaster.CheckTWTimer();
  elseif (prefix == "GottaGoFasterTW" and GottaGoFaster.inTW == true and GottaGoFaster.CurrentTW and next(GottaGoFaster.CurrentTW) ~= nil) then
    GottaGoFaster.FixTWTimer(input);
  end
end

function GottaGoFaster.ResetState()
  GottaGoFaster.WipeCM();
  GottaGoFaster.WipeTW();
  GottaGoFaster.inCM = false;
  GottaGoFaster.inTW = false;
  GottaGoFaster.demoMode = false;
  GottaGoFaster.tooltip = GottaGoFaster.defaultTooltip;
  GottaGoFasterFrame:SetScript("OnUpdate", nil);
  GottaGoFaster.HideFrames();
  GottaGoFaster.ShowObjectiveTracker();
end

function GottaGoFaster.WhereAmI()
  local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
  GottaGoFaster.Utility.DebugPrint("Difficulty: " .. difficulty);
  GottaGoFaster.Utility.DebugPrint("Zone ID: " .. currentZoneID);
  if (difficulty == 8 and C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
    GottaGoFaster.InitCM(C_ChallengeMode.GetActiveChallengeMapID(), currentZoneID);
  else
    GottaGoFaster.ResetState()
  end
end