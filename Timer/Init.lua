local ggf = GottaGoFaster;
local utility = ggf.Utility;

function GottaGoFaster.InitState()
  -- Default AddOn Globals
  GottaGoFaster.inTW = false;
  GottaGoFaster.inCM = false;
  GottaGoFaster.minWidth = 200;
  GottaGoFaster.unlocked = false;
  GottaGoFaster.defaultTooltip = "Not In A CM";
  GottaGoFaster.tooltip = GottaGoFaster.defaultTooltip;
  GottaGoFaster.demoMode = false;
end

function GottaGoFaster.TooltipOnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
  GameTooltip:SetText(GottaGoFaster.tooltip, nil, nil, nil, nil, 1);
end

function GottaGoFaster.TooltipOnLeave(self)
  GameTooltip_Hide();
end

function GottaGoFaster.InitFrame()
  -- Register Textures
  GottaGoFasterFrame.texture = GottaGoFasterFrame:CreateTexture(nil,"BACKGROUND");
  GottaGoFasterTimerFrame.texture = GottaGoFasterTimerFrame:CreateTexture(nil, "BACKGROUND");
  GottaGoFasterObjectiveFrame.texture = GottaGoFasterObjectiveFrame:CreateTexture(nil, "BACKGROUND");

  -- Register Fonts
  GottaGoFasterTimerFrame.font = GottaGoFasterTimerFrame:CreateFontString(nil, "OVERLAY");
  GottaGoFasterObjectiveFrame.font = GottaGoFasterObjectiveFrame:CreateFontString(nil, "OVERLAY");

  -- Move Frame When Unlocked
  GottaGoFasterFrame:SetScript("OnMouseDown", function(self, button)
    if GottaGoFaster.unlocked and button == "LeftButton" and not self.isMoving then
     self:StartMoving();
     self.isMoving = true;
    end
  end);

  GottaGoFasterFrame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
     self:StopMovingOrSizing();
     self.isMoving = false;
     local point, relativeTo, relativePoint, xOffset, yOffset = GottaGoFasterFrame:GetPoint(1);

     GottaGoFaster.db.profile.FrameAnchor = point;
     GottaGoFaster.db.profile.FrameX = xOffset;
     GottaGoFaster.db.profile.FrameY = yOffset;
    end
  end);

  GottaGoFasterFrame:SetScript("OnHide", function(self)
    if ( self.isMoving ) then
     self:StopMovingOrSizing();
     self.isMoving = false;
    end
  end);

  -- Set Frame Width / Height
  GottaGoFasterFrame:SetHeight(340);
  GottaGoFasterFrame:SetWidth(GottaGoFaster.minWidth);
  GottaGoFasterFrame:SetPoint(GottaGoFaster.db.profile.FrameAnchor, GottaGoFaster.db.profile.FrameX, GottaGoFaster.db.profile.FrameY);
  GottaGoFasterFrame:SetMovable(GottaGoFaster.unlocked);
  GottaGoFasterFrame:EnableMouse(GottaGoFaster.unlocked);
  GottaGoFasterTimerFrame:SetHeight(40);
  GottaGoFasterTimerFrame:SetWidth(GottaGoFaster.minWidth);
  GottaGoFasterTimerFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.TimerX, GottaGoFaster.db.profile.TimerY);
  GottaGoFasterObjectiveFrame:SetHeight(300);
  GottaGoFasterObjectiveFrame:SetWidth(GottaGoFaster.minWidth);
  GottaGoFasterObjectiveFrame:SetPoint("TOPLEFT", GottaGoFaster.db.profile.ObjectiveX, GottaGoFaster.db.profile.ObjectiveY);

  -- Set Font Settings
  GottaGoFasterTimerFrame.font:SetAllPoints(true);
  GottaGoFasterTimerFrame.font:SetJustifyH(GottaGoFaster.db.profile.TimerAlign);
  GottaGoFasterTimerFrame.font:SetJustifyV("BOTTOM");
  GottaGoFasterTimerFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.TimerFont), GottaGoFaster.db.profile.TimerFontSize, GottaGoFaster.db.profile.TimerFontFlag);
  GottaGoFasterTimerFrame.font:SetTextColor(1, 1, 1, 1);

  GottaGoFasterObjectiveFrame.font:SetAllPoints(true);
  GottaGoFasterObjectiveFrame.font:SetJustifyH(GottaGoFaster.db.profile.ObjectiveAlign);
  GottaGoFasterObjectiveFrame.font:SetJustifyV("TOP");
  GottaGoFasterObjectiveFrame.font:SetFont(GottaGoFaster.LSM:Fetch("font", GottaGoFaster.db.profile.ObjectiveFont), GottaGoFaster.db.profile.ObjectiveFontSize, GottaGoFaster.db.profile.ObjectiveFontFlag);
  GottaGoFasterObjectiveFrame.font:SetTextColor(1, 1, 1, 1);

  -- Remove Frame Background
  GottaGoFasterFrame.texture:SetAllPoints(GottaGoFasterFrame);
  GottaGoFasterFrame.texture:SetTexture(0.5, 0.5, 0.5, 0);
  GottaGoFasterTimerFrame.texture:SetAllPoints(GottaGoFasterTimerFrame);
  GottaGoFasterTimerFrame.texture:SetTexture(0, 1, 0, 0);
  GottaGoFasterObjectiveFrame.texture:SetAllPoints(GottaGoFasterObjectiveFrame);
  GottaGoFasterObjectiveFrame.texture:SetTexture(0, 1, 0, 0);

  -- Create Tooltip
  if (GottaGoFaster.GetTimerTooltip(nil)) then
    GottaGoFasterTimerFrame:SetScript("OnEnter", GottaGoFaster.TooltipOnEnter);
    GottaGoFasterTimerFrame:SetScript("OnLeave", GottaGoFaster.TooltipOnLeave);
  end
end
