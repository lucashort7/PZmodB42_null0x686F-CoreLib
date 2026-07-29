# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.1.3...v0.2.0) (2026-07-28)


### Features

* migrate to release-please + reusable Steam Workshop deploy ([f5f0f48](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/f5f0f48579f2e7c1163b22a36b18e5ffd2d2a993))

## [0.1.3] - 2026-07-28

### Added

-   Steam Workshop m00nl1ght-dev/steam-workshop-deploy@v3 action to `release.yml`.
-   .workshopignore file.

## [0.1.2] - 2026-07-27

### Changed

-   `name=` now displays as `[null0x686F] CoreLib` in the in-game mod list, grouping it with the rest of the null0x686F suite (previously matched the raw mod id, with a space instead of the bracket format).

## [0.1.1] - 2026-07-27

### Fixed

-   Removed the debug-only "null0x686F Global Control Panel" world context menu entry — Debug Panel now opens exclusively via the `Core_DebugPanelKey` keybind.
-   Gated the "Toggle Global Debug Panel" Mod Options entry behind Debug Mode — was previously showing for every player of any mod requiring CoreLib.

## [0.1.0] - 2026-07-27

### Added

-   Global Debug Panel (`Null0x686FDebugPanel`) with sidebar rail and plugin API (`_G.Null0x686FCoreLib.registerTab`).
-   Shared leveled logger (`_G.Null0x686FCoreLib.Log.new`/`.newFileLogger`).
-   Shared tool-finder utility (`_G.Null0x686FCoreLib.Tools.find_tool_by_tag`).
