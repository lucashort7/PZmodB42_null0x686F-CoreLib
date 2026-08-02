-- temporary probe: proves the luacheck gate actually rejects a PR.
-- deleted in the next commit.
local unused_local = 42

local function probe()
  return thisGlobalDoesNotExistAnywhere()
end

return probe
