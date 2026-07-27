if not _G.Null0x686FCoreLib then
  _G.Null0x686FCoreLib = {
    tabs = {},
    _hotkey_pressed_time = 0,
  }
end

local _ipairs = ipairs
local _table_insert = table.insert

function _G.Null0x686FCoreLib.registerTab(tab_name, ui_class, category)
  for _, tab in _ipairs(_G.Null0x686FCoreLib.tabs) do
    if tab.name == tab_name then
      tab.ui_class = ui_class
      tab.category = category or tab.category or "NULL0X686F"
      return
    end
  end
  
  _table_insert(_G.Null0x686FCoreLib.tabs, {
    name = tab_name,
    ui_class = ui_class,
    category = category or "NULL0X686F"
  })
end

if Events.OnResetLua then
  Events.OnResetLua.Add(function()
    _G.Null0x686FCoreLib.tabs = {}
  end)
end

return _G.Null0x686FCoreLib
