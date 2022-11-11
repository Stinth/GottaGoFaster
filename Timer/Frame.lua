function GottaGoFaster.ResizeFrame()
  local width;
  local minWidth = GottaGoFaster.minWidth;
  local timerWidth = GottaGoFasterTimerFrame.font:GetStringWidth();
  local objectiveWidth = GottaGoFasterObjectiveFrame.font:GetStringWidth();
  if (minWidth >= timerWidth and minWidth >= objectiveWidth) then
    -- minWidth
    width = minWidth;
  elseif (timerWidth >= minWidth and timerWidth >= objectiveWidth) then
    -- Timer Width
    width = timerWidth;
  else
    -- Objective Width
    width = objectiveWidth
  end
  GottaGoFasterObjectiveFrame:SetWidth(width);
  GottaGoFasterTimerFrame:SetWidth(width);
  --GottaGoFasterFrame:SetWidth(width);
end

function GottaGoFaster.ShowFrames()
  if (GottaGoFasterFrame:IsShown() == false) then
    GottaGoFasterFrame:Show();
  end
  if (GottaGoFasterTimerFrame:IsShown() == false) then
    GottaGoFasterTimerFrame:Show();
  end
  if (GottaGoFasterObjectiveFrame:IsShown() == false) then
    GottaGoFasterObjectiveFrame:Show();
  end
end

function GottaGoFaster.HideFrames()
  if (GottaGoFasterFrame:IsShown()) then
    GottaGoFasterFrame:Hide();
  end
  if (GottaGoFasterTimerFrame:IsShown()) then
    GottaGoFasterTimerFrame:Hide();
  end
  if (GottaGoFasterObjectiveFrame:IsShown()) then
    GottaGoFasterObjectiveFrame:Hide();
  end
end
