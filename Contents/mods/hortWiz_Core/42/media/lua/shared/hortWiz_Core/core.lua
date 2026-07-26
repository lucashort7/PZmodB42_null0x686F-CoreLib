if not _G.HortWizCore then
  _G.HortWizCore = {
    tabs = {},
    _hotkey_pressed_time = 0,
  }
end

local _ipairs = ipairs
local _table_insert = table.insert

function _G.HortWizCore.registerTab(tab_name, ui_class, category)
  for _, tab in _ipairs(_G.HortWizCore.tabs) do
    if tab.name == tab_name then
      tab.ui_class = ui_class
      tab.category = category or tab.category or "HORTWIZ"
      return
    end
  end
  
  _table_insert(_G.HortWizCore.tabs, {
    name = tab_name,
    ui_class = ui_class,
    category = category or "HORTWIZ"
  })
end

if Events.OnResetLua then
  Events.OnResetLua.Add(function()
    _G.HortWizCore.tabs = {}
  end)
end

return _G.HortWizCore
