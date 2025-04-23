---获取指定颜色的文本, 文本以 |cFF 开头, |r 结尾
---@param color string 颜色
---@param text string 内容
---@return string 文本
function GetColorText(color, text)
  return "\124cff" .. color .. text .. "\124r"
end

---在容器中创建空行
---@param container AceGUIWidget 容器
---@param count number 行数
function GuiCreateEmptyLine(container, count)
  local lineCount = count or 1
  for index = 1, lineCount do
    local newline = AceGUI:Create("Label")
    newline:SetFullWidth(true)
    container:AddChild(newline)
  end
end

---在容器中创建消息字体的 label
---@param container AceGUIWidget 容器
---@param text string 文本内容
---@param width number 文本宽度
---@param justifyH string 水平对齐方式
function GuiCreateChatLabel(container, text, width, justifyH)
  local label = AceGUI:Create("Label")
  label:SetText(text)
  label:SetFont(ChatFontNormal:GetFont())
  label:SetWidth(width)
  if justify ~= nil then
    label:SetJustifyH(justifyH)
  end
  container:AddChild(label)
end

---在容器中创建间隔
---@param container AceGUIWidget 容器
---@param width number 间隔宽度
function GuiCreateSpacing(container, width)
  local spacing = AceGUI:Create("Label")
  spacing:SetWidth(width)
  container:AddChild(spacing)
end

function split(pString, pPattern)
  local Table = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(Table, cap)
    end
    last_end = e + 1
    s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
    cap = pString:sub(last_end)
    table.insert(Table, cap)
  end
  return Table
end

-------------------------------------------------------------------------------------------------------------
-- Blizzard Lua Api
-- [Documentation](https://warcraft.wiki.gg/wiki/Lua_functions)
-------------------------------------------------------------------------------------------------------------

---当前用户是否 获取or完成 本周丰裕藏宝图
function IsCompletedDelveBountyMap()
  return C_QuestLog.IsQuestFlaggedCompleted(86371)
end

---从背包和仓库中获取物品数量
function GetItemCountFromAll(itemID)
  return C_Item.GetItemCount(itemID, true, false)
end

---定义确认对话框（只需定义一次）
---@param message string 提示信息
---@param callback function 回调函数
function SimpleConfirm(message, callback)
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
