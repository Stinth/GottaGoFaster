-- Define Objects
-- Dungeon
local Dungeon = {}

function Dungeon.New(name, CmID, objectives)
  local self = {}
  self.name = name;
  self.CmID = CmID;
  self.objectives = objectives;
  self.runs = {};
  return self
end

function Dungeon.GetName(self)
  return self.name
end

function Dungeon.SetName(self, name)
  self.name = name
end

function Dungeon.GetCmID(self)
  return self.CmID
end

function Dungeon.SetCmID(self, CmID)
  self.CmID = CmID
end

function Dungeon.GetObjectives(self)
  return self.objectives
end

function Dungeon.SetObjectives(self, objectives)
  self.objectives = objectives
end

function Dungeon.GetRuns(self)
  return self.runs
end

function Dungeon.SetRuns(self, runs)
  self.runs = runs
end

function Dungeon.AddRun(self, run)
  table.insert(GottaGoFasterHistory.db.profile.History[self].runs, run);
end

function GottaGoFasterHistory:InitModelDungeon()
  GottaGoFasterHistory.Models.Dungeon = Dungeon;
end

function GottaGoFasterHistory:FindDungeonByCmID(CmID)
  if (GottaGoFasterHistory.db.profile.History == nil) then
    GottaGoFasterHistory.db.profile.History = {};
  end
  if (next(GottaGoFasterHistory.db.profile.History) ~= nil) then
    if (GottaGoFasterHistory.db.profile.History[CmID] and next(GottaGoFasterHistory.db.profile.History[CmID]) ~= nil) then
      return CmID, GottaGoFasterHistory.db.profile.History[CmID];
    end
  end
  return nil, nil;
end

function GottaGoFasterHistory:FindLevelsByDungeon(dungeon)
  local levels = {[1] = "Any"};
  if (dungeon == nil) then
    return levels;
  end
  for k, v in pairs(dungeon["runs"]) do
    levels[v["level"]] = v["level"];
  end
  return levels;
end

function GottaGoFasterHistory:FindAffixesByDungeon(dungeon)
  local affixes = {[9999] = "Any"};
  if (affixes == nil) then
    return affixes;
  end
  for k, v in pairs(dungeon["runs"]) do
    for key, affix in pairs(v["affixes"]) do
      affixes[key] = affix["name"];
    end
  end
  return affixes;
end
