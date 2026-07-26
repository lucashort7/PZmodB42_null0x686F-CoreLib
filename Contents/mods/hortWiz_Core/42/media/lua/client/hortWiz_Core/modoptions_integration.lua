local cfg = require("hortWiz_Core/cfg")
local debug_panel = require("hortWiz_Core/ui/debug_panel")

local _mod_id = "hortWiz_Core"
local _mod_name = "HortWiz Core"

local function _init_mod_options()
  if not (PZAPI and PZAPI.ModOptions and PZAPI.ModOptions.create) then
    return
  end

  local options = PZAPI.ModOptions:create(_mod_id, _mod_name)
  if not options then return end

  options:addKeyBind("Core_DebugPanelKey", "Toggle Global Debug Panel", cfg.DEBUG_PANEL.hotkey)
end

local function on_key_pressed(key)
  local current_hotkey = cfg.DEBUG_PANEL.hotkey

  if PZAPI and PZAPI.ModOptions and PZAPI.ModOptions.getOptions then
    local opts = PZAPI.ModOptions:getOptions(_mod_id)
    if opts then
      local kb = opts:getOption("Core_DebugPanelKey")
      if kb and kb:getValue() then
        current_hotkey = kb:getValue()
      end
    end
  end

  if key == current_hotkey then
    debug_panel.toggle()
  end
end

Events.OnGameBoot.Add(_init_mod_options)
Events.OnKeyPressed.Add(on_key_pressed)
