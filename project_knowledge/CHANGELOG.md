# MemoryMap 🧠 — Changelog & Version History

All notable changes to the MemoryMap application are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), adhering to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-09-26

### 🚀 Initial Production Release

#### 🌟 Features Added
- **Core Notes Engine**:
  - Implemented full CRUD operations for atomic thoughts and notes.
  - Added sticky Pin toggle and non-destructive Archiving with Undo snackbar.
  - Implemented Recycle Bin with restore and permanent empty capabilities.
  - Built an interactive Markdown Preview mode supporting headers, lists, quotes, and checklists.
  - Real-time word count calculation and reading time estimator (200 wpm standard).
  - Built `PopScope` integration for seamless auto-saving on back gesture.
- **Categories Module**:
  - Pre-seeded 5 standard categories (*Personal, Study, Ideas, Work, Projects*).
  - Built Custom Category Studio supporting custom naming, 8 color swatches, and Lucide icons.
  - Horizontal glowing category capsule bar with active indicator.
- **Tags Taxonomy**:
  - Multi-tag assignment per note.
  - Pre-seeded default tags (`urgent`, `deep-work`, `architecture`, `reading`, `zen`).
  - Custom tag creator modal with real-time tag cloud chips.
  - Multi-tag set intersection filter engine.
- **Search Engine**:
  - Instant sub-millisecond full-text search across titles, markdown content, and tags.
  - Live query results counter with calm empty-state illustration.
- **Smart Organization**:
  - **Pinned to Mind Bar**: Horizontal sticky strip prioritizing vital thoughts.
  - **Recently Viewed Notes Carousel**: Tracks the last 5 accessed notes with access timestamps.
  - **Recently Edited Carousel**: Fast recall for active writing sessions.
- **Storage & Backup Engine**:
  - Integrated offline-first Hive NoSQL binary key-value engine.
  - One-tap JSON export of all notes, categories, and tags.
  - Local file backup generation using `path_provider`.
  - JSON file restore via native platform file pickers.
  - Native OS Share Sheet integration via `share_plus`.
  - Sample knowledge base seeder on cold launch.

#### 🎨 UI Redesigns & Aesthetics
- **Japanese Minimalist Aesthetic (*Ma* - 間)**: Replaced rigid dashboard tables with organic floating note islands.
- **6 Dynamic Island Palettes**: Neutral Glass, Solar Amber, Aurora Indigo, Zen Emerald, Rose Petal, Lavender Dream.
- **Frosted Glass Floating Dock**: Arc/Apple-inspired bottom navigation capsule with centered gradient action button and frosted glass blur.
- **Tri-Theme Precision**:
  - Warm Rice Paper Light Mode (`#FBFBF9`).
  - Smoked Slate Obsidian Dark Mode (`#0F1117`).
  - True `#000000` AMOLED Mode with black navigation bar overlay for OLED power savings.

#### ⚡ Performance & Physics Improvements
- Implemented `FadeThroughPageRoute` for smooth scale-fade route transitions.
- Integrated `flutter_animate` staggered entrance animations on note cards.
- Integrated `Hero` animations on note cards expanding into editor screen.
- Added tactile haptic feedback on tab switches, card swipes, and long-press menus.
- Integrated Pull-to-Refresh with stream invalidation.
- Created `StorageService.optimizeDatabase()` for automatic Hive box compaction.
- Built responsive layout scaling from 2 columns on phones to 3–4 columns on tablets and desktops.

#### 🐛 Bug Fixes & Refactorings
- Upgraded state management to modern Riverpod 3.0 `Notifier` and `AsyncNotifier` architecture.
- Fixed `FilePicker` 13.x direct static invocation for multiplatform file imports.
- Updated deprecated `CardTheme` to Material 3 `CardThemeData`.
- Resolved all static analysis warnings (achieved **0 issues** across entire codebase).
- Established 100% passing unit test suite for domain models and utilities.
