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

ggf.Utility = Utility;
