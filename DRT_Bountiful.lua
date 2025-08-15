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


--- 地下堡故事变种
-- 1. /dump C_AreaPoiInfo.GetAreaPOIInfo(2371, 8273) 获取 tooltipWidgetSet
-- doc: https://warcraft.wiki.gg/wiki/API_C_UIWidgetManager.GetAllWidgetsBySetID
-- 2. /dump C_UIWidgetManager.GetAllWidgetsBySetID(1518) 获取widgetID
-- doc: https://warcraft.wiki.gg/wiki/API_C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo
-- 3. /dump C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(6972) 获取 tooltip 的 text
