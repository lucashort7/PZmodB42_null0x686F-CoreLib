# Fixing the load-order bug in PZAPI ModOptions patches

`null0x686F_CoreLib` ships a patch for two real engine bugs in Project Zomboid Build 42's `PZAPI.ModOptions:save()`. The UI-sync logic in that patch is adapted from **khalkhedra's "PZAPI Patch"** ([Steam Workshop `3698931252`](https://steamcommunity.com/sharedfiles/filedetails/?id=3698931252)) — credit where it's due, that mod correctly identified both bugs. This doc exists because the published version doesn't actually apply: it never fires, silently, with no error and nothing in `console.txt`.

## The two bugs being patched

1. **"Dirty Focus"** — `PZAPI.ModOptions:save()` serializes `option.value` / `option.selected` / `option.color` straight from the Lua option table, not the live UI widget (confirmed at the installed `PZAPI/ModOptions.lua:259-279`). If a widget's own `onChange` hasn't flushed back to the table yet — combobox and colorpicker are the main risk, tickboxes flush on click — clicking Accept/Apply persists a stale value.
2. **"Missing Apply"** — `Options:apply()` is an empty stub (`PZAPI/ModOptions.lua:21`), meant to be overridden per mod. `MainOptions:apply()` *does* call it for every registered mod (`MainOptions.lua:3760-3763`) when the player uses the vanilla options screen — but any code path that calls `PZAPI.ModOptions:save()` directly, bypassing that screen, never triggers it.

## khalkhedra's original fix (as published)

```lua
if not PZAPI or not PZAPI.ModOptions then return end

-- Patch the save function to pull live data from UI elements
local originalSave = PZAPI.ModOptions.save
function PZAPI.ModOptions:save()
    for _, options in ipairs(self.Data) do
        for _, option in ipairs(options.data) do
            if option.element then
                -- Force sync Lua value from Java UI element
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
                            a = bg.a or (type(bg.getA) == "function" and bg:getA()) or 1
                        }
                    end
                elseif option.type == "keybind" then
                    option.key = option.element.keyCode
                end
            end
        end
    end

    -- Call the original save logic
    originalSave(self)

    -- Trigger the missing 'apply' notification
    for _, options in ipairs(self.Data) do
        if options.apply then
            options:apply()
        end
    end
end
```

The sync logic itself is correct. The problem is entirely about *when* it runs.

## Why it never fires

This file lives in `media/lua/shared/`, and the `if not PZAPI or not PZAPI.ModOptions then return end` guard runs **once, synchronously, at file-parse time** — the instant PZ's loader reaches this file during its scan.

At that point, `PZAPI.ModOptions` does not exist yet. It's created by `client/PZAPI/ModOptions.lua` — a normal `.lua` file scanned like any other, *not* a pre-injected Java/engine global available from the first line of Lua that runs. `shared/` is scanned as an earlier load stage than `client/`. So the guard evaluates `PZAPI.ModOptions == nil`, returns immediately, and the patch body below it never executes. No error, no log — it just silently no-ops forever.

This also means the mod's own stated reasoning for how it works doesn't hold: prefixing a filename to sort early (this file uses `AAA_`) only controls ordering **within** a load stage — it decides which `shared/` file runs before which other `shared/` file. It cannot make a `shared/`-stage file run after a `client/`-stage file. No filename trick crosses that boundary.

## The fix

Same body, same logic — the only change is deferring execution until `Events.OnGameBoot` fires, by which point every vanilla global (including `PZAPI.ModOptions`) is guaranteed to exist:

```lua
-- Patch the save function to pull live data from UI elements
local function applyPZAPIPatch()
    if not PZAPI or not PZAPI.ModOptions then return end

    local originalSave = PZAPI.ModOptions.save
    function PZAPI.ModOptions:save()
        for _, options in ipairs(self.Data) do
            for _, option in ipairs(options.data) do
                if option.element then
                    -- Force sync Lua value from Java UI element
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
                                a = bg.a or (type(bg.getA) == "function" and bg:getA()) or 1
                            }
                        end
                    elseif option.type == "keybind" then
                        option.key = option.element.keyCode
                    end
                end
            end
        end

        -- Call the original save logic
        originalSave(self)

        -- Trigger the missing 'apply' notification
        for _, options in ipairs(self.Data) do
            if options.apply then
                options:apply()
            end
        end
    end
end

Events.OnGameBoot.Add(applyPZAPIPatch)
```

## The diff, isolated

Everything below the guard is unchanged. The fix is:
- Wrap the guard + patch body in a local function instead of running it at file scope.
- Replace the top-level `if ... then return end` with `Events.OnGameBoot.Add(applyPZAPIPatch)` at the bottom of the file.
- Keep the guard *inside* the function — `OnGameBoot` guarantees `PZAPI.ModOptions` exists by the time it fires, but the guard costs nothing and protects against any future engine change to boot ordering.

No other behavior changes. Same file, same filename, same `shared/` location — just deferred to the right moment.

## How this was verified

- Direct read of the installed vanilla `client/PZAPI/ModOptions.lua` and `OptionScreens/MainOptions.lua` confirmed the exact line numbers cited above, rather than inferring engine behavior from a mod's comments or a Workshop description.
- The load-order claim itself (not just reasoned about, but tested) was isolated with a disposable multi-scenario mod (`PZAPI_LoadOrder_Test`) — one file per hypothesis: `shared/` top-level (two filename-prefix variants), `shared/` deferred via `OnGameBoot`, and `client/` top-level as a positive control, each unconditionally printing whether `PZAPI`/`PZAPI.ModOptions` existed at that point, with no early-return guard (since the guard is exactly what hides the answer). All four hypotheses confirmed against `console.txt` in one boot.
