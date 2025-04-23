local DelvesPoiIDs = {
  -- 多恩岛
  [7787] = { ["zone"] = 2248 }, -- 地铺矿洞
  [7779] = { ["zone"] = 2248 }, -- 真菌之愚
  [7781] = { ["zone"] = 2248 }, -- 克莱格瓦之眠
  -- 喧鸣深窟
  [7782] = { ["zone"] = 2214 }, -- 水能堡
  [7788] = { ["zone"] = 2214 }, -- 恐惧陷坑
  [8181] = { ["zone"] = 2214 }, -- 九号挖掘场
  -- 陨圣峪
  [7780] = { ["zone"] = 2215 }, -- 丝菌师洞穴
  [7785] = { ["zone"] = 2215 }, -- 夜幕圣所
  [7783] = { ["zone"] = 2215 }, -- 无底沉穴
  [7789] = { ["zone"] = 2215 }, -- 飞掠裂口
  -- 艾基
  -- "The Spiral Weave"
  [7790] = { ["zone"] = 2255 }, -- 螺旋织纹
  [7784] = { ["zone"] = 2255 }, -- 塔克雷桑
  [7786] = { ["zone"] = 2255 }, -- 幽暗要塞
  --安德麦
  [8246] = { ["zone"] = 2346 }, -- 闸板陋巷
}

---获取今日丰裕地下堡
function GetBountifulDelves()
  local bountifulDelves = {}
  for delvePoiID, delveConfig in pairs(DelvesPoiIDs) do
    local delve = C_AreaPoiInfo.GetAreaPOIInfo(delveConfig["zone"], delvePoiID)

    if delve ~= nil and delve["atlasName"] == "delves-bountiful" then
      table.insert(bountifulDelves, delve["name"])
    end
  end

  return table.concat(bountifulDelves, ", ")
end
