local addon = LibStub("AceAddon-3.0"):NewAddon("DelveRecordTracker")
DRT_MinimapButton = LibStub("LibDBIcon-1.0", true)


local DRT_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("DelveRecordTracker", {
  type = "launcher",
  text = "DelveRecordTracker",
  icon = "Interface\\AddOns\\DelveRecordTracker\\assets\\Icon.tga",
  OnClick = function(self, btn)
    if btn == "LeftButton" or btn == "RightButton" then
      DRT_UTIL:ToggleMainFrame()
    end
  end,

  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then
      return
    end

    tooltip:AddLine("地下堡记录器", nil, nil, nil, nil)
  end,
})

local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("DRT_LDB", {
    profile = {
      minimap = {
        hide = DRT_ICON_DB["hide"],
      },
    },
  })

  icon:Register("DelveRecordTracker", DRT_LDB, DRT_ICON_DB)
end

DRT_MinimapButton:Show("DelveRecordTracker")
