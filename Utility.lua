local ggf = GottaGoFaster;
local Utility = {};

function Utility.ExplodeStr(div,str)
    if (div=='') then return {} end
    local pos,arr = 0,{}
    local count = 0;
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
        count = count + 1;
    end
    table.insert(arr,string.sub(str,pos))
    return arr, count + 1;
end

function Utility.TrimStr(str)
  if (str == nil) then
    return "";
  end
  return str:match("^%s*(.-)%s*$");
end

function Utility.DebugPrint(str)
  if (ggf.GetDebugMode(nil)) then
    ggf:Print(str);
  end
end

function Utility.ShortenStr(str, by)
  if (str and by) then
    return string.sub(str, 1, string.len(str) - by);
  else
    return str
  end
end

function Utility.ShortenAffixName(affix)
  local affixRenameTable = {
    -- The War Withing: Season One
    ["Xal'atath's Bargain: Ascendant"] = "Ascendant",
    ["Xal'atath's Bargain: Frenzied"] = "Frenzied",
    ["Xal'atath's Bargain: Voidbound"] = "Voidbound",
    ["Xal'atath's Bargain: Oblivion"] = "Oblivion",
    ["Xal'atath's Bargain: Devour"] = "Devour",
    ["Xal'atath's Bargain: Pulsar"] = "Pulsar",
    ["Xal'atath's Guile"] = "Guile",
    ["Challenger's Peril"] = "Peril"
  }
  -- Check if the affix is in the rename table
  if affixRenameTable[affix] then
    return affixRenameTable[affix]
  else
    -- Return the original affix name if not found in the table
    return affix
  end
end


ggf.Utility = Utility;
