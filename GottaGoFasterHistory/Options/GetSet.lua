function GottaGoFasterHistory:GetHistory()
  return GottaGoFasterHistory.db.profile.History;
end

function GottaGoFasterHistory:SetHistory(val)
  GottaGoFasterHistory.db.profile.History = val;
end

function GottaGoFasterHistory:GetDayFix()
  return GottaGoFasterHistory.db.profile.DayFix;
end

function GottaGoFasterHistory:SetDayFix(val)
  GottaGoFasterHistory.db.profile.DayFix = val;
end