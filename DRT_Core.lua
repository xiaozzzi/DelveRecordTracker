AceGUI = LibStub("AceGUI-3.0")
local isFrameVisible = false
local DRTMainFrame -- 主页面
local DRTTabFrame  -- tab 页面

---检查用户在DB中的下标，如果用户不存在，返回0
---@param unitName stringView 用户名
---@param realm stringView 服务器
---@return integer index 用户所在的下标
local function chekcPlayerDBIndex(unitName, realm)
  local index = 0
  for i, player in pairs(DRT_DB) do
    if player ~= nil and player.unitName == unitName and player.realm == realm then
      index = i
      break
    end
  end
  return index
end

---定义确认对话框（只需定义一次）
---@param message string 提示信息
---@param callback function 回调函数
local function SimpleConfirm(message, callback)
  local dialog = StaticPopup_Show("DRT_SIMPLE_CONFIRM")
  if not dialog then
    StaticPopupDialogs["DRT_SIMPLE_CONFIRM"] = {
      text = message,
      button1 = "确定",
      button2 = "取消",
      OnAccept = callback,
      timeout = 0,
      whileDead = true,
      hideOnEscape = true,
    }
    dialog = StaticPopup_Show("DRT_SIMPLE_CONFIRM")
  else
    dialog.text:SetText(message)
    dialog.data = callback
  end
end

local isDbug = false

---输出日志, 通过 /drt debug 开启, 通过 /drt nodebug 关闭
---@param msg string 日志
---@param level string 级别 ERROR|DEBUG, 默认为DEBUG
local function debug(msg, level)
  if isDbug then
    if (level == 'ERROR') then
      print(format('DRT |cFFD20103[%s]: %s|r', level, msg))
    else
      print(format('DRT: %s', msg))
    end
  end
end

--#region 地下堡记录

-------------------------------------------------------------------------------------------------------------
-- 地下堡记录
-------------------------------------------------------------------------------------------------------------
---绘制地下堡记录
local function DrawDelveRecord(container)
  debug('绘制记录页面 => DrawDelveRecord')
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

  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]

    if player.show ~= nil and player.show == 'SHOW' then
      -- 角色名称
      -- local playerText = format("|c%s%s |r\n|cFF8B8989%s|r\n\n",
      --   C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
      --   player.unitName,
      --   player.unitGUID or "未知ID"
      -- )

      local playerText = format("|c%s%s |r\n\n",
        C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
        player.unitName
      )

      -- 记录
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
          -- recordText = recordText .. format("|cFFFFD100%s. %s(%s)|r\n", j, item.zone, item.tier)
          recordText = recordText .. format("|cFFFFD100%s - %s|r\n", item.tier, item.zone)
        elseif tonumber(item.tier) < 8 then
          -- recordText = recordText .. format("|cFF8B8989%s. %s(%s)|r\n", j, item.zone, item.tier)
          recordText = recordText .. format("|cFF8B8989%s - %s|r\n", item.tier, item.zone)
        else
          -- recordText = recordText .. format("%s. %s(%s)\n", j, item.zone, item.tier)
          recordText = recordText .. format("%s - %s\n", item.tier, item.zone)
        end
        if j == 2 or j == 4 then
          recordText = recordText .. '\n'
        end
      end

      local label = AceGUI:Create("Label")
      label:SetText(playerText .. recordText)
      label:SetFont(ChatFontNormal:GetFont())
      label:SetWidth(200)
      label:SetHeight(210);
      scroll:AddChild(label)
    end
  end
end

--#endregion

--#region 设置页面

-------------------------------------------------------------------------------------------------------------
-- 设置
-------------------------------------------------------------------------------------------------------------
local function resetRecord()
  debug('周长重置, 地下堡记录清空 => resetRecord')
  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]
    player.record = {}
    DRT_DB[i] = player
  end
end

local function resetPlayer()
  debug('周长重置, 地下堡记录清空 => resetPlayer')
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

  if isDbug then
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

    local initTestBtn = AceGUI:Create("Button")
    initTestBtn:SetText("测试数据")
    initTestBtn:SetWidth(100)
    initTestBtn:SetCallback("OnClick", function()
      SimpleConfirm("是否创建测试数据, 原数据将被删除", function()
        InitTestData()
      end)
    end)
    scroll:AddChild(initTestBtn)
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

  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]

    GuiCreateChatLabel(scroll, format("|c%s%s - %s|r\n\n",
      C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
      player.unitName,
      player.realm
    ), 250, "LEFT")

    -- 显示下拉列表
    local showDropdown = AceGUI:Create("Dropdown")
    showDropdown:SetList({ ['SHOW'] = "|cFF7DDA58显示|r", ['HIDE'] = "|cFFE4080A不显示|r" })
    showDropdown:SetValue(player.show)
    showDropdown:SetWidth(130)
    showDropdown:SetCallback("OnValueChanged", function(a, b, key)
      debug("修改了角色显示开关:", player.unitName, key)
      local index = chekcPlayerDBIndex(player.unitName, player.realm)
      player = DRT_DB[index]
      player.show = key
      DRT_DB[i] = player
    end)
    scroll:AddChild(showDropdown)
    GuiCreateSpacing(scroll, 20)

    -- 排序文本框
    local sortText = AceGUI:Create("EditBox")
    sortText:SetText(player.sort)
    sortText:SetWidth(100)
    sortText:SetCallback("OnEnterPressed", function(a, b, sort)
      debug("修改了角色排序:", player.unitName, sort)
      local index = chekcPlayerDBIndex(player.unitName, player.realm)
      player = DRT_DB[index]
      player.sort = sort
      DRT_DB[i] = player
    end)
    scroll:AddChild(sortText)
    GuiCreateSpacing(scroll, 20)

    -- 删除按钮
    local deleteButton = AceGUI:Create("Button")
    deleteButton:SetText("删除")
    deleteButton:SetWidth(100)
    deleteButton:SetCallback("OnClick", function()
      local index = chekcPlayerDBIndex(player.unitName, player.realm)
      table.remove(DRT_DB, index)
      deleteButton:SetDisabled(true)
    end)
    scroll:AddChild(deleteButton)
    GuiCreateEmptyLine(scroll, 1) --创建空行
  end
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
    elseif group == "setting" then
      DrawDelveSetting(container)
    end
  end

  if DRTMainFrame then
    DRTMainFrame:Show()
    DRTTabFrame:SelectTab("record")
  else
    debug('插件初始化页面 => DRTMainFrame is nil and showUI')
    -- 创建主页面
    DRTMainFrame = AceGUI:Create("Frame")
    DRTMainFrame:EnableResize(false) -- 不允许改变窗口大小
    DRTMainFrame:SetTitle("地下堡记录")
    DRTMainFrame:SetStatusText("Delve Record Tracker - v11.1")
    DRTMainFrame:SetCallback("OnClose", function(widget)
      isFrameVisible = false
    end)
    DRTMainFrame:SetWidth(1100)
    DRTMainFrame:SetHeight(580)
    DRTMainFrame:SetLayout("Fill")

    DRTTabFrame = AceGUI:Create("TabGroup")
    DRTTabFrame:SetLayout("Flow")
    DRTTabFrame:SetTabs({ { text = "完成记录", value = "record" }, { text = "设置", value = "setting" } })
    DRTTabFrame:SetCallback("OnGroupSelected", SelectGroup)
    DRTTabFrame:SelectTab("record")

    DRTMainFrame:AddChild(DRTTabFrame)

    -- 设置全局变量, 允许按下 esc 时关闭页面
    _G["DRTGlobalFrame"] = DRTMainFrame.frame
    tinsert(UISpecialFrames, "DRTGlobalFrame")
  end
end

local DRTFrame = CreateFrame("Frame", "DRTFrame", UIParent, "DialogBoxFrame")
DRTFrame:RegisterEvent("ADDON_LOADED")
DRTFrame:RegisterEvent("SCENARIO_UPDATE")
DRTFrame:SetSize(0, 0)
DRTFrame:Hide()

-------------------------------------------------------------------------------------------------------------
-- 处理事件
-------------------------------------------------------------------------------------------------------------

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
    debug("未获取到地下堡层数", "ERROR")
  end

  local unitName, realm = UnitFullName("player")
  local unitGUID = UnitGUID("player")
  local className, classFilename, classId = UnitClass("player")
  local index = chekcPlayerDBIndex(unitName, realm)
  -- 用户不存在, 新增用户信息及本次地下堡记录
  if index == 0 then
    debug(format('地下堡 [%s-%s] 已完成, 新增用户 %s-%s', delveZone, delveTier, unitName, realm))
    table.insert(
      DRT_DB,
      {
        sort = "50",
        show = "SHOW",
        unitGUID = unitGUID,
        unitName = unitName,
        realm = realm,
        classFilename = classFilename,
        record = { { zone = delveZone, tier = delveTier } },
      }
    )
  else
    debug(format('%s-%s 已完成 [%s-%s]', unitName, realm, delveZone, delveTier))
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
    if DRT_CONFIG_DB == nil then
      DRT_CONFIG_DB = {}
    end
    DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER'] = C_CVar.GetCVar('lastSelectedDelvesTier')
    debug(format('Wellcome Delve Record Tracker, %s [%s]', UnitName("player"), UnitGUID("player")))
  elseif event == "SCENARIO_UPDATE" then
    -- =========================================================== --
    -- 当进入一个 Delve 时，加载 SCENARIO 更新事件来监听一个完成的 Delve  --
    -- =========================================================== --
    if C_PartyInfo.IsDelveInProgress() == true then
      self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
      DRT_CONFIG_DB['LAST_SELECTED_DELVES_TIER'] = C_CVar.GetCVar('lastSelectedDelvesTier')
    end
  elseif event == "SCENARIO_CRITERIA_UPDATE" then
    local delveZone = GetZoneText()
    -- =========================================================== --
    -- 监听 delve 完成并持久化 --
    -- =========================================================== --
    if C_PartyInfo.IsDelveComplete() == true and delveZone ~= "Zekvir's Lair" and delveZone ~= "Underpin's Demolition Competition" then
      self:UnregisterEvent("SCENARIO_CRITERIA_UPDATE")
      delveCompleteHandle(delveZone)
    end
  end
end)

-- 命令开启
SLASH_DRT1 = "/drt"
SlashCmdList["DRT"] = function(arg1)
  if arg1 == "nodebug" then
    isDbug = false
  elseif arg1 == "debug" then
    isDbug = true
  end
  if not isFrameVisible then
    showUI()
    isFrameVisible = true
  end
end
