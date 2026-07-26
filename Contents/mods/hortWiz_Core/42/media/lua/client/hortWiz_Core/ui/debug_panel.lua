require("ISUI/ISCollapsableWindow")
require("ISUI/ISPanel")
require("ISUI/ISButton")
require("ISUI/ISLabel")

local cfg = require("hortWiz_Core/cfg")
local core_api = require("hortWiz_Core/core")

local _ipairs = ipairs
local _pairs = pairs
local _type = type
local _table_insert = table.insert
local _string_format = string.format

HortWizDebugPanel = ISCollapsableWindow:derive("HortWizDebugPanel")

local _THEME = {
  windowBg = { r = 0.08, g = 0.08, b = 0.08, a = 0.95 },
  sidebarBg = { r = 0.04, g = 0.04, b = 0.04, a = 0.98 },
  border = { r = 0.25, g = 0.25, b = 0.25, a = 0.9 },
  btnNormal = { r = 0.12, g = 0.12, b = 0.12, a = 0.9 },
  btnHover = { r = 0.22, g = 0.22, b = 0.22, a = 0.9 },
  btnActive = { r = 0.0, g = 0.45, b = 0.75, a = 0.9 },
  headerText = { r = 0.6, g = 0.6, b = 0.6, a = 1.0 },
  btnText = { r = 0.9, g = 0.9, b = 0.9, a = 1.0 },
  closeBtn = { r = 0.8, g = 0.15, b = 0.15, a = 0.95 }
}

function HortWizDebugPanel:initialise()
  ISCollapsableWindow.initialise(self)
  self.title = "HortWiz Global Control Panel"
  self.resizable = false

  self.tabs = {}
  self.activeTab = "Context Cleaner"
end

function HortWizDebugPanel:createChildren()
  ISCollapsableWindow.createChildren(self)

  local th = self:titleBarHeight()
  local sideW = 140
  self.sidebarW = sideW

  self.close_btn = ISButton:new(self.width - 24, 4, 18, 18, "X", self, HortWizDebugPanel.close)
  self.close_btn.internal = "CLOSE"
  self.close_btn.anchorTop = true
  self.close_btn.anchorRight = true
  self.close_btn:initialise()
  self.close_btn:instantiate()
  self.close_btn.backgroundColor = _THEME.closeBtn
  self.close_btn.borderColor = { r = 1, g = 0.3, b = 0.3, a = 0.8 }
  self.close_btn.textColor = { r = 1, g = 1, b = 1, a = 1 }
  self:addChild(self.close_btn)

  self.sidebar = ISPanel:new(0, th, sideW, self.height - th)
  self.sidebar:initialise()
  self.sidebar:instantiate()
  self.sidebar.backgroundColor = _THEME.sidebarBg
  self.sidebar.borderColor = _THEME.border
  self:addChild(self.sidebar)

  self.content_area = ISPanel:new(sideW, th, self.width - sideW, self.height - th)
  self.content_area:initialise()
  self.content_area:instantiate()
  self.content_area.backgroundColor = _THEME.windowBg
  self.content_area.borderColor = _THEME.border
  self:addChild(self.content_area)

  self:build_sidebar_rail()
end

function HortWizDebugPanel:build_sidebar_rail()
  local sideW = self.sidebarW
  local btn_h = 24
  local pad = 6
  local curr_y = 10

  local registered_tabs = (_G.HortWizCore and _G.HortWizCore.tabs) or {}
  local grouped_tabs = {
    HORTWIZ = {},
    SYSTEM = {}
  }

  for _, tab_data in _ipairs(registered_tabs) do
    local cat = tab_data.category or "HORTWIZ"
    if not grouped_tabs[cat] then grouped_tabs[cat] = {} end
    _table_insert(grouped_tabs[cat], tab_data)
  end

  self.sidebar.rows = {}
  local categories = { "HORTWIZ", "SYSTEM" }
  local first_tab_name = nil

  for _, cat_name in _ipairs(categories) do
    local tab_list = grouped_tabs[cat_name]
    if tab_list and #tab_list > 0 then
      _table_insert(self.sidebar.rows, { kind = "cap", text = "--- " .. cat_name .. " ---", y = curr_y, h = 16 })
      curr_y = curr_y + 20

      for _, tab_data in _ipairs(tab_list) do
        local tab_name_val = tab_data.name
        if not first_tab_name then first_tab_name = tab_name_val end

        _table_insert(self.sidebar.rows, { kind = "item", name = tab_name_val, y = curr_y, h = btn_h })

        if tab_data.ui_class and _type(tab_data.ui_class.new) == "function" then
          local content_w = self.content_area.width
          local content_h = self.content_area.height
          local content_panel = tab_data.ui_class:new(0, 0, content_w, content_h)
          content_panel:initialise()
          content_panel:instantiate()
          content_panel:setVisible(false)
          self.content_area:addChild(content_panel)
          self.tabs[tab_name_val] = content_panel
        end

        curr_y = curr_y + btn_h + pad
      end
      curr_y = curr_y + 10
    end
  end

  local win = self
  self.sidebar.prerender = function(s)
    local my = s:isMouseOver() and s:getMouseY() or -1
    s:drawRect(0, 0, s.width, s.height, _THEME.sidebarBg.a, _THEME.sidebarBg.r, _THEME.sidebarBg.g, _THEME.sidebarBg.b)
    s:drawRectBorder(0, 0, s.width, s.height, _THEME.border.a, _THEME.border.r, _THEME.border.g, _THEME.border.b)

    for _, row in _ipairs(s.rows) do
      if row.kind == "cap" then
        s:drawText(row.text, 10, row.y, _THEME.headerText.r, _THEME.headerText.g, _THEME.headerText.b, 1, UIFont.Small)
      elseif row.kind == "item" then
        local active = (win.activeTab == row.name)
        local hov = (my >= row.y and my < row.y + row.h)
        local bg = active and _THEME.btnActive or (hov and _THEME.btnHover or _THEME.btnNormal)
        s:drawRect(8, row.y, s.width - 16, row.h, bg.a, bg.r, bg.g, bg.b)
        s:drawRectBorder(8, row.y, s.width - 16, row.h, _THEME.border.a, _THEME.border.r, _THEME.border.g, _THEME.border.b)
        s:drawText(row.name, 14, row.y + 4, _THEME.btnText.r, _THEME.btnText.g, _THEME.btnText.b, 1, UIFont.Small)
      end
    end
  end

  self.sidebar.onMouseUp = function(s, x, y)
    print(_string_format("[HortWizCore] sidebar.onMouseUp at x=%d, y=%d", x, y))
    for _, row in _ipairs(s.rows) do
      if row.kind == "item" and y >= row.y and y < row.y + row.h then
        print(_string_format("[HortWizCore] HIT TEST MATCH -> '%s'", row.name))
        win:select_tab(row.name)
        return true
      end
    end
    return false
  end

  local target_tab = self.activeTab or first_tab_name
  if target_tab and self.tabs[target_tab] then
    self:select_tab(target_tab)
  elseif first_tab_name then
    self:select_tab(first_tab_name)
  end
end

function HortWizDebugPanel:select_tab(tab_name)
  if not tab_name then return end

  for name, panel in _pairs(self.tabs) do
    if name == tab_name then
      panel:setVisible(true)
      panel:bringToTop()
    else
      panel:setVisible(false)
    end
  end

  self.activeTab = tab_name
end

function HortWizDebugPanel:close()
  self:setVisible(false)
  self:removeFromUIManager()
end

function HortWizDebugPanel:new(x, y, width, height, player)
  local o = ISCollapsableWindow:new(x, y, width, height)
  setmetatable(o, self)
  self.__index = self
  o.player = player
  o.backgroundColor = _THEME.windowBg
  o.borderColor = _THEME.border
  o.resizable = false
  return o
end

local _debug_panel_instance = nil

local function toggle_debug_panel()
  if not _debug_panel_instance then
    local w = 520
    local h = 360
    local x = (getCore():getScreenWidth() / 2) - (w / 2)
    local y = (getCore():getScreenHeight() / 2) - (h / 2)

    _debug_panel_instance = HortWizDebugPanel:new(x, y, w, h)
    _debug_panel_instance:initialise()
    _debug_panel_instance:instantiate()
    _debug_panel_instance:addToUIManager()
  else
    if _debug_panel_instance:getIsVisible() then
      _debug_panel_instance:close()
    else
      _debug_panel_instance:removeFromUIManager()
      local w = 520
      local h = 360
      local x = (getCore():getScreenWidth() / 2) - (w / 2)
      local y = (getCore():getScreenHeight() / 2) - (h / 2)
      _debug_panel_instance = HortWizDebugPanel:new(x, y, w, h)
      _debug_panel_instance:initialise()
      _debug_panel_instance:instantiate()
      _debug_panel_instance:addToUIManager()
    end
  end
end

local function on_fill_world_context_menu(player, context, worldobjects, test)
  if isDebugEnabled() then
    context:addOption("HortWiz Global Control Panel", nil, toggle_debug_panel)
  end
end
Events.OnFillWorldObjectContextMenu.Add(on_fill_world_context_menu)

return {
  toggle = toggle_debug_panel,
}
