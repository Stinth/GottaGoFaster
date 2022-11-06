-- Define Objects
-- Player
local Player = {}

local Icons = {
	TANK = "Interface\\AddOns\\GottaGoFasterHistory\\Media\\tank",
	HEALER = "Interface\\AddOns\\GottaGoFasterHistory\\Media\\healer",
	DAMAGER = "Interface\\AddOns\\GottaGoFasterHistory\\Media\\dps"
}

local Ranks = {
  TANK = 1,
  HEALER = 2,
  DAMAGER = 3
}

function Player.New(name, class, role)
  local self = {}
  self.name = name;
  self.class = class;
  self.role = role;
  return self
end

function Player.GetName(self)
  return self.name
end

function Player.SetName(self, name)
  self.name = name
end

function Player.GetClass(self)
  return self.class
end

function Player.SetClass(self, class)
  self.class = class
end

function Player.GetRole(self)
  return self.role
end

function Player.SetRole(self, role)
  self.role = role
end

function GottaGoFasterHistory:InitModelPlayer()
  GottaGoFasterHistory.Models.Player = Player;
end

function GottaGoFasterHistory:GetGroupPrefix()
  if IsInRaid() then
    return "raid";
  else
    return "party";
  end
end

function GottaGoFasterHistory:GetPlayer(unit)
  local name = GetUnitName(unit, false);
  local class = UnitClass(unit);
  local role = UnitGroupRolesAssigned(unit);
  return GottaGoFasterHistory.Models.Player.New(name, class, role);
end

function GottaGoFasterHistory:GetPlayersFromGroup()
  local players = {};
  local members = GetNumGroupMembers();
  local prefix = GottaGoFasterHistory:GetGroupPrefix();
  for i = 1, members - 1 do
    table.insert(players, GottaGoFasterHistory:GetPlayer(prefix .. i));
  end
  table.insert(players, GottaGoFasterHistory:GetPlayer("player"));
  return players;
end

function GottaGoFasterHistory:GetRoleIcon(player)
  return Icons[player["role"]];
end

function GottaGoFasterHistory:GetRoleRank(player)
  return Ranks[player["role"]];
end
