local drtFrame = CreateFrame("Frame", "drtFrame", UIParent, "DialogBoxFrame")
-- local drtFrame = CreateFrame("Frame", "drtFrame", UIParent, "PortraitFrameTemplate")

drtFrame:RegisterEvent("ADDON_LOADED")
drtFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
drtFrame:RegisterEvent("SCENARIO_UPDATE")

drtFrame:SetPoint("CENTER")
drtFrame:SetSize(300, 200)
drtFrame:SetMovable(true)
drtFrame:EnableMouse(true)
drtFrame:RegisterForDrag("LeftButton")
drtFrame:SetScript("OnDragStart", drtFrame.StartMoving)
drtFrame:SetScript("OnDragStop", drtFrame.StopMovingOrSizing)
drtFrame:Hide()

local resetButton = CreateFrame('Button', "Frame", drtFrame, "UIPanelButtonTemplate")
resetButton:SetSize(60, 30)
resetButton:SetPoint("TOPLEFT", drtFrame, 15, 10)
resetButton:SetText("重置")

---检查用户在DB中的下标，如果用户不存在，返回0
---@param unitName stringView 用户名
---@param realm stringView 服务器
---@return integer index 用户所在的下标
local function chekcPlayerDBIndex(unitName, realm)
  local index = 0
  for i, v in pairs(DRT_DB) do
    if v ~= nil and v.unitName == unitName and v.realm == realm then
      index = i
      break
    end
  end
  return index
end

local function initTestData()
  print('DT: 初始化地下堡测试数据')
  DRT_DB = {}
  local tb1 = {}
  tb1[1] = { zone = '九号挖掘场', tier = 11 }
  tb1[2] = { zone = '塔克-雷桑深渊', tier = 8 }
  tb1[3] = { zone = '克莱格瓦之眠', tier = 8 }
  tb1[4] = { zone = '闸板陋巷', tier = 2 }
  tb1[5] = { zone = '幽暗要塞', tier = 11 }
  tb1[6] = { zone = '地铺矿洞', tier = 5 }
  tb1[7] = { zone = '地铺矿洞', tier = 11 }
  tb1[8] = { zone = '地铺矿洞', tier = 4 }
  tb1[9] = { zone = '地铺矿洞', tier = 4 }
  tb1[10] = { zone = '地铺矿洞', tier = 4 }
  tb1[11] = { zone = '地铺矿洞', tier = 4 }
  tb1[12] = { zone = '地铺矿洞', tier = 4 }
  tb1[13] = { zone = '地铺矿洞', tier = 4 }

  for i = 1, 1 do
    table.insert(DRT_DB, { unitName = "张三", classFilename = "HUNTER", realm = "贫瘠之地", record = tb1 })
  end

  -- local tb2 = {}
  -- tb2[1] = { zone = '九号挖掘场', tier = 11 }
  -- tb2[2] = { zone = '塔克-雷桑深渊', tier = 8 }
  -- tb2[3] = { zone = '克莱格瓦之眠', tier = 8 }
  -- tb2[4] = { zone = '闸板陋巷', tier = 2 }
  -- tb2[5] = { zone = '幽暗要塞', tier = 11 }
  -- tb2[6] = { zone = '地铺矿洞', tier = 5 }
  -- tb2[7] = { zone = '地铺矿洞', tier = 11 }
  -- tb2[8] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[9] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[10] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[11] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[12] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[13] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[14] = { zone = '地铺矿洞', tier = 4 }
  -- tb2[15] = { zone = '地铺矿洞', tier = 4 }
  -- table.insert(DRT_DB, { unitName = "张三", classFilename = "HUNTER", realm = "贫瘠之地", record = tb2 })

  -- for i = 1, 9 do
  --   table.insert(DRT_DB, { unitName = "张三", classFilename = "HUNTER", realm = "贫瘠之地", record = tb1 })
  -- end

  -- local zs = DRT_DB['张三']
  -- if zs ~= nil then
  --   table.insert(DRT_DB, { unitName = "张三", classFilename = "HUNTER", record = tb1 })
  -- end
  -- local ls = DRT_DB['李四']
  -- if ls ~= nil or ls ~= {} then
  --   table.insert(DRT_DB, { unitName = "李四", classFilename = "MAGE", record = tb1 })
  -- end
end

local function initDB()
  if DRT_DB == nil then
    DRT_DB = {}
  end
  -- initTestData()
end

local function resetDelveDB()
  print('DT: 周长重置, 地下堡记录清空')
  DRT_DB = {}
  C_UI.Reload()
end

---显示所有信息
local function showAll()
  local totalWidth = 0  -- 页面总宽度
  local totalHeight = 0 -- 页面总高度

  for i = 1, #(DRT_DB) do
    local player = DRT_DB[i]

    local col = (i - 1) % 5             -- 列, 从0开始
    local row = math.floor((i - 1) / 5) -- 行, 从0开始

    local titleX = col * 200 + 20       -- 用户名的X位置
    local titleY = -30 - (row * 200)    -- 用户名的Y位置

    -- 玩家名称 text
    local titleText = drtFrame:CreateFontString(nil, "OVERLAY");
    titleText:SetFont("fonts/arhei.ttf", 16, "OUTLINE")
    titleText:SetPoint("TOPLEFT", drtFrame, "TOPLEFT", titleX, titleY)
    titleText:SetText(format("|c%s%s|r\n\n",
      C_ClassColor.GetClassColor(player.classFilename):GenerateHexColor(),
      player.unitName
    ))

    -- 记录 text
    local recordText = drtFrame:CreateFontString(nil, "OVERLAY")
    recordText:SetFont("fonts/arhei.ttf", 14, "OUTLINE")
    recordText:SetPoint("TOPLEFT", titleText, "TOPLEFT", 0, -30)

    local text = ""
    for j = 1, #(player.record) do
      -- 如果地下堡次数大于 8 次，隐藏多的次数，改为 tooltip 显示
      if j > 8 then
        text = text .. '....'
        break
      end
      local item = player.record[j]
      -- 11层与小于8层的地下堡颜色特殊标识
      if tonumber(item.tier) == 11 then
        text = text .. format("|cFFFFD100%s、%s(%s)|r\n", j, item.zone, item.tier)
      elseif tonumber(item.tier) < 8 then
        text = text .. format("|cFF8B8989%s、%s(%s)|r\n", j, item.zone, item.tier)
      else
        text = text .. format("%s、%s(%s)\n", j, item.zone, item.tier)
      end
      if j == 2 or j == 4 then
        text = text .. '\n'
      end
    end

    if col == 0 then
      totalHeight = totalHeight + 200
    end

    recordText:SetText(text)
    recordText:SetJustifyH('LEFT')
  end

  -- 计算页面总宽度
  if DRT_DB ~= nil then
    totalWidth = math.min(200 * #(DRT_DB), 1000)
  end

  drtFrame:SetSize(math.max(totalWidth, 200), math.max(totalHeight + 90, 200))
  drtFrame:Show()
end

drtFrame:SetScript("OnEvent", function(self, event, unit, ...)
  ------------EVENTS---------------
  if event == "ADDON_LOADED" and unit == "DelveRecordTracker" then
    if C_CVar.GetCVar('lastSelectedDelvesTier') > C_CVar.GetCVar('highestUnlockedDelvesTier') then
      C_CVar.SetCVar('lastSelectedDelvesTier', 0)
    end
    print('DT: Wellcome Devel Record Tracker, ' .. UnitName("player"))
    initDB()
  elseif event == "SCENARIO_UPDATE" then
    -- =========================================================== --
    -- 当进入一个 Delve 时，加载 SCENARIO 更新事件来监听一个完成的 Delve  --
    -- =========================================================== --
    if C_PartyInfo.IsDelveInProgress() == true then
      self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
    end
  elseif event == "SCENARIO_CRITERIA_UPDATE" then
    local delveZone = GetZoneText()
    -- =========================================================== --
    -- 监听 delve 完成并持久化 --
    -- =========================================================== --
    if C_PartyInfo.IsDelveComplete() == true and delveZone ~= "Zekvir's Lair" and delveZone ~= "Underpin's Demolition Competition" then
      self:UnregisterEvent("SCENARIO_CRITERIA_UPDATE")
      local delveTier = C_CVar.GetCVar('lastSelectedDelvesTier') -- 地下堡层数
      local unitName, realm = UnitFullName("player")
      local className, classFilename, classId = UnitClass("player")
      local index = chekcPlayerDBIndex(unitName, realm)
      -- 用户不存在, 新增用户信息及本次地下堡记录
      if index == 0 then
        print('DT: 本周第一次地下堡已完成!')
        table.insert(
          DRT_DB,
          {
            unitName = unitName,
            realm = realm,
            classFilename = classFilename,
            record = { { zone = delveZone, tier = delveTier } },
          }
        )
      else
        print('DT: 地下堡已完成!')
        -- 用户存在, 新增本次地下堡记录
        local record = DRT_DB[index]["record"]
        table.insert(record, { zone = delveZone, tier = delveTier })
        DRT_DB[index] = {
          unitName = unitName,
          realm = realm,
          classFilename = classFilename,
          record = record
        }
      end
    end
    --When the Vault UI is opened, hook the tooltip display function to the World activity Vault tiles
  elseif event == "WEEKLY_REWARDS_UPDATE" then
    -- resetDelveDB()
  end
end)

resetButton:SetScript('OnClick', function()
  resetDelveDB()
  showAll()
end
)


SLASH_DRT1 = "/drt"

SlashCmdList["DRT"] = function(msg, editBox)
  -- for _, delvinRun in ipairs(DRT_DB) do
  --   print(delvinRun.player .. "-" .. delvinRun.zone .. "-" .. delvinRun.tier .. "-" .. delvinRun.duration)
  -- end
  showAll()
end
