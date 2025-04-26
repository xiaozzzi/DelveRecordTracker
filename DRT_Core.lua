DRT_UTIL = DRT_UTIL or {}

if not DRT_ICON_DB then
  DRT_ICON_DB = {
    minimapPos = 140,
    hide = false,
  }
end

AceGUI = LibStub("AceGUI-3.0")
local isMainFrameVisible = false
local DRTMainFrame -- 主页面
local DRTTabFrame  -- tab 页面

---检查用户在DB中的下标，如果用户不存在，返回0
---@param unitGUID stringView 用户ID
---@return integer index 用户所在的下标
local function checkPlayerDBIndex(unitGUID)
  local index = 0
  for i, player in pairs(DRT_DB) do
    if player ~= nil and player.unitGUID == unitGUID then
      index = i
      break
    end
  end
  return index
end

--- 修改DB中某个值
---@param unitGUID any 角色ID
---@param key string 剑
---@param value any 值
---@return boolean 是-修改成功/否-修改失败
local function modifyDB(unitGUID, key, value)
  local index = checkPlayerDBIndex(unitGUID)
  if index == 0 then
    return false
  end
  local player = DRT_DB[index]
  player[key] = value
  DRT_DB[index] = player
  return true
end

---检查用户的藏宝图数量
---@return string "NOT_OBTAINED/BAG/USED"
local function checkBountyMap(unitGUID)
  if unitGUID == nil then
    unitGUID = UnitGUID("player")
  end

  local bountyMapStatus = "NOT_OBTAINED"
  -- 检查是否完拾取了本周的地下堡丰裕宝图
  local completedDelveBountyMap = IsCompletedDelveBountyMap()

  if completedDelveBountyMap then
    -- 检查丰裕宝图是否在背包或仓库中
    local bountyMapCount = GetItemCountFromAll(233071)
    if bountyMapCount > 0 then
      bountyMapStatus = "BAG"
    elseif bountyMapCount == 0 then
      bountyMapStatus = "USED"
    end
  end

  modifyDB(unitGUID, "bountyMapStatus", bountyMapStatus)

  -- DRT_Log:debug(format("DRT: 已完成藏宝图: %s, 藏宝图数: %s", tostring(completedDelveBountyMap), C_Item.GetItemCount(233071, true, false)))

  return bountyMapStatus
end

--#region 地下堡记录

-------------------------------------------------------------------------------------------------------------
-- 地下堡记录
-------------------------------------------------------------------------------------------------------------
---绘制地下堡记录
local function DrawDelveRecord(container)
  DRT_Log:debug('绘制记录页面 => DrawDelveRecord')
  GuiCreateEmptyLine(container, 2)                     --创建空行

  local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  scrollcontainer:SetFullWidth(true)                   -- 最大宽度
  scrollcontainer:SetFullHeight(true)                  -- 最大高度
  scrollcontainer:SetLayout("Fill")                    -- important!
  container:AddChild(scrollcontainer)

  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("Flow")
  scrollcontainer:AddChild(scroll)

  table.sort(DRT_DB, function(a, b) return tonumber(a.sort) < tonumber(b.sort) end)
  local unitGUID = UnitGUID("player")

  local thisWeekCount = 0

  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]
    thisWeekCount = thisWeekCount + #(player.record)

    if player.show ~= nil and player.show == 'SHOW' then
      -- player metadata
      local playerText = format("|c%s%s|r",
        C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
        player.unitName
      )

      local bountyMapText, bountyMapStatus

      if unitGUID == player.unitGUID then
        bountyMapStatus = checkBountyMap(unitGUID)
      else
        bountyMapStatus = player.bountyMapStatus or "NOT_OBTAINED"
      end

      if bountyMapStatus == "NOT_OBTAINED" then
        -- bountyMapText = " |cFF8B8989[未拾取 |TInterface\\Icons\\Icon_treasuremap:0|t]|r\n"
        bountyMapText = "\n"
      elseif bountyMapStatus == "BAG" then
        bountyMapText = " |cFFFFD100[背包中 |TInterface\\Icons\\Icon_treasuremap:0|t]|r\n"
      elseif bountyMapStatus == "USED" then
        bountyMapText = " |cFF7DDA58[已使用 |TInterface\\Icons\\Icon_treasuremap:0|t]|r\n"
      end

      if DRT_Log.isDebug then
        playerText = playerText .. bountyMapText .. player.unitGUID .. ""
      else
        playerText = playerText .. bountyMapText
      end

      -- records
      local recordText = ""
      table.sort(player.record, function(a, b) return tonumber(a.tier) > tonumber(b.tier) end)
      for j = 1, #(player.record) do
        -- 如果地下堡次数大于 8 次，隐藏多的次数
        if j > 8 then
          recordText = recordText .. '....'
          break
        end
        local item = player.record[j]
        -- 11层与小于8层的地下堡颜色特殊标识
        if tonumber(item.tier) == 11 then
          recordText = recordText .. format("|cFFFFD100%s - %s|r\n", item.tier, item.zone)
        elseif tonumber(item.tier) < 8 then
          recordText = recordText .. format("|cFF8B8989%s - %s|r\n", item.tier, item.zone)
        else
          recordText = recordText .. format("%s - %s\n", item.tier, item.zone)
        end
        if j == 2 or j == 4 then
          recordText = recordText .. '\n'
        end
      end

      local label = AceGUI:Create("Label")
      label:SetText(playerText .. "\n" .. recordText)
      label:SetFont(ChatFontNormal:GetFont())
      label:SetWidth(200)
      label:SetHeight(210);
      scroll:AddChild(label)
    end
  end

  DRTMainFrame:SetStatusText(format('本周完成总数: %s   可用丰裕: %s',
    GetColorText("FFFFFF", thisWeekCount),
    GetColorText("FFFFFF", GetBountifulDelves())
  ))
end

--#endregion

--#region 手动添加地下堡记录

--- add record
---@param container any parent container
local function addRecord(container)
  local settingContainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  settingContainer:SetFullWidth(true)                   -- 最大宽度
  settingContainer:SetFullHeight(true)                  -- 最大高度
  settingContainer:SetLayout("Fill")                    -- important!
  container:AddChild(settingContainer)

  -- 提前定义记录列表
  local innerGroup = AceGUI:Create("InlineGroup")
  innerGroup:SetFullWidth(true)
  innerGroup:SetLayout("Flow")

  local saveResult = AceGUI:Create("Label")
  saveResult:SetFont(ChatFontNormal:GetFont())
  saveResult:SetFullWidth(true)
  saveResult:SetJustifyH("CENTER")

  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("Flow")
  settingContainer:AddChild(scroll)

  GuiCreateEmptyLine(scroll, 2)
  GuiCreateChatLabel(scroll, "如遇到高达掉线等非正常退出情况, 可能无法正确保存地下堡记录, 可手动添加.", 800, "LEFT")
  GuiCreateEmptyLine(scroll, 5)

  GuiCreateChatLabel(scroll, "", 200, "LEFT")
  GuiCreateChatLabel(scroll, "角色名称", 210, "LEFT")
  GuiCreateChatLabel(scroll, "地下堡名称", 165, "LEFT")
  GuiCreateChatLabel(scroll, "层数", 170, "LEFT")

  GuiCreateEmptyLine(scroll, 2)

  GuiCreateChatLabel(scroll, "选择角色: ", 100, "LEFT")

  local playerList = {}

  for key, player in pairs(DRT_DB) do
    playerList[player.unitGUID] = format("|c%s%s-%s|r",
      C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
      player.unitName, player.realm)
  end

  local function DrawDelveRecordInnerGroup(unitGUID)
    if innerGroup then
      innerGroup:ReleaseChildren()
    end
    local index = checkPlayerDBIndex(unitGUID)
    for i, record in pairs(DRT_DB[index].record) do
      if tonumber(record.tier) == 11 then
        GuiCreateChatLabel(innerGroup, format("|cFFFFD100%s - %s|r", record.tier, record.zone), 170, "LEFT")
      elseif tonumber(record.tier) < 8 then
        GuiCreateChatLabel(innerGroup, format("|cFF8B8989%s - %s|r", record.tier, record.zone), 170, "LEFT")
      else
        GuiCreateChatLabel(innerGroup, format("%s - %s", record.tier, record.zone), 170, "LEFT")
      end
      -- 删除某条记录
      local delBtn = AceGUI:Create("Button")
      delBtn:SetText("删除")
      delBtn:SetWidth(70)
      delBtn:SetCallback("OnClick", function()
        local player = DRT_DB[index]
        table.remove(player.record, i)
        delBtn:SetDisabled(true)
        DrawDelveRecordInnerGroup(unitGUID)
      end)
      innerGroup:AddChild(delBtn)
      if i % 2 == 1 then
        GuiCreateSpacing(innerGroup, 60)
      elseif i % 2 == 0 then
        GuiCreateEmptyLine(innerGroup, 1)
      end
    end
  end

  local selectPlayer = {}

  local playerDropdown = AceGUI:Create("Dropdown")
  playerDropdown:SetList(playerList)
  playerDropdown:SetWidth(240)
  playerDropdown:SetCallback("OnValueChanged", function(a, b, unitGUID)
    DRT_Log:debug(format("选择了角色: %s ", unitGUID, unitGUID))
    selectPlayer.unitGUID = unitGUID
    DrawDelveRecordInnerGroup(unitGUID)
  end)
  scroll:AddChild(playerDropdown)

  GuiCreateSpacing(scroll, 20)

  local delveList = {}
  for _, mapId in pairs(DRT_DELVES_ID) do
    local delve = C_Map.GetMapInfo(mapId)
    if delve ~= nil then
      delveList[delve.name] = delve.name
    end
  end

  local delveDropdown = AceGUI:Create("Dropdown")
  delveDropdown:SetList(delveList)
  delveDropdown:SetWidth(170)
  delveDropdown:SetCallback("OnValueChanged", function(a, b, zone)
    DRT_Log:debug(format("选择了地下堡: %s ", zone))
    selectPlayer.zone = zone
  end)
  scroll:AddChild(delveDropdown)

  GuiCreateSpacing(scroll, 20)

  local tierDropdown = AceGUI:Create("Dropdown")
  tierDropdown:SetList(DRT_DELVE_TIERS)
  tierDropdown:SetWidth(80)
  tierDropdown:SetCallback("OnValueChanged", function(a, b, tier)
    DRT_Log:debug(format("选择了层数: %s ", tier))
    selectPlayer.tier = tier
  end)
  scroll:AddChild(tierDropdown)

  GuiCreateSpacing(scroll, 20)

  local saveButton = AceGUI:Create("Button")
  saveButton:SetText("保存")
  saveButton:SetWidth(100)
  saveButton:SetCallback("OnClick", function()
    if selectPlayer.unitGUID == nil or selectPlayer.zone == nil or selectPlayer.tier == nil or
        #(selectPlayer.unitGUID) == 0 or #(selectPlayer.zone) == 0
    then
      saveResult:SetText("|cFFE4080A请先选择角色与地下堡信息|r")
    else
      local index = checkPlayerDBIndex(selectPlayer.unitGUID)
      table.insert(DRT_DB[index].record, { zone = selectPlayer.zone, tier = selectPlayer.tier })
      DrawDelveRecordInnerGroup(selectPlayer.unitGUID)
      saveResult:SetText("|cFF7DDA58保存成功!|r")
    end
  end)
  scroll:AddChild(saveButton)

  GuiCreateEmptyLine(scroll, 2)

  scroll:AddChildren(saveResult)

  GuiCreateEmptyLine(scroll, 5)
  ---------------------------------------------------------
  local settingHead = AceGUI:Create("Heading")
  settingHead:SetText("记录列表")
  settingHead:SetFullWidth(true)
  scroll:AddChild(settingHead)
  scroll:AddChild(innerGroup)
end

--#endregion

--#region 设置页面

-------------------------------------------------------------------------------------------------------------
-- 设置
-------------------------------------------------------------------------------------------------------------
local function resetRecord()
  DRT_Log:debug('周长重置, 地下堡记录清空 => resetRecord')
  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]
    player.bountyMapStatus = "NOT_OBTAINED"
    player.record = {}
    DRT_DB[i] = player
  end
end

local function resetPlayer()
  DRT_Log:debug('周长重置, 地下堡记录清空 => resetPlayer')
  DRT_DB = {}
end

--- 绘制设置页面
--- @param container
local function DrawDelveSetting(container)
  local settingContainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
  settingContainer:SetFullWidth(true)                   -- 最大宽度
  settingContainer:SetFullHeight(true)                  -- 最大高度
  settingContainer:SetLayout("Fill")                    -- important!
  container:AddChild(settingContainer)

  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("Flow") -- probably?
  settingContainer:AddChild(scroll)

  local settingHead = AceGUI:Create("Heading")
  settingHead:SetText("操作")
  settingHead:SetFullWidth(true)
  scroll:AddChild(settingHead)

  GuiCreateEmptyLine(scroll, 2) --创建空行

  local resetBtn = AceGUI:Create("Button")
  resetBtn:SetText("重置记录(每周更新后)")
  resetBtn:SetWidth(200)
  resetBtn:SetCallback("OnClick", function()
    SimpleConfirm("是否重置地下堡记录", function()
      resetRecord()
    end)
  end)
  scroll:AddChild(resetBtn)

  GuiCreateSpacing(scroll, 500)

  if DRT_Log.isDebug then
    local resetBtn = AceGUI:Create("Button")
    resetBtn:SetText("清空数据")
    resetBtn:SetWidth(100)
    resetBtn:SetCallback("OnClick", function()
      SimpleConfirm("是否清空用户数据", function()
        resetPlayer()
      end)
    end)
    scroll:AddChild(resetBtn)

    GuiCreateSpacing(scroll, 20)
  end

  GuiCreateEmptyLine(scroll, 2)
  GuiCreateChatLabel(scroll, format('最近一次选择的地下堡层数: %s', DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER']), 280, "LEFT")
  GuiCreateEmptyLine(scroll, 10)

  --------------------------------------------------
  -- 角色列表
  --------------------------------------------------
  local settingPlayer = AceGUI:Create("Heading")
  settingPlayer:SetText("角色配置")
  settingPlayer:SetFullWidth(true)
  scroll:AddChild(settingPlayer)

  GuiCreateEmptyLine(scroll, 2)
  GuiCreateChatLabel(scroll, GetColorText("FFFFFF", "角色"), 280, "LEFT")
  GuiCreateChatLabel(scroll, GetColorText("FFFFFF", "是否显示角色"), 140, "CENTER")
  GuiCreateChatLabel(scroll, GetColorText("FFFFFF", "角色排序"), 120, "CENTER")
  GuiCreateChatLabel(scroll, GetColorText("FFFFFF", "删除角色"), 120, "CENTER")
  GuiCreateEmptyLine(scroll, 2)

  -- 角色列表
  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]

    local name = GuiCreateChatLabel(scroll, format("|c%s%s - %s|r\n\n",
      C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
      player.unitName,
      player.realm
    ), 250, "LEFT")
    name:SetHeight(10)

    -- 显示下拉列表
    local showDropdown = AceGUI:Create("Dropdown")
    showDropdown:SetList({ ['SHOW'] = "|cFF7DDA58显示|r", ['HIDE'] = "|cFFE4080A不显示|r" })
    showDropdown:SetValue(player.show)
    showDropdown:SetWidth(130)
    showDropdown:SetCallback("OnValueChanged", function(a, b, key)
      DRT_Log:debug(format("修改了角色显示开关: %s => %s ", player.unitName, key))
      modifyDB(player.unitGUID, "show", key)
    end)
    scroll:AddChild(showDropdown)
    GuiCreateSpacing(scroll, 20)

    -- 排序文本框
    local sortText = AceGUI:Create("EditBox")
    sortText:SetText(player.sort)
    sortText:SetWidth(100)
    sortText:SetCallback("OnEnterPressed", function(a, b, sort)
      DRT_Log:debug(format("修改了排序：%s => %s ", player.unitName, sort))
      modifyDB(player.unitGUID, "sort", sort)
    end)
    scroll:AddChild(sortText)
    GuiCreateSpacing(scroll, 20)

    -- 删除按钮
    local deleteButton = AceGUI:Create("Button")
    deleteButton:SetText("删除")
    deleteButton:SetWidth(100)
    deleteButton:SetCallback("OnClick", function()
      local index = checkPlayerDBIndex(player.unitGUID)
      table.remove(DRT_DB, index)
      deleteButton:SetDisabled(true)
    end)
    scroll:AddChild(deleteButton)

    GuiCreateEmptyLine(scroll, 1) --创建空行
  end


  --------------------------------------------------
  -- 页面设置
  --------------------------------------------------
  GuiCreateEmptyLine(scroll, 10)
  local settingFrame = AceGUI:Create("Heading")
  settingFrame:SetText("界面设置(重载界面后生效)")
  settingFrame:SetFullWidth(true)
  scroll:AddChild(settingFrame)

  GuiCreateChatLabel(scroll, GetColorText("FFFFFF", "页面宽度: "), 100, "LEFT")

  local mainWidthEdit = AceGUI:Create("EditBox")
  mainWidthEdit:SetText(DRT_CONFIG_DB.mainWidth)
  mainWidthEdit:SetWidth(100)
  mainWidthEdit:SetCallback("OnEnterPressed", function(a, b, mainWidth)
    DRT_CONFIG_DB.mainWidth = mainWidth
  end)
  scroll:AddChild(mainWidthEdit)
  GuiCreateEmptyLine(scroll, 10)
end
--#endregion

--#region 主页面与事件处理

-------------------------------------------------------------------------------------------------------------
-- 主页面初始化
-------------------------------------------------------------------------------------------------------------
local function showUI()
  local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "record" then
      DrawDelveRecord(container)
    elseif group == "addRecord" then
      addRecord(container)
    elseif group == "setting" then
      DrawDelveSetting(container)
    end
  end

  if DRTMainFrame then
    DRTMainFrame:Show()
    DRTTabFrame:SelectTab("record")
  else
    DRT_Log:debug('插件初始化页面 => DRTMainFrame is nil and showUI')
    -- 创建主页面
    DRTMainFrame = AceGUI:Create("Frame")
    DRTMainFrame:EnableResize(false) -- 不允许改变窗口大小
    DRTMainFrame:SetTitle("地下堡记录 " .. DRT_GLOBLE.VERSION)
    DRTMainFrame:SetCallback("OnClose", function(widget)
      isMainFrameVisible = false
    end)
    DRTMainFrame:SetWidth(DRT_CONFIG_DB.mainWidth)
    DRTMainFrame:SetHeight(580)
    DRTMainFrame:SetLayout("Fill")

    DRTTabFrame = AceGUI:Create("TabGroup")
    DRTTabFrame:SetLayout("Flow")
    DRTTabFrame:SetTabs({ { text = "完成记录", value = "record" }, { text = "添加记录", value = "addRecord" }, { text = "设置", value = "setting" } })
    DRTTabFrame:SetCallback("OnGroupSelected", SelectGroup)
    DRTTabFrame:SelectTab("record")

    DRTMainFrame:AddChild(DRTTabFrame)

    -- 设置全局变量, 允许按下 esc 时关闭页面
    _G["DRTGlobalFrame"] = DRTMainFrame.frame
    tinsert(UISpecialFrames, "DRTGlobalFrame")
  end
end

--- show and hide DRTMainFrame
function TriggerFrame()
  if not isMainFrameVisible then
    showUI()
    isMainFrameVisible = true
  else
    DRTMainFrame:Hide()
    isMainFrameVisible = false
  end
end

function DRT_UTIL:ToggleMainFrame()
  TriggerFrame()
end

local DRTFrame = CreateFrame("Frame", "DRTFrame", UIParent, "DialogBoxFrame")
DRTFrame:RegisterEvent("ADDON_LOADED")
DRTFrame:RegisterEvent("BAG_UPDATE_DELAYED")
DRTFrame:RegisterEvent("SCENARIO_UPDATE")          -- 场景战役状态发生变更时触发
DRTFrame:RegisterEvent("SCENARIO_CRITERIA_UPDATE") -- 场景战役目标更新时触发, 例如拾取了物品, 击杀了怪物等
DRTFrame:SetSize(0, 0)
DRTFrame:Hide()

-------------------------------------------------------------------------------------------------------------
-- 处理事件
-------------------------------------------------------------------------------------------------------------
---完成必要的数据初始化和查询
local function addonInitHandle()
  local unitName = UnitFullName("player")
  local unitGUID = UnitGUID("player")
  -- print("========================================")
  -- print(format('DRT: Hello ~ %s [%s]', unitName, unitGUID))
  -- print("========================================")
  -- 初始化数据表
  if DRT_DB == nil then
    DRT_DB = {}
  end
  -- 初始化配置表
  if DRT_CONFIG_DB == nil then
    DRT_CONFIG_DB = {}
  end

  if (DRT_CONFIG_DB.mainWidth == nil) then
    DRT_CONFIG_DB.mainWidth = 1080
  end

  -- 初始化上次选择的地下堡层数
  DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER'] = C_CVar.GetCVar('lastSelectedDelvesTier')
  -- 初始化用户是否获取过本周丰裕地下堡藏宝图
  checkBountyMap(unitGUID)
end

---地下堡完成时保存数据
---@param delveZone string 地下堡名称
local function delveCompleteHandle(delveZone)
  -- 地下堡层数, 如果中途掉线, 可能无法获取到该参数
  local delveTier = C_CVar.GetCVar('lastSelectedDelvesTier')

  if delveTier == nil or tonumber(delveTier) < 1 or tonumber(delveTier) > 11 then
    delveTier = DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER']
  end

  if delveTier == nil or tonumber(delveTier) < 1 or tonumber(delveTier) > 11 then
    delveTier = "未获取层数"
    DRT_Log:error("未获取到地下堡层数")
  end

  local unitName, realm = UnitFullName("player")
  local unitGUID = UnitGUID("player")
  local className, classFilename, classId = UnitClass("player")
  local index = checkPlayerDBIndex(unitGUID)

  -- 用户不存在, 新增用户信息及本次地下堡记录
  if index == 0 then
    DRT_Log:debug(format('地下堡 [%s-%s] 已完成, 新增用户 %s-%s', delveZone, delveTier, unitName, realm))
    table.insert(
      DRT_DB,
      {
        sort = "50",
        show = "SHOW",
        unitGUID = unitGUID,
        unitName = unitName,
        realm = realm,
        classFilename = classFilename,
        bountyMapStatus = checkBountyMap(),
        record = { { zone = delveZone, tier = delveTier } },
      }
    )
  else
    DRT_Log:debug(format('%s-%s 已完成 [%s-%s]', unitName, realm, delveZone, delveTier))
    -- 用户存在, 新增本次地下堡记录
    local player = DRT_DB[index]
    local record = player["record"]
    table.insert(record, { zone = delveZone, tier = delveTier })
    player = {
      sort = player.sort or "50",
      show = player.show or "SHOW",
      unitGUID = unitGUID,
      unitName = unitName,
      realm = realm,
      classFilename = classFilename,
      bountyMapStatus = checkBountyMap(),
      record = record
    }
    DRT_DB[index] = player
  end
end

--#endregion

-------------------------------------------------------------------------------------------------------------
-- 完成
-------------------------------------------------------------------------------------------------------------
DRTFrame:SetScript("OnEvent", function(self, event, unit, ...)
  ------------EVENTS---------------
  if event == "ADDON_LOADED" and unit == "DelveRecordTracker" then
    -- 上次选择的地下堡层数
    if C_CVar.GetCVar('lastSelectedDelvesTier') > C_CVar.GetCVar('highestUnlockedDelvesTier') then
      C_CVar.SetCVar('lastSelectedDelvesTier', 11)
    end
    addonInitHandle()
  elseif event == "BAG_UPDATE_DELAYED" then
    checkBountyMap()
  elseif event == "SCENARIO_UPDATE" then
    -- =========================================================== --
    -- 当进入一个 Delve 时，加载 SCENARIO 更新事件来监听一个完成的 Delve  --
    -- =========================================================== --
    if C_PartyInfo.IsDelveInProgress() == true then
      self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
      -- print('DRT: 触发 SCENARIO_UPDATE')
      DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER'] = C_CVar.GetCVar('lastSelectedDelvesTier')
    end
  elseif event == "SCENARIO_CRITERIA_UPDATE" then
    local delveZone = GetZoneText()
    -- =========================================================== --
    -- 监听 delve 完成并持久化 --
    -- =========================================================== --
    -- print('DRT: 触发 SCENARIO_CRITERIA_UPDATE, 地下堡是否完成: ', C_PartyInfo.IsDelveComplete())
    if C_PartyInfo.IsDelveComplete() == true and delveZone ~= "Zekvir's Lair" and delveZone ~= "Underpin's Demolition Competition" then
      -- 需要注销事件, 防止重复调用
      self:UnregisterEvent("SCENARIO_CRITERIA_UPDATE")
      delveCompleteHandle(delveZone)
    end
  end
end)

-- 命令开启
SLASH_DRT1 = "/drt"
SlashCmdList["DRT"] = function(arg1)
  if arg1 == "nodebug" then
    DRT_Log.isDebug = false
  elseif arg1 == "debug" then
    DRT_Log.isDebug = true
  end
  TriggerFrame()
end
