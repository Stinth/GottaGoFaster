GottaGoFasterHistory = LibStub("AceAddon-3.0"):NewAddon("GottaGoFasterHistory", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceSerializer-3.0", "AceComm-3.0");
GottaGoFasterHistory.AceGUI = LibStub("AceGUI-3.0", true);

local ggf = GottaGoFaster;
local ggfh = GottaGoFasterHistory;
local utility = GottaGoFaster.Utility;

function GottaGoFasterHistory:OnInitialize()
    -- Called when the addon is loaded
end

function GottaGoFasterHistory:OnEnable()
    -- Called when the addon is enabled

    -- Register Events
    C_ChatInfo.RegisterAddonMessagePrefix("GGFHistory");
    self:RegisterChatCommand("ggfh", "ChatCommand");
    self:RegisterChatCommand("GottaGoFasterHistory", "ChatCommand");
    self:RegisterComm("GGFHistory", "ChatComm");

    GottaGoFasterHistory:InitOptions();
    GottaGoFasterHistory:InitModels();
    GottaGoFasterHistory:BugFixes();
    GottaGoFasterHistory:SendCommMessage("GottaGoFaster", "HistoryLoaded", "WHISPER", GetUnitName("player"), "ALERT");
end

function GottaGoFasterHistory:OnDisable()
  -- Called when the addon is disabled
end

function GottaGoFasterHistory:ChatCommand(input)
  -- Chat Commands Go Here
  ggfh:HistoryPanel();
end

function GottaGoFasterHistory:ChatComm(prefix, input, distribution, sender)
  if (prefix == "GGFHistory" and sender == GetUnitName("player")) then
    utility.DebugPrint("History Message Received");
    local status, data = GottaGoFasterHistory:Deserialize(input);
    if (status and data ~= nil and next(data) ~= nil and data["msg"] ~= nil) then
      if (data["msg"] == "CreateDungeon" and data["name"] ~= nil and data["CmID"] ~= nil and data["objectives"] ~= nil and next(data["objectives"]) ~= nil) then
        utility.DebugPrint("Calling Create Dungeon");
        GottaGoFasterHistory:InitDungeon(data["name"], data["CmID"], data["objectives"]);
      elseif (data["msg"] == "CreateRun") then
        utility.DebugPrint("Calling Create Run");
        GottaGoFasterHistory:StoreRun(data);
      elseif (data["msg"] == "InitHistory") then
        utility.DebugPrint("Calling Init History");
        GottaGoFasterHistory:InitHistory(data);
      elseif (data["msg"] == "OpenHistory") then
        GottaGoFasterHistory:HistoryPanel();
      elseif (data["msg"] == "AskForBestRun") then
        local run = GottaGoFasterHistory:FindBestRun(data["CmID"], data["level"], data["affixes"]);
        GottaGoFasterHistory:SendBestRun(run);
      end
    end
  end
end
