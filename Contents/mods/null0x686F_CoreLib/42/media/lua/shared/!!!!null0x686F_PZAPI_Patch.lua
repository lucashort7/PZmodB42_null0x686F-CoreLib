--[[
Patches PZAPI.ModOptions:save to fix two engine bugs, shared across every
null0x686F mod that registers PZAPI ModOptions:

  1. "Dirty Focus": PZAPI.ModOptions:save() serializes option.value/selected/
     color straight from the Lua option table, not the live UI widget --
     confirmed at PZAPI/ModOptions.lua:259-279 in the installed game. If a
     widget's own onChange hasn't flushed back to the table yet (combobox
     and colorpicker are the main risk, tickboxes flush on click), clicking
     Accept/Apply can persist a stale value.
  2. "Missing Apply": Options:apply() is a stub (PZAPI/ModOptions.lua:21)
     meant to be overridden per mod. MainOptions:apply() does call it for
     every registered mod (MainOptions.lua:3760-3763) when the player uses
     the vanilla options screen -- but any code path that calls
     PZAPI.ModOptions:save() directly, bypassing that screen, never fires it.

Filename intentionally starts with "!!!!" instead of living under this
repo's usual null0x686F_CoreLib/ namespace, so its Events.OnGameBoot
registration (see below) beats every other mod's by alphabetical scan
order -- but the actual patch is deferred to that event, not applied at
file-parse time. Confirmed empirically (2026-07-30): patching PZAPI.
ModOptions.save unconditionally at the top of this file silently no-ops,
because "!!!!" also sorts ahead of vanilla's own client/PZAPI/ModOptions.lua
-- which is itself a normal scanned .lua file, not a pre-existing engine
global -- so PZAPI.ModOptions doesn't exist yet at that point. Mirrors the
pattern already proven working elsewhere in the suite (null0x686F_QoL's own
save patch, installed inside an Events-triggered init()).

Adapted from "PZAPI Patch" by khalkhedra (Steam Workshop 3698931252):
https://steamcommunity.com/sharedfiles/filedetails/?id=3698931252
]]

local function _apply_patch()
  if not PZAPI or not PZAPI.ModOptions then return end
  if _G.__Null0x686FCoreLib_PZAPIPatched then return end
  _G.__Null0x686FCoreLib_PZAPIPatched = true

  -- "debug" level (not the usual "info" default) + file dump so this patch's
  -- confirmation lines are actually verifiable during QA -- print() alone was
  -- confirmed (2026-07-30) to not reliably reach console.txt mid-session.
  local log = require("null0x686F_CoreLib/utils/log").newFileLogger("null0x686F_CoreLib/PZAPIPatch", "debug", "null0x686F_CoreLib_debug.log")

  local original_save = PZAPI.ModOptions.save

  function PZAPI.ModOptions:save()
    for _, options in ipairs(self.Data) do
      for _, option in ipairs(options.data) do
        if option.element then
          if option.type == "slider" then
            option.value = option.element:getCurrentValue()
          elseif option.type == "tickbox" then
            option.value = option.element:isSelected(1)
          elseif option.type == "multipletickbox" then
            for i, v in ipairs(option.values) do
              v.value = option.element:isSelected(i)
            end
          elseif option.type == "textentry" then
            option.value = option.element:getText()
          elseif option.type == "combobox" then
            option.selected = option.element.selected
          elseif option.type == "colorpicker" then
            local bg = option.element.backgroundColor
            if bg then
              option.color = {
                r = bg.r or (type(bg.getR) == "function" and bg:getR()) or 0,
                g = bg.g or (type(bg.getG) == "function" and bg:getG()) or 0,
                b = bg.b or (type(bg.getB) == "function" and bg:getB()) or 0,
                a = bg.a or (type(bg.getA) == "function" and bg:getA()) or 1,
              }
            end
          elseif option.type == "keybind" then
            option.key = option.element.keyCode
          end
        end
      end
    end

    original_save(self)

    for _, options in ipairs(self.Data) do
      if options.apply then
        options:apply()
      end
    end

    log.info("PZAPI.ModOptions:save() patched -- live UI sync + apply() dispatched")
  end

  log.info("null0x686F_CoreLib PZAPI patch installed")
end

Events.OnGameBoot.Add(_apply_patch)
_apply_patch()
