# MemoryMap 🧠 — Complete AI Context & System Specification

> **AI Instruction**: This document is the single source of truth for **MemoryMap**. Any AI assistant (ChatGPT, Claude, Gemini, Cursor, Copilot, Antigravity) reading this file should possess complete domain and architectural knowledge of the codebase without needing to read every file individually.

---

## 1. Project Essence & Core Constraints

- **Product Name**: MemoryMap
- **Tagline**: Ambient Second Brain & Knowledge Map
- **Platform**: Flutter (Android, iOS, Web, Desktop capable)
- **Architecture**: Clean Architecture + Repository Pattern + Riverpod 3.0 Notifiers
- **Strict Constraints**:
  - **No backend, no REST/GraphQL API, no Firebase, no Supabase, no third-party servers**.
  - **100% Offline-First**: All data is persisted on-device in Hive local key-value boxes.
  - **Zero Tracking / Zero Telemetry**: Complete privacy.
  - **Not a Dashboard**: Uses floating note islands, generous Japanese minimalist negative space (*Ma* - 間), and frosted glass docks instead of table-like CRUD dashboards.

---

## 2. Directory & File Organization

```text
MemoryMap/
├── assets/
│   └── screenshots/              # High-resolution screenshots and hero banner
│       ├── banner.png            # 16:9 Ambient Hero Banner
│       ├── home_dark.png         # Obsidian Dark Home Screen
│       ├── home_light.png        # Rice Paper Light Home Screen
│       ├── editor.png            # Markdown Editor & Island Palettes
│       └── search.png            # Search Engine & Tag Cloud
├── lib/
│   ├── main.dart                 # Application bootstrap, edge-to-edge UI, ProviderScope
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart # Box names, settings keys, animation timings
│   │   ├── errors/
│   │   │   └── failures.dart      # StorageFailure, BackupFailure, ValidationFailure
│   │   ├── extensions/
│   │   │   └── theme_extensions.dart # ThemeContextX (dynamicBackground, dynamicSurface)
│   │   ├── theme/
│   │   │   ├── app_colors.dart    # 3 core palettes (Light/Dark/AMOLED) + 6 IslandPalettes
│   │   │   ├── app_theme.dart     # ThemeData definitions for Light, Dark, and AMOLED
│   │   │   └── app_typography.dart# Plus Jakarta Sans text hierarchy
│   │   └── utils/
│   │       ├── date_formatter.dart # Organic relative timestamps ('Just now', '5 mins ago')
│   │       ├── page_transitions.dart# FadeThroughPageRoute with smooth scale-fade physics
│   │       └── text_utils.dart    # Word counter, reading time, markdown stripper
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── categories_local_datasource.dart # CRUD + default seeding for categories
│   │   │   ├── notes_local_datasource.dart      # CRUD + reactive Hive box watcher
│   │   │   └── tags_local_datasource.dart        # CRUD + default tag seeding
│   │   └── repositories/
│   │       ├── backup_repository_impl.dart      # JSON export/import, file saving, seeder
│   │       ├── categories_repository_impl.dart  # Concrete CategoriesRepository
│   │       ├── notes_repository_impl.dart       # Filtering, sorting, query matching logic
│   │       └── tags_repository_impl.dart        # Concrete TagsRepository
│   ├── domain/
│   │   ├── models/
│   │   │   ├── category.dart      # Category model (id, name, colorValue, iconName)
│   │   │   ├── note.dart          # Note model (id, title, content, categoryId, tagIds, etc.)
│   │   │   ├── note_filter.dart   # NoteFilter (searchQuery, categoryId, tagIds, section)
│   │   │   └── tag.dart           # Tag model (id, name, colorValue)
│   │   └── repositories/
│   │       ├── backup_repository.dart    # BackupData contract & export methods
│   │       ├── categories_repository.dart# Category CRUD contract
│   │       ├── notes_repository.dart     # Note stream & operation contracts
│   │       └── tags_repository.dart       # Tag CRUD contract
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── backup_provider.dart      # BackupNotifier (JSON export/import)
│   │   │   ├── categories_provider.dart  # CategoriesNotifier & stream provider
│   │   │   ├── notes_provider.dart       # NoteFilterNotifier, GridViewNotifier, NotesNotifier
│   │   │   ├── tags_provider.dart        # TagsNotifier & stream provider
│   │   │   └── theme_provider.dart       # ThemeNotifier (Light/Dark/AMOLED + overlay)
│   │   ├── screens/
│   │   │   ├── home_screen.dart          # Floating note islands, categories bar, dock
│   │   │   ├── note_editor_screen.dart   # Markdown editor, preview mode, island palette
│   │   │   ├── search_screen.dart        # Sub-millisecond instant search engine
│   │   │   └── settings_sheet.dart       # Themes, AMOLED toggle, backup/restore
│   │   └── widgets/
│   │       └── smart_organization_bar.dart # Pinned to Mind sticky thought bar
│   ├── services/
│   │   └── storage_service.dart          # Hive initialization & box compaction
│   └── widgets/
│       ├── category_island_bar.dart      # Glowing horizontal category chips
│       ├── category_selector_sheet.dart  # Category selection & custom creator
│       ├── floating_dock.dart            # Frosted glass bottom dock with centered FAB
│       ├── glassmorphic_container.dart   # BackdropFilter blur capsule
│       ├── note_island_card.dart         # Floating note island card with palette tint
│       └── tag_selector_sheet.dart       # Multi-tag assignment & custom tag creator
├── test/
│   └── widget_test.dart                  # Unit tests for TextUtils, DateFormatter, models
└── project_knowledge/                    # High-priority AI documentation suite
```

---

## 3. Database Schema (Hive NoSQL Local Key-Value Store)

### Box 1: `memorymap_notes_box` (Key: `String id`, Value: `Map<String, dynamic>`)
```json
{
  "id": "uuid-v4-string",
  "title": "Quantum Computing & Information",
  "content": "# Markdown content\nAtomic notes on superposition and qubits...",
  "categoryId": "cat_study",
  "tagIds": ["tag_deep_work", "tag_architecture"],
  "isPinned": false,
  "isFavorite": true,
  "isArchived": false,
  "isTrashed": false,
  "colorIndex": 2,
  "createdAt": "2026-09-26T14:00:00.000Z",
  "updatedAt": "2026-09-26T14:30:00.000Z",
  "lastViewedAt": "2026-09-26T15:00:00.000Z"
}
```

### Box 2: `memorymap_categories_box` (Key: `String id`, Value: `Map<String, dynamic>`)
```json
{
  "id": "cat_ideas",
  "name": "Ideas",
  "colorValue": 4287315190,
  "iconName": "sparkles",
  "isDefault": true,
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

### Box 3: `memorymap_tags_box` (Key: `String id`, Value: `Map<String, dynamic>`)
```json
{
  "id": "tag_deep_work",
  "name": "deep-work",
  "colorValue": 4284720881,
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

### Box 4: `memorymap_settings_box` (Primitive Key-Value storage)
- `app_theme_mode`: `int` (0: system, 1: light, 2: dark)
- `app_is_amoled`: `bool` (true for pitch black `#000000`)
- `app_is_grid_view`: `bool` (true for masonry grid, false for list)
- `app_has_seeded_sample_data`: `bool` (prevents re-seeding on subsequent launches)

---

## 4. Business Logic & Core Algorithms

### 1. Note Filtering & Sorting Engine (`NotesRepositoryImpl`)
The notes stream emits an immutable `List<Note>` filtered dynamically according to `NoteFilter`:
- **Section Isolation**:
  - `NoteSection.all`: filters out `isTrashed == true` and `isArchived == true`.
  - `NoteSection.favorites`: requires `isFavorite == true`, filters out trash/archive.
  - `NoteSection.archived`: requires `isArchived == true`, filters out trash.
  - `NoteSection.trash`: requires `isTrashed == true`.
- **Category Filter**: `note.categoryId == filter.selectedCategoryId`.
- **Tags Matching**: `filter.selectedTagIds.every((tag) => note.tagIds.contains(tag))`.
- **Search Matching**:
  ```dart
  final query = filter.searchQuery.trim().toLowerCase();
  final titleMatch = note.title.toLowerCase().contains(query);
  final contentMatch = note.content.toLowerCase().contains(query);
  ```
- **Sorting Strategy**:
  - Pinned notes (`isPinned == true`) are prioritized to the top in `NoteSection.all`.
  - Secondary sort respects `NoteSortBy` (`updatedAtDesc`, `updatedAtAsc`, `createdAtDesc`, `titleAsc`).

### 2. Reading Time & Word Count (`TextUtils`)
- Word count splits by whitespace regex `\s+`.
- Reading speed is pegged to standard cognitive reading speed: **200 words per minute**.
- Minimum reading time is clamped to 1 minute: `(words / 200).ceil().clamp(1, 999)`.

### 3. Markdown Stripping (`TextUtils.stripMarkdown`)
Converts raw markdown text to clean preview strings for note island cards by eliminating heading hashes (`#`), asterisks, blockquote angles (`>`), bullet hashes (`- [ ]`), and collapsing multiline returns into clean single lines.

### 4. 6 Island Color Palettes (`AppColors.islandPalettes`)
Each index (0 to 5) defines a coordinated color system adapting between Light, Obsidian Dark, and AMOLED:
1. `0: Neutral Glass` (Clean paper / translucent obsidian)
2. `1: Solar Amber` (Warm creative spark)
3. `2: Aurora Indigo` (Deep thought / logic)
4. `3: Zen Emerald` (Peaceful reflection)
5. `4: Rose Petal` (Emotional & personal journaling)
6. `5: Lavender Dream` (Intuitive & conceptual planning)

---

## 5. State Management Blueprint (Riverpod 3.0)

- `themeProvider`: `NotifierProvider<ThemeNotifier, ThemeState>`
- `noteFilterProvider`: `NotifierProvider<NoteFilterNotifier, NoteFilter>`
- `isGridViewProvider`: `NotifierProvider<GridViewNotifier, bool>`
- `notesNotifierProvider`: `AsyncNotifierProvider<NotesNotifier, void>`
- `categoriesNotifierProvider`: `AsyncNotifierProvider<CategoriesNotifier, List<Category>>`
- `tagsNotifierProvider`: `AsyncNotifierProvider<TagsNotifier, List<Tag>>`
- `backupNotifierProvider`: `AsyncNotifierProvider<BackupNotifier, String?>`
- `filteredNotesProvider`: `StreamProvider<List<Note>>` (watches `notesRepositoryProvider` and `noteFilterProvider`)

---

## 6. User Flows & Screen Lifecycles

1. **Cold Start**:
   - `main()` initializes Hive and opens all boxes.
   - If `app_has_seeded_sample_data` is false, seeds 5 rich sample atomic notes.
   - Edge-to-edge transparent system overlay is applied.
   - `HomeScreen` loads, displaying `Pinned to Mind` bar and masonry staggered islands.
2. **Note Creation**:
   - User taps centered `+` button in `FloatingDock`.
   - `FadeThroughPageRoute` animates smoothly to `NoteEditorScreen`.
   - On typing, `_hasChanges` becomes true; reading metrics calculate in real-time.
   - On pop (`PopScope`), `_saveNote()` persists note to Hive and pops cleanly.
3. **Quick Triage via Gestures**:
   - Swipe Right -> Pins note to top (with tactile haptic feedback).
   - Swipe Left -> Archives note with an undo toast action.
   - Long-press -> Opens modal sheet to switch island color palette or move to trash.
4. **Knowledge Backup**:
   - User taps Settings -> Backup to Local File or Share JSON.
   - Single-file JSON serialization guarantees complete zero-loss portability.
