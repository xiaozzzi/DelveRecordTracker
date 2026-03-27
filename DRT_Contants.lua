DRT_GLOBLE = {
    VERSION = "v12.0.1",
}

-- DRT_DELVES_POI_IDS = {
--     -- 多恩岛
--     [7787] = { ["zone"] = 2248 }, -- 地铺矿洞
--     [7779] = { ["zone"] = 2248 }, -- 真菌之愚
--     [7781] = { ["zone"] = 2248 }, -- 克莱格瓦之眠
--     -- 喧鸣深窟
--     [7782] = { ["zone"] = 2214 }, -- 水能堡
--     [7788] = { ["zone"] = 2214 }, -- 恐惧陷坑
--     [8181] = { ["zone"] = 2214 }, -- 九号挖掘场
--     -- 陨圣峪
--     [7780] = { ["zone"] = 2215 }, -- 丝菌师洞穴
--     [7785] = { ["zone"] = 2215 }, -- 夜幕圣所
--     [7783] = { ["zone"] = 2215 }, -- 无底沉穴
--     [7789] = { ["zone"] = 2215 }, -- 飞掠裂口
--     -- 艾基
--     -- "The Spiral Weave"
--     [7790] = { ["zone"] = 2255 }, -- 螺旋织纹
--     [7784] = { ["zone"] = 2255 }, -- 塔克雷桑
--     [7786] = { ["zone"] = 2255 }, -- 幽暗要塞
--     -- 安德麦
--     [8246] = { ["zone"] = 2346 }, -- 闸板陋巷
--     -- 卡雷什
--     [8273] = { ["zone"] = 2371 }, -- 档案馆突袭
--     [8323] = { ["zone"] = 2371 }, -- 虚空之锋庇护所
-- }

-- DRT_DELVES_ID = {
--     -- 2274 卡加阿兹
--     -- 2248 多恩岛
--     2249, -- 真菌之愚
--     2250, -- 克莱格瓦之眠
--     2269, -- 地匍矿洞
--     -- 2214 喧鸣深窟
--     2251, -- 水能堡
--     2302, -- 恐惧陷坑
--     2396, -- 九号挖掘场
--     -- 2215 陨圣峪
--     2277, -- 夜幕圣所
--     2301, -- 无底沉穴
--     2310, -- 飞掠裂口
--     2312, -- 丝菌师洞穴
--     -- 2255 艾基
--     2299, -- 幽暗要塞
--     2314, -- 塔克-雷桑深渊
--     2347, -- 螺旋织纹
--     -- 2346 安德麦
--     2423, -- 闸板陋巷
--     -- 2371 卡雷什
--     2476, -- 档案馆突袭 (2454 / )
--     2484, -- 虚空之锋庇护所
-- }

--- 地下堡 PIO id, 查询当日的丰裕地下堡
--- POI ID 查询: https://wago.tools/db2/areapoi?build=11.2.0.62493&locale=zhCN
--- cmd: /dump C_AreaPoiInfo.GetAreaPOIInfo(2339, 7898) -- 获取地图信息
--- cmd: /dump C_AreaPoiInfo.GetDelvesForMap(2371)      -- 获取地下堡ID
DRT_DELVES_POI_IDS = {
    -- 永歌森林
    [2502] = { ["zone"] = 2395 }, -- 聚影领地
    -- 银月城
    [2547] = { ["zone"] = 2393 }, -- 学府骚动 2547/2577/2578
    -- 祖阿曼
    [2535] = { ["zone"] = 2437 }, -- 阿塔阿曼 2535、2536
    [2503] = { ["zone"] = 2437 }, -- 暮光地穴 2503、2504
    -- 哈莱恩达尔
    [2505] = { ["zone"] = 2576 }, -- 回忆深沟
    [2510] = { ["zone"] = 2576 }, -- 憎怨斗坑
    -- 虚影风暴
    [2506] = { ["zone"] = 2405 }, -- 影卫营 2506
    [2571] = { ["zone"] = 2405 }, -- 戮日盛殿 2571、2528

}

---地下堡列表, 用于下拉列表显示地下堡的名称
---cmd: /dump C_Map.GetMapInfo(2252) 获取地图名称
---cmd: /dump C_Map.GetMapChildrenInfo(2255) 获取子地图名称
---cmd: /dump C_Map.GetBestMapForUnit("player") 获取当前用户所在地图名称
DRT_DELVES_ID = {
    2502, 2547, 2535, 2503, 2505, 2510, 2506, 2571
}

--- dele
DRT_DELVE_TIERS = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
}

DRT_DELVE_TREASURE_MAP_ICON = {
    ["11.1"] = "Icon_treasuremap",
    ["11.2"] = "Inv_enchanting_crystal",
    ["12.0"] = "Icon_treasuremap"
}

-- From saveInstances
-- https://wago.tools/db2/QuestLabel?filter%5BLabelID%5D=6036&page=1
PREY_QUESTID = {
    91269, -- Prey: Dengzag, the Darkened Blaze (Nightmare)
    91268, -- Prey: Grothoz, the Burning Shadow (Nightmare)
    91267, -- Prey: Thorn-Witch Liset (Nightmare)
    91266, -- Prey: Thornspeaker Edgath (Nightmare)
    91265, -- Prey: Neydra the Starving (Nightmare)
    91264, -- Prey: Lost Theldrin (Nightmare)
    91263, -- Prey: Vylenna the Defector (Nightmare)
    91262, -- Prey: Knight-Errant Bloodshatter (Nightmare)
    91261, -- Prey: Imperator Enigmalia (Nightmare)
    91260, -- Prey: Executor Kaenius (Nightmare)
    91259, -- Prey: Consul Nebulor (Nightmare)
    91258, -- Prey: Praetor Singularis (Nightmare)
    91257, -- Prey: Crusader Luxia Maxwell (Nightmare)
    91256, -- Prey: High Vindicator Vureem (Nightmare)
    91241, -- Prey: Lamyne of the Undercroft (Nightmare)
    91239, -- Prey: Petyoll the Razorleaf (Nightmare)
    91237, -- Prey: Lieutenant Blazewing (Nightmare)
    91235, -- Prey: Ranger Swiftglade (Nightmare)
    91233, -- Prey: The Wing of Akil'zon (Nightmare)
    91231, -- Prey: The Talon of Jan'alai (Nightmare)
    91229, -- Prey: Zadu, Fist of Nalorakk (Nightmare)
    91227, -- Prey: Jo'zolo the Breaker (Nightmare)
    91225, -- Prey: Nexus-Edge Hadim (Nightmare)
    91223, -- Prey: Phaseblade Talasha (Nightmare)
    91221, -- Prey: Deliah Gloomsong (Nightmare)
    91219, -- Prey: Mordril Shadowfell (Nightmare)
    91217, -- Prey: L-N-0R the Recycler (Nightmare)
    91215, -- Prey: Senior Tinker Ozwold (Nightmare)
    91213, -- Prey: Magistrix Emberlash (Nightmare)
    91211, -- Prey: Magister Sunbreaker (Nightmare)
}
