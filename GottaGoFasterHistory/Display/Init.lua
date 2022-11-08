local ggfh = GottaGoFasterHistory;
local aGUI = GottaGoFasterHistory.AceGUI;
local sStr = GottaGoFaster.Utility.ShortenStr;
local gold = "ffffdf00";
local lightGray = "ff7e7e7e";
local wrap = WrapTextInColorCode;
local function defaultFilter() return {["Level"] = 1, ["Limit"] = 5, ["Affix"] = 9999, ["Player"] = ""} end;
local limitList = {[5] = 5, [10] = 10, [15] = 15, [20] = 20, [9999] = "Any"};
local limitOrder = {[1] = 5, [2] = 10, [3] = 15, [4] = 20, [5] = 9999};
local treeC = nil;
local scroll = nil;
local runs = nil;
local objectives = nil;
local lastDungeon = nil;
local more = nil;
local startRun = 0;

ggfh.Filter = defaultFilter();

local function ScrollContainer(container)
  local scrollContainer = aGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  scrollContainer:SetFullWidth(true)
  scrollContainer:SetFullHeight(true)
  scrollContainer:SetLayout("Fill")

  container:AddChild(scrollContainer)

  scroll = aGUI:Create("ScrollFrame")
  scroll:SetLayout("List")
  scroll:SetFullWidth(true)
  scroll:SetFullHeight(true)
  scrollContainer:AddChild(scroll)
  return scroll;
end

local function BuildDate(date)
  if (date ~= nil and next(date) ~= nil) then
    return date["month"] .. "/" .. date["day"] .. "/" .. date["year"];
  end
  return "?";
end

local function BuildLabel(text, width)
  local l = aGUI:Create("Label");
  l:SetText(text);
  l:SetRelativeWidth(width);
  return l;
end

local function BuildPlayer(player)
  local class = string.upper(string.gsub(player["class"], "%s+", ""));
  local color = select(4, GetClassColor(class));
  local text = string.format(" |T%s:%s|t%s", ggfh:GetRoleIcon(player), "15", wrap(player["name"], color));
  return text;
end

local function BuildPlayers(players)
  local str = "\n";
  table.sort(players, function(a,b) return ggfh:GetRoleRank(a) < ggfh:GetRoleRank(b) end)
  for k, v in pairs(players) do
    str = str .. BuildPlayer(v) .. "\n";
  end
  return BuildLabel(str, 0.26);
end

local function BuildAffixes(affixes)
  if (affixes == nil or next(affixes) ~= nil) then
    local list = "";
    for k, v in pairs(affixes) do
      list = list .. v["name"] .. ", ";
    end
    list = GottaGoFaster.Utility.ShortenStr(list, 2);
    return list;
  end
  return "No Affixes";
end

local function BuildInfo(run)
  local level = run["level"];
  local deaths = run["deaths"];
  local affixes = run["affixes"];
  local date = run["timeStamp"];
  local time = GottaGoFaster.CalculateRunTime(run["startTime"], run["endTime"], run["deaths"], run["corrupt"]);
  local str = "\n";
  str = str .. wrap("Date: ", gold) .. BuildDate(date) .. "\n";
  str = str .. wrap("Run Time: ", gold) .. GottaGoFaster.SecsToTimeMS(time) .. "\n";
  str = str .. wrap("Level: ", gold) .. level .. "\n";
  str = str .. wrap("Deaths: ", gold) .. deaths .. "\n";
  str = str .. wrap("Affixes: ", gold) .. BuildAffixes(affixes) .. "\n";
  return BuildLabel(str, 0.36);
end

local function BuildObjectives(run, objectives)
  local c = run["objectiveTimes"];
  local str = "\n";
  for k, v in pairs(objectives) do
    if (c[k] ~= nil) then
      str = str .. wrap(v .. ": ", gold) .. c[k] .. "\n";
    end
  end
  return BuildLabel(str, 0.38);
end

local function BuildRun(run, objectives)
  local r = aGUI:Create("InlineGroup");
  r:SetLayout("Flow");
  r:SetRelativeWidth(1);
  r:AddChild(BuildInfo(run));
  r:AddChild(BuildObjectives(run, objectives));
  r:AddChild(BuildPlayers(run["players"]));
  return r;
end

local function BuildRuns(container, group, runs, objectives)
  local i = 0;
  local lastRun = startRun;
  if (runs ~= nil and next(runs) ~= nil and container ~= nil and objectives ~= nil) then
    table.sort(runs, function(a,b) return ggfh:TimeStampVal(a["timeStamp"]) > ggfh:TimeStampVal(b["timeStamp"]) end);
    for k, v in ipairs(runs) do
      if (i >= startRun and i < startRun + ggfh.Filter["Limit"]) then
        container:AddChild(BuildRun(v, objectives), more);
        lastRun = lastRun + 1;
      end
      i = i + 1;
    end
  end
  if (lastRun == i) then
    more:SetDisabled(true);
    more:SetText(wrap("End!", lightGray));
  end
  startRun = lastRun;
end

function ggfh:BuildMore()
  local b = aGUI:Create("Button");
  b:SetText("More");
  b:SetFullWidth(true);
  -- self:Release();
  b:SetCallback("OnClick", function(self) BuildRuns(scroll, group, runs, objectives); end);
  return b;
end

local function BuildIntro(container)
  container:AddChild(BuildLabel("GottaGoFaster History Records Data About Your M+ Runs! To Populate This Data Complete A Run!", 1.0));
end

local function BuildHeader(container, group, history)
  local h = aGUI:Create("Label");
  h:SetText(wrap(" " .. history["name"], gold));
  h:SetFontObject(GameFontHighlightLarge);
  container:AddChild(BuildLabel(" ", 1.0));
  container:AddChild(h);
end

local function search()
  ggfh:DrawData(treeC, lastDungeon);
end

local function BuildRunLimit()
  local l = aGUI:Create("Dropdown");
  l:SetLabel("Run Limit");
  l:SetList(limitList, limitOrder);
  l:SetValue(ggfh.Filter["Limit"]);
  l:SetCallback("OnValueChanged", function(key) ggfh.Filter["Limit"] = key.value end);
  return l;
end

local function BuildLevelFilter(history)
  local level = aGUI:Create("Dropdown");
  local levelsList = ggfh:FindLevelsByDungeon(history);
  level:SetRelativeWidth(0.33);
  level:SetLabel("Level");
  level:SetList(levelsList);
  level:SetValue(ggfh.Filter["Level"]);
  level:SetCallback("OnValueChanged", function(key) ggfh.Filter["Level"] = key.value end);
  return level;
end

local function BuildAffixesFilter(history)
  local affix = aGUI:Create("Dropdown");
  local affixesList = ggfh:FindAffixesByDungeon(history);
  affix:SetRelativeWidth(0.33);
  affix:SetLabel("Affixes");
  affix:SetList(affixesList);
  affix:SetValue(ggfh.Filter["Affix"]);
  affix:SetCallback("OnValueChanged", function(key) ggfh.Filter["Affix"] = key.value end);
  return affix;
end

local function BuildPlayerFilter()
  local player = aGUI:Create("EditBox");
  player:SetRelativeWidth(0.33);
  player:SetLabel("Player");
  player:SetText(ggfh.Filter["Player"]);
  player:SetMaxLetters(14);
  player:DisableButton(true);
  player:SetCallback("OnTextChanged", function(text) ggfh.Filter["Player"] = text:GetText(); end);
  player:SetCallback("OnEnterPressed", search);
  return player;
end

local function BuildSearchButton()
  local s = aGUI:Create("Button");
  s:SetRelativeWidth(1.0);
  s:SetText("Search!");
  s:SetCallback("OnClick", search);
  return s;
end

local function BuildFilter(container, history)
  local f = aGUI:Create("InlineGroup");
  f:SetLayout("Flow");
  f:SetRelativeWidth(1.0);
  -- f:AddChild(BuildRunLimit());
  f:AddChild(BuildLevelFilter(history));
  f:AddChild(BuildAffixesFilter(history));
  f:AddChild(BuildPlayerFilter());
  f:AddChild(BuildSearchButton());
  container:AddChild(f);
end

local function LevelFilter(level)
  return (ggfh.Filter["Level"] == 1 or level == ggfh.Filter["Level"]);
end

local function AffixFilter(affixes)
  if (ggfh.Filter["Affix"] == 9999) then
    return true;
  end
  for k, v in pairs(affixes) do
    if (k == ggfh.Filter["Affix"]) then
      return true;
    end
  end
  return false;
end

local function PlayerFilter(players)
  local f = string.lower(GottaGoFaster.Utility.TrimStr(ggfh.Filter["Player"]));
  if (f == "") then
    return true;
  end
  for k, v in pairs(players) do
    if (string.lower(v["name"]):find(f)) then
      return true;
    end
  end
  return false;
end

local function FilterRuns(runs)
  local newRuns = {};
  for k, v in pairs(runs) do
    if (LevelFilter(v["level"]) and AffixFilter(v["affixes"]) and PlayerFilter(v["players"])) then
      table.insert(newRuns, v);
    end
  end
  return newRuns;
end

function ggfh:DrawData(container, group)
  container:ReleaseChildren();
  if (lastDungeon == nil or lastDungeon ~= group) then
    lastDungeon = group;
    ggfh.Filter = defaultFilter();
  end
  if (group ~= "Introduction") then
    local _, history = ggfh:FindDungeonByCmID(group);
    scroll = ScrollContainer(container);
    runs = FilterRuns(history["runs"]);
    objectives = history["objectives"];
    startRun = 0;
    BuildHeader(scroll, group, history);
    BuildFilter(scroll, history);
    more = ggfh:BuildMore()
    scroll:AddChild(more);
    BuildRuns(scroll, group, runs, objectives);
  else
    BuildIntro(container);
  end
end

local function SelectGroup(container, event, group)
  ggfh:DrawData(container, group);
end

function ggfh:HistoryPanel()
  if (ggfh.OpenHistory ~= true) then
    ggfh.OpenHistory = true;
    local f = aGUI:Create("Frame");
    f:SetTitle("GottaGoFaster History");
    f:SetWidth(800);
    f:SetCallback("OnClose", function(widget) aGUI:Release(widget); GottaGoFasterHistory.OpenHistory = false; end);
    f:SetLayout("Fill");

    local t = aGUI:Create("TreeGroup");
    local list = ggfh.DungeonList();
    list = ggfh:IntroList(list);

    t:SetTree(list);
    t:SetRelativeWidth(1);
    t:SetCallback("OnGroupSelected", SelectGroup);
    t:SetLayout("Flow");
    t:SelectByValue(list[1].value);
    treeC = t;
    f:AddChild(treeC);
  end
end

function ggfh:DungeonList()
  local history = ggfh:GetHistory();
  local list = {};
  for k, v in pairs(history) do
    table.insert(list, {text = v.name, value = k});
  end
  return list
end

function ggfh:IntroList(list)
  if (list ~= nil and next(list) ~= nil) then
    return list;
  end
  local intro = {};
  intro[1] = {text = "Introduction", value = "Introduction"};
  return intro;
end
