---获取今日丰裕地下堡
function GetBountifulDelves()
  local bountifulDelves = {}
  for delvePoiID, delveConfig in pairs(DRT_DELVES_POI_IDS) do
    -- uiMapID: 地下堡所在的地图, areaPoiID 地下堡的PIO id
    local delve = C_AreaPoiInfo.GetAreaPOIInfo(delveConfig["zone"], delvePoiID)

    if delve ~= nil and delve["atlasName"] == "delves-bountiful" then
      table.insert(bountifulDelves, delve["name"])
    end
  end

  return table.concat(bountifulDelves, ", ")
end
