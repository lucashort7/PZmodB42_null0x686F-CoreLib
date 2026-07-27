--
-- log.lua (null0x686F_CoreLib shared logger)
--
-- unified leveled logger for every null0x686F mod, replacing the per-mod copies
-- that had drifted into incompatible signatures. generalizes null0x686F_QoL's
-- original varargs implementation into a per-mod factory.
--
-- returns a plain table of closures (log.debug(...), not log:debug(...)) --
-- every existing call site in the suite uses dot-call, not colon-call.
--

local Null0x686FCoreLib = require("null0x686F_CoreLib/core")

local _tostring = tostring
local _ipairs = ipairs
local _type = type
local _select = select
local _math_floor = math.floor
local _math_ceil = math.ceil
local _table_concat = table.concat
local _string_format = string.format
local _print = print
local _os_date = os.date

local modes = { "trace", "debug", "info", "warn", "error", "fatal" }

local levels = {}
for i, name in _ipairs(modes) do
  levels[name] = i
end

local function _round(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and _math_floor(x + 0.5) or _math_ceil(x - 0.5)) * increment
end

local function _format_args(...)
  local t = {}
  for i = 1, _select("#", ...) do
    local x = _select(i, ...)
    if _type(x) == "number" then
      x = _round(x, 0.01)
    end
    t[#t + 1] = _tostring(x)
  end
  return _table_concat(t, " ")
end

-- dumps every line to Zomboid/Lua/<filename> -- a predictable, greppable
-- session log, since console.txt/DebugLog.txt have proven unreliable to
-- fetch mid-session. getFileWriter's append/overwrite semantics aren't
-- reliably confirmed, so read the existing content ourselves and rewrite it
-- plus the new line -- guarantees accumulation regardless of what the
-- native flag actually does.
local function _dump_to_file(filename, line)
  local existing = ""
  local reader = getFileReader(filename, false)
  if reader then
    local l = reader:readLine()
    while l do
      existing = existing .. l .. "\r\n"
      l = reader:readLine()
    end
    reader:close()
  end

  local writer = getFileWriter(filename, true, false)
  if not writer then return end
  writer:write(existing .. line .. "\r\n")
  writer:close()
end

-- mod_tag: shown in the bracketed prefix, e.g. "null0x686F_QoL"
-- level_getter: function() -> level string, OR a static level string
-- dump_filename: optional; when set, lines are also appended to this file
--                (under Zomboid/Lua/) while the logger's level is "debug"
local function _new(mod_tag, level_getter, dump_filename)
  local logger = {
    level = nil, -- public mutable override, takes priority over level_getter
  }

  local function _current_level()
    if logger.level then return logger.level end
    if _type(level_getter) == "function" then return level_getter() end
    return level_getter or "info"
  end

  for i, name in _ipairs(modes) do
    logger[name] = function(...)
      local current = _current_level()
      if i < (levels[current] or levels.info) then return end

      local msg = _format_args(...)
      local line = _string_format("[%s - %s] [%s] %s", name:upper(), _os_date("%Y-%m-%d %H:%M:%S"), mod_tag, msg)
      _print(line)

      if dump_filename and current == "debug" then
        _dump_to_file(dump_filename, line)
      end
    end
  end

  return logger
end

local function _log_new(mod_tag, level_getter)
  return _new(mod_tag, level_getter, nil)
end

local function _log_new_file_logger(mod_tag, level_getter, filename)
  return _new(mod_tag, level_getter, filename)
end

Null0x686FCoreLib.Log = {
  new = _log_new,
  newFileLogger = _log_new_file_logger,
}

return Null0x686FCoreLib.Log
