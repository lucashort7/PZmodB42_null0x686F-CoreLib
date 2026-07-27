local Null0x686FCoreLib = require("null0x686F_CoreLib/core")

-- tags: a single ItemTag value, or an array of them (matches if the item has ANY of them)
local function _item_has_any_tag(item, tags)
  if type(tags) == "table" then
    for i = 1, #tags do
      if item:hasTag(tags[i]) then return true end
    end
    return false
  end
  return item:hasTag(tags)
end

local function _is_matching_tool(item, tags)
  return item ~= nil and not item:isBroken() and _item_has_any_tag(item, tags)
end

-- finds the first unbroken inventory item carrying any of `tags`.
local function _find_tool_by_tag(player, tags)
  return player:getInventory():getFirstEvalRecurse(function(item)
    return _is_matching_tool(item, tags)
  end)
end

Null0x686FCoreLib.ItemFinder = {
  find_tool_by_tag = _find_tool_by_tag,
}

return Null0x686FCoreLib.ItemFinder
