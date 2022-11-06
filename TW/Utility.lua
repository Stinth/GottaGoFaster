function GottaGoFaster.CheckPositions(currentZoneID)
  local isAnyoneOutside = false;
  isAnyoneOutside = isAnyoneOutside or GottaGoFaster.CheckUnitPosition(currentZoneID, "player");
  if (GetNumGroupMembers() ~= 0) then
  	for i = 1, GetNumGroupMembers() - 1
  	do
      isAnyoneOutside = isAnyoneOutside or GottaGoFaster.CheckUnitPosition(currentZoneID, "party" .. i);
    end
  end
  if isAnyoneOutside then
    --time to start timer
    GottaGoFaster.StartTW();
    return true;
  end
  return false;
end

function GottaGoFaster.CheckUnitPosition(currentZoneID, unitName)
  if currentZoneID and unitName then
    local dx, dy, distance;
    local posX, posY, posZ, terrainMapID = UnitPosition(unitName);
    local startX = GottaGoFasterInstanceInfo[currentZoneID]["startingArea"]["x"];
    local startY = GottaGoFasterInstanceInfo[currentZoneID]["startingArea"]["y"];
    local safeZone = GottaGoFasterInstanceInfo[currentZoneID]["startingArea"]["safeZone"];
    if (currentZoneID == terrainMapID) then
      dx = startX - posX;
      dy = startY - posY;
      distance = math.sqrt((dx * dx) + (dy * dy));
      return distance > safeZone;
    end
  end
  return false;
end
