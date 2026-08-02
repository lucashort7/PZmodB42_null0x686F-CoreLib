-- version-compatibility check for mods depending on null0x686F_CoreLib.
-- inspired by Starlit Library's Version.lua, simplified: semver only
-- (versionMin in mod.info already covers PZ-build compatibility separately,
-- so we don't parse a build-number prefix), and no update popup yet -- there's
-- no live Workshop URL to link to until this is actually published.

local Null0x686FCoreLib = require("null0x686F_CoreLib/core")

local _tonumber = tonumber
local _string_match = string.match

local log = require("null0x686F_CoreLib/utils/log").new("null0x686F_CoreLib", "info")

local Version = {}

local mod_info = getModInfoByID("null0x686F_CoreLib")
Version.VERSION_STRING = mod_info and mod_info:getModVersion() or "0.0.0"

-- named "own_" because the functions below take major/minor/patch parameters
-- meaning the opposite thing -- the version a *consumer* requires. same three
-- words, two directions; keeping both as plain `major` shadowed one with the
-- other and made compareVersion's body ambiguous to read.
local own_major, own_minor, own_patch = _string_match(Version.VERSION_STRING, "(%d+)%.(%d+)%.(%d+)")
Version.MAJOR = _tonumber(own_major) or 0
Version.MINOR = _tonumber(own_minor) or 0
Version.PATCH = _tonumber(own_patch) or 0

-- compares the current CoreLib version to the version a dependent mod was
-- built against. returns "toolow" | "toohigh" | "compatible".
function Version.compareVersion(major, minor, patch)
  if Version.MAJOR > major then return "toohigh" end
  if Version.MAJOR < major then return "toolow" end

  if Version.MINOR < minor then return "toolow" end
  if Version.MINOR == minor and Version.PATCH < patch then return "toolow" end

  return "compatible"
end

-- a mismatch is only logged, so a player never learns why the mod misbehaves.
-- showing a modal with an update link instead is tracked in issue #22.
function Version.ensureVersion(major, minor, patch)
  local result = Version.compareVersion(major, minor, patch)

  if result == "toolow" then
    log.warn(
      "installed CoreLib version", Version.VERSION_STRING,
      "is older than the version", major .. "." .. minor .. "." .. patch, "this mod expects"
    )
  end

  return result
end

Null0x686FCoreLib.Version = Version

return Version
