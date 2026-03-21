---获取今日丰裕地下堡
function GetBountifulDelves()
    local bountifulDelves = {}
    for delvePoiID, delveConfig in pairs(DRT_DELVES_POI_IDS) do
        local delveIds = C_AreaPoiInfo.GetDelvesForMap(delveConfig["zone"])
        for _, delveID in ipairs(delveIds) do
            local delveInfo = C_AreaPoiInfo.GetAreaPOIInfo(delveConfig["zone"], delveID)
            print(delveInfo.name .. delveInfo.atlasName)

            if delveInfo ~= nil and delveInfo.atlasName == "delves-bountiful" then
                table.insert(bountifulDelves, delveInfo.name)
            end
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
