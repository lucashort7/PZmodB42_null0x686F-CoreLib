# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2026-07-27

### Fixed

-   Removed the debug-only "null0x686F Global Control Panel" world context menu entry — Debug Panel now opens exclusively via the `Core_DebugPanelKey` keybind.
-   Gated the "Toggle Global Debug Panel" Mod Options entry behind Debug Mode — was previously showing for every player of any mod requiring CoreLib.

## [0.1.0] - 2026-07-27

### Added

-   Global Debug Panel (`Null0x686FDebugPanel`) with sidebar rail and plugin API (`_G.Null0x686FCoreLib.registerTab`).
-   Shared leveled logger (`_G.Null0x686FCoreLib.Log.new`/`.newFileLogger`).
-   Shared tool-finder utility (`_G.Null0x686FCoreLib.Tools.find_tool_by_tag`).

[Unreleased]: https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.1.1...HEAD

[0.1.1]: https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/v0.1.0...v0.1.1

[0.1.0]: https://github.com/lucashort7/PZmodB42_null0x686F-CoreLib/compare/34a1f634854c11e8cfa6e1c1cbdca04e248e90b1...v0.1.0
