# null0x686F CoreLib

![Project Zomboid](https://img.shields.io/badge/Project%20Zomboid-B42-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Performance](https://img.shields.io/badge/Performance-O(1)-brightgreen)

Shared, zero-overhead library for the null0x686F mod suite. Makes no gameplay changes on its own — it's a dependency for the other null0x686F mods.

## Features
- **Global Debug Panel** — sidebar UI other mods register tabs into via `_G.Null0x686FCoreLib.registerTab(tabName, uiClass, category)`.
- **Shared Logger** — `_G.Null0x686FCoreLib.Log.new(mod_tag, level_getter)` / `.newFileLogger(...)`, leveled (`trace/debug/info/warn/error/fatal`), used by every mod in the suite.
- **Tools** — `_G.Null0x686FCoreLib.Tools.find_tool_by_tag(player, tags)`.
- **Version** — `_G.Null0x686FCoreLib.Version.compareVersion(...)` / `.ensureVersion(...)` for dependent mods to check compatibility.

## Installation (Manual)
1. Download the latest `.zip` from [Releases](../../releases).
2. Extract the `null0x686F_CoreLib` folder into `C:\Users\YOUR_USER\Zomboid\mods\`.
3. Enable the mod in the main menu.

## Depended on by
- null0x686F QoL
- null0x686F ContextCleaner
- null0x686F CombatText
