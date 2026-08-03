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

-- one shared file for the whole suite, not one per mod: every line already
-- carries its [mod_tag], and a single timeline is what makes cross-mod
-- causality readable -- the CoreLib-then-consumer ordering that the
-- OnEquipPrimary double-dispatch bug required reading. four separate files
-- means reconstructing that order by eye.
local DUMP_FILE = "null0x686F/suite.log"

-- getFileWriter's third parameter is append: true writes after the file's
-- current contents, false erases them. this used to pass false and
-- compensate by reading the whole file back and rewriting it plus the new
-- line -- O(n^2) in line count, with the concatenation allocating on every
-- call. real append, so the cost is constant per line.
local function _dump_to_file(filename, line)
  local writer = getFileWriter(filename, true, true)
  if not writer then return end
  writer:write(line .. "\r\n")
  writer:close()
end

-- mod_tag: shown in the bracketed prefix, e.g. "null0x686F_QoL"
-- level_getter: function() -> level string, OR a static level string
-- dump_to_file: when true, lines are also appended to the shared suite log
--               while the logger's level is "debug"
local function _new(mod_tag, level_getter, dump_to_file)
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

      if dump_to_file and current == "debug" then
        _dump_to_file(DUMP_FILE, line)
      end
    end
  end

  return logger
end

local function _log_new(mod_tag, level_getter)
  return _new(mod_tag, level_getter, false)
end

-- the filename parameter this used to take is gone: every mod now writes to
-- the same DUMP_FILE, so letting each caller name its own defeats the point.
local function _log_new_file_logger(mod_tag, level_getter)
  return _new(mod_tag, level_getter, true)
end

Null0x686FCoreLib.Log = {
  new = _log_new,
  newFileLogger = _log_new_file_logger,
}

return Null0x686FCoreLib.Log
