local _, ns = ...

if (GetLocale() ~= "zhCN") then return end
--
-- common
ns.L                                  = {}
ns.L["DRT_ADDON_NAME"]                = "地下堡记录"
ns.L["SAVE"]                          = "保存"
ns.L["DELETE"]                        = "删除"
ns.L["OPERATION"]                     = "操作"
ns.L["DRT_RECORDS"]                   = "完成记录"
ns.L["DRT_ADD_RECORD"]                = "添加记录"
ns.L["DRT_SETTING"]                   = "设置"
ns.L["SAVE_SUCCESS"]                  = "|cFF7DDA58保存成功!|r"
ns.L["VISIBLE"]                       = "|cFF7DDA58显示|r"
ns.L["IN_VISIBLE"]                    = "|cFFE4080A不显示|r"

-- records
ns.L["BOUNTY_MAP_IN_BAG"]             = "背包中"
ns.L["BOUNTY_MAP_USED"]               = "已使用"
ns.L["COMPLETE_THE_TOTAL"]            = "完成总数"
ns.L["BOUNTIFUL"]                     = "可用丰裕"

-- add record
ns.L["AR_PLAYER_NAME"]                = "角色名称"
ns.L["AR_DELVE_NAME"]                 = "地下堡名称"
ns.L["AR_DELVE_TIER"]                 = "层数"
ns.L["AR_SELECT_PLAYER"]              = "选择角色"
ns.L["SELECT_PLAYER_AND_DELVE_FIRST"] = "|cFFE4080A请先选择角色与地下堡信息|r"
ns.L["AR_DELVE_RECORED"]              = "地下堡记录"

-- setting
ns.L["RESET_RECORD"]                  = "重置记录(每周更新后)"
ns.L["RESET_RECORD_CONFIRM"]          = "是否重置地下堡记录"
ns.L["LAST_SELECTED_DELVES_TIER"]     = "最近一次选择的地下堡层数"
ns.L["PLAYER_STTING"]                 = "角色配置"
ns.L["PLAYER_NAME"]                   = "角色名称"
ns.L["PLAYER_VISIBLE"]                = "是否显示角色"
ns.L["PLAYER_SORT"]                   = "角色排序"
ns.L["PLAYER_DELETE"]                 = "删除角色"
ns.L["FRAME_SETTING"]                 = "界面设置(重载界面后生效)"
ns.L["FRAME_WIDTH"]                   = "页面宽度"
