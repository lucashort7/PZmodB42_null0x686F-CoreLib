local Null0x686FCoreLib = require("null0x686F_CoreLib/core")

if not Null0x686FCoreLib.tabs then Null0x686FCoreLib.tabs = {} end

local _ipairs = ipairs
local _table_insert = table.insert

local function _register_tab(tab_name, ui_class, category)
  for _, tab in _ipairs(Null0x686FCoreLib.tabs) do
    if tab.name == tab_name then
      tab.ui_class = ui_class
      tab.category = category or tab.category or "NULL0X686F"
      return
    end
  end

  _table_insert(Null0x686FCoreLib.tabs, {
    name = tab_name,
    ui_class = ui_class,
    category = category or "NULL0X686F"
  })
end

-- returns the live tabs table by reference, not a snapshot -- OnResetLua
-- below reassigns Null0x686FCoreLib.tabs to a brand new table, so callers
-- must always re-fetch via this getter instead of caching the old table.
local function _get_tabs()
  return Null0x686FCoreLib.tabs
end

if Events.OnResetLua then
  Events.OnResetLua.Add(function()
    Null0x686FCoreLib.tabs = {}
  end)
end

Null0x686FCoreLib.TabRegistry = {
  registerTab = _register_tab,
  get_tabs = _get_tabs,
}

return Null0x686FCoreLib.TabRegistry
