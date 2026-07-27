local cfg = require("null0x686F_CoreLib/debug_panel/cfg")
local debug_panel = require("null0x686F_CoreLib/debug_panel/window")

local _mod_id = "null0x686F_CoreLib"
local _mod_name = "null0x686F CoreLib"

local function _init_mod_options()
  if not isDebugEnabled() then return end
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
