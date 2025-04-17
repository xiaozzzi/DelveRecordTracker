---获取指定颜色的文本, 文本以 |cFF 开头, |r 结尾
---@param color string 颜色
---@param text number 行数
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
