# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.2.3...v0.3.0) (2026-07-30)


### Features

* vendor PZAPI ModOptions apply/dirty-focus patch ([#17](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/issues/17)) ([d3ad344](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/d3ad344707ded727f0af98850002fa990ddf7ffb))
* vendor PZAPI ModOptions apply/dirty-focus patch ([#17](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/issues/17)) ([465ae3d](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/465ae3d2fc1103e2212a5799bca761a60a40a749))

## [0.2.3](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.2.2...v0.2.3) (2026-07-29)


### Miscellaneous Chores

* test Contents-only Workshop upload path fix ([7b1eab7](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/7b1eab76298a0c3893c94296382f3d6faeed484b))

## [0.2.2](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.2.1...v0.2.2) (2026-07-29)


### Miscellaneous Chores

* test previewFile support via forked action ([4c933f4](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/4c933f425e772d0923b24dccb6be85deb3d460e4))

## [0.2.1](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.2.0...v0.2.1) (2026-07-29)


### Miscellaneous Chores

* force release for Workshop preview test ([e9345be](https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/commit/e9345be3e6a9e60d6a8a04f9fe94185947ab3b91))

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
