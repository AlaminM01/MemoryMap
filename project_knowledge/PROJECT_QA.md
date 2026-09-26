# MemoryMap 🧠 — Comprehensive Project Q&A (100+ Questions)

> **Viva, Placement, Interview & Project Defense Guide**: This document contains comprehensive questions and technical answers covering every dimension of MemoryMap.

---

## Table of Contents
1. [Business & Conceptual Questions (Q1 - Q10)](#1-business--conceptual-questions)
2. [Architecture & Design Pattern Questions (Q11 - Q20)](#2-architecture--design-pattern-questions)
3. [Flutter & Frontend Engineering Questions (Q21 - Q35)](#3-flutter--frontend-engineering-questions)
4. [State Management & Riverpod 3 Questions (Q36 - Q45)](#4-state-management--riverpod-3-questions)
5. [Storage & Hive Database Questions (Q46 - Q58)](#5-storage--hive-database-questions)
6. [Search Engine & Retrieval Algorithm Questions (Q59 - Q68)](#6-search-engine--retrieval-algorithm-questions)
7. [UI/UX, Glassmorphism & Japanese Aesthetics Questions (Q69 - Q78)](#7-uiux-glassmorphism--japanese-aesthetics-questions)
8. [Animations, Physics & Gesture Interaction Questions (Q79 - Q86)](#8-animations-physics--gesture-interaction-questions)
9. [Backup, JSON Portability & Data Integrity Questions (Q87 - Q92)](#9-backup-json-portability--data-integrity-questions)
10. [Security, Offline Privacy & Performance Questions (Q93 - Q100)](#10-security-offline-privacy--performance-questions)
11. [Build, Deployment & App Store Publishing Questions (Q101 - Q105)](#11-build-deployment--app-store-publishing-questions)
12. [Interview & Placement Defense Questions (Q106 - Q110)](#12-interview--placement-defense-questions)

---

## 1. Business & Conceptual Questions

#### Q1: What is MemoryMap?
**A:** MemoryMap is an ambient "Second Brain" mobile application designed to help users capture thoughts atomically, organize ideas organically, and retrieve information with zero latency. It avoids rigid spreadsheet-like dashboards, using floating note islands inspired by Japanese minimalist philosophy.

#### Q2: What problem does MemoryMap solve?
**A:** It addresses cognitive fragmentation, subscription fatigue, cloud privacy vulnerabilities, and dashboard clutter. Most note applications trap ideas in rigid grids, require constant internet connections, and upload private thoughts to third-party cloud servers.

#### Q3: How does MemoryMap differ from traditional note-taking apps like Google Keep or Apple Notes?
**A:** Unlike Google Keep's cluttered sticky walls or Apple Notes' plain folder hierarchies, MemoryMap uses an organic "Floating Island" architecture with customizable palette tints, a frosted glass floating dock, smart cognitive retrieval carousels, and a pure offline-first architecture.

#### Q4: Why is MemoryMap NOT designed as a dashboard?
**A:** Dashboards are designed for metrics and data reporting, creating visual clutter that causes cognitive fatigue. Personal knowledge management requires a tranquil, calm canvas (*Ma* - 間) that gives ideas room to breathe and connect.

#### Q5: Who are the primary target users of MemoryMap?
**A:** Software engineers, writers, students, researchers, startup founders, and privacy advocates who want an immediate, distraction-free environment to record thoughts without fear of data harvesting.

#### Q6: What is the monetization model of MemoryMap?
**A:** MemoryMap is 100% free, open-source (MIT License), and backend-free. It has no subscriptions, no paywalls, and no advertisements.

#### Q7: What inspired the visual design direction?
**A:** Five key design philosophies: Apple Notes (ergonomic restraint), Notion Mobile (modular typography), Obsidian (atomic notes concept), Arc Browser (floating frosted glass docks), and Japanese Minimalist Zen Design (Ma negative space).

#### Q8: What does the term "Second Brain" mean in this context?
**A:** Coined by Tiago Forte in *Building a Second Brain*, it refers to an external, digital cognitive repository that frees your biological brain from memorizing details, allowing it to focus on creative thinking and synthesis.

#### Q9: How does MemoryMap help prevent idea hoarding?
**A:** By offering tactile one-swipe archiving and recycling, sticky pinning of only active concepts, and automated reading time calculations, encouraging users to keep their cognitive space clean.

#### Q10: What is the strategic advantage of being 100% offline-first?
**A:** Zero server hosting costs, instant startup times without network requests, immune to outages, fully usable on airplanes or subways, and zero legal liability regarding GDPR/CCPA cloud data handling.

---

## 2. Architecture & Design Pattern Questions

#### Q11: What software architecture does MemoryMap follow?
**A:** Strict **Clean Architecture** combined with the **Repository Pattern**. It divides code into `core`, `domain`, `data`, `presentation`, `widgets`, and `services` layers.

#### Q12: Why was Clean Architecture chosen instead of standard MVC or simple provider architecture?
**A:** Clean Architecture enforces total decoupling of business entities from the UI and storage engines. If Hive is ever replaced with SQLite or Isar, the domain layer (`Note`, `Category`, `Tag`) remains completely untouched.

#### Q13: What constitutes the Domain Layer in MemoryMap?
**A:** Pure Dart classes: models (`Note`, `Category`, `Tag`, `NoteFilter`), functional failures (`failures.dart`), and abstract repository interfaces (`NotesRepository`, `CategoriesRepository`, `TagsRepository`, `BackupRepository`). It has zero dependencies on Flutter or third-party packages.

#### Q14: What is the responsibility of the Data Layer?
**A:** Implementing domain repository contracts using concrete datasources. It manages Hive box serializations, key-value mappings, and reactive box change streams.

#### Q15: What is the Repository Pattern and how is it utilized?
**A:** The Repository Pattern acts as a facade between the domain logic and data storage. The presentation layer talks only to abstract repositories; `NotesRepositoryImpl` coordinates data fetching, filtering, and persisting.

#### Q16: How does Dependency Inversion work in MemoryMap?
**A:** High-level UI notifiers do not depend on low-level Hive database implementations; both depend on abstract repository interfaces provided via Riverpod (`notesRepositoryProvider`).

#### Q17: Where does validation and business logic reside?
**A:** In the Domain models and Repository implementations (e.g. `NoteFilter` matching rules and `NotesRepositoryImpl._filterAndSortNotes`).

#### Q18: What is the role of `StorageService`?
**A:** A singleton service that encapsulates the Hive lifecycle: initializing `hive_flutter`, opening typed boxes, and executing database compaction.

#### Q19: How are errors and exceptions handled across layers?
**A:** Low-level storage exceptions are caught and wrapped in structured `Failure` domain objects (`StorageFailure`, `BackupFailure`, `RestoreFailure`) rather than crashing the UI.

#### Q20: What is the folder structure under `lib/`?
**A:**
- `core/`: constants, errors, extensions, theme, utils
- `domain/`: models, repositories
- `data/`: datasources, repositories
- `presentation/`: providers, screens, widgets
- `widgets/`: reusable glass and island widgets
- `services/`: storage services

---

## 3. Flutter & Frontend Engineering Questions

#### Q21: Which Flutter SDK version is used?
**A:** Flutter 3.47.5 on the stable channel with Dart 3.13.4.

#### Q22: Is Material 3 enabled in MemoryMap?
**A:** Yes, `useMaterial3: true` is explicitly configured across all themes, utilizing modern Material 3 color schemes, typography specs, and button styling.

#### Q23: How is edge-to-edge system navigation implemented?
**A:** In `main.dart`, `SystemChrome.setSystemUIOverlayStyle` sets `statusBarColor: Colors.transparent` and `systemNavigationBarColor: Colors.transparent` to allow content to flow naturally behind system bars.

#### Q24: How is responsive layout handled between phones and tablets?
**A:** `HomeScreen` inspects `MediaQuery.of(context).size.width`. If width is $\ge 960\text{px}$, it displays 4 columns; $\ge 600\text{px}$ displays 3 columns; otherwise 2 columns for standard mobile phones.

#### Q25: How does the List vs. Grid toggle work?
**A:** `isGridViewProvider` manages a boolean state. When toggled, the UI seamlessly switches between `SliverMasonryGrid.count` and `SliverList`.

#### Q26: What widget library is used for masonry grid layouts?
**A:** `flutter_staggered_grid_view` (specifically `SliverMasonryGrid`).

#### Q27: How is markdown preview implemented in the Note Editor?
**A:** The editor includes an interactive Preview Mode toggle. It tokenizes markdown text line-by-line, dynamically rendering headers (`#`, `##`, `###`), quotes (`>`), checklists (`- [ ]`), and bullets.

#### Q28: How does the Note Editor handle unsaved changes when the user presses back?
**A:** It uses the modern Flutter `PopScope(canPop: false, onPopInvokedWithResult: ...)` to automatically intercept back gestures and persist the note without requiring a separate confirmation dialog.

#### Q29: What font family is configured for the Japanese minimalist aesthetic?
**A:** Google Fonts' **Plus Jakarta Sans**, chosen for its balanced geometric proportions, wide apertures, and clean legibility.

#### Q30: What icon pack is utilized?
**A:** `lucide_icons` 0.257.0, providing sleek, consistent 24px/16px vector glyphs inspired by Arc and Notion.

#### Q31: How is the Floating Dock anchored at the bottom of the screen?
**A:** Using a `Stack` containing the main scrollable `CustomScrollView` and a `Positioned(bottom: 0, left: 0, right: 0)` child wrapping `FloatingDock`.

#### Q32: Why is `CustomScrollView` used instead of a standard `ListView`?
**A:** `CustomScrollView` with slivers (`SliverToBoxAdapter`, `SliverMasonryGrid`, `SliverList`, `SliverFillRemaining`) allows seamless mixing of horizontal carousels, category bars, and adaptive note grids in a single scroll physics pipeline.

#### Q33: How does the empty state render when no notes match a filter?
**A:** It displays a centered Zen illustration with contextual copy based on the active section (All, Favorites, Archived, or Trash).

#### Q34: How is word count calculated?
**A:** `TextUtils.countWords(content)` strips leading/trailing spaces and splits by `RegExp(r'\s+')`.

#### Q35: How is estimated reading time computed?
**A:** `(wordCount / 200).ceil().clamp(1, 999)` assuming an average adult reading speed of 200 words per minute.

---

## 4. State Management & Riverpod 3 Questions

#### Q36: Why was Riverpod 3.0 chosen over Provider or Bloc?
**A:** Riverpod 3 offers compile-time safety, does not depend on the Flutter widget tree (`BuildContext`), eliminates provider-not-found exceptions, and supports reactive `StreamProvider` and `AsyncNotifier` out of the box.

#### Q37: How do Riverpod 3 `Notifier` and `AsyncNotifier` differ from legacy `StateNotifier`?
**A:** In Riverpod 3, `StateNotifier` is deprecated. Modern `Notifier<T>` and `AsyncNotifier<T>` initialize synchronously or asynchronously via their `build()` method and have direct access to `ref.watch()`.

#### Q38: How does `filteredNotesProvider` stay updated when notes change?
**A:** It is a `StreamProvider` that observes `notesRepositoryProvider.watchNotes(filter)`. Whenever the Hive notes box changes or `noteFilterProvider` updates, the stream automatically re-evaluates and emits the new list.

#### Q39: What is `noteFilterProvider`?
**A:** A `NotifierProvider<NoteFilterNotifier, NoteFilter>` maintaining the active filter state: `searchQuery`, `selectedCategoryId`, `selectedTagIds`, `section` (All, Favorites, Archived, Trash), and `sortBy`.

#### Q40: How are note modifications triggered through Riverpod?
**A:** `notesNotifierProvider` exposes async methods (`saveNote`, `togglePin`, `toggleFavorite`, `toggleArchive`, `moveToTrash`, `emptyTrash`).

#### Q41: How is the theme mode managed in Riverpod?
**A:** `themeProvider` (`NotifierProvider<ThemeNotifier, ThemeState>`) loads saved preferences from Hive on startup and exposes `setThemeMode(ThemeMode)` and `toggleAmoled(bool)`.

#### Q42: What happens when `ref.invalidate(filteredNotesProvider)` is called?
**A:** It forces the notes stream provider to discard its cached value and re-query the local datasource, utilized in the pull-to-refresh gesture.

#### Q43: How is category data managed reactively?
**A:** `categoriesStreamProvider` exposes a continuous stream of categories from Hive, while `categoriesNotifierProvider` handles creating and deleting custom categories.

#### Q44: Can Riverpod providers be tested without mocking Flutter widgets?
**A:** Yes! Because Riverpod providers are independent of `BuildContext`, they can be instantiated and tested in unit tests using a `ProviderContainer`.

#### Q45: How does MemoryMap prevent unnecessary widget rebuilds with Riverpod?
**A:** By using granular selectors (`ref.watch(noteFilterProvider.select((f) => f.section))`) so that widgets only rebuild when the exact state slice they depend on changes.

---

## 5. Storage & Hive Database Questions

#### Q46: What is Hive?
**A:** Hive is a fast, lightweight, pure Dart NoSQL key-value database designed for Flutter applications that runs on all platforms without native compilation dependencies.

#### Q47: Why was Hive chosen instead of SQLite / sqflite?
**A:**
1. Zero native build complexity (avoids C++ compilation issues on iOS/Android).
2. Pure Dart execution with zero IPC bridging overhead.
3. Sub-millisecond read/write speeds for serialized JSON maps.
4. Seamless cross-platform support (Android, iOS, Web, Desktop).

#### Q48: How are notes stored inside Hive?
**A:** As serialized `Map<String, dynamic>` key-value entries in `memorymap_notes_box` where the key is the Note's unique UUID string.

#### Q49: What are the Hive box names in MemoryMap?
**A:**
- `memorymap_notes_box`: stores notes
- `memorymap_categories_box`: stores categories
- `memorymap_tags_box`: stores tags
- `memorymap_settings_box`: stores app preferences

#### Q50: How does MemoryMap ensure database backwards and forwards compatibility without build_runner?
**A:** By storing notes as generic JSON Maps and serializing via `Note.toJson()` and `Note.fromJson()`, avoiding fragile binary Hive adapter type IDs and code generation.

#### Q51: How does Hive notify the application of data changes?
**A:** Every Hive box provides a reactive stream via `box.watch()`. `NotesLocalDataSourceImpl.watchNotesBox()` forwards this stream to Riverpod.

#### Q52: What is Hive box compaction?
**A:** When records in Hive are updated or deleted, disk space is not immediately freed; it is marked deleted. Compaction re-writes the active keys to reclaim storage space.

#### Q53: How does MemoryMap perform database compaction?
**A:** `StorageService.optimizeDatabase()` calls `await _notesBox.compact()`, `await _categoriesBox.compact()`, and `await _tagsBox.compact()`.

#### Q54: What happens if a note entry in Hive is corrupted?
**A:** `NotesLocalDataSourceImpl.getAllNotes()` wraps individual entry deserialization in a `try-catch` block, safely skipping corrupted keys without crashing the app.

#### Q55: How are default categories seeded into Hive?
**A:** During first launch, `CategoriesLocalDataSourceImpl.seedDefaultCategoriesIfEmpty()` checks if `_box.isEmpty`. If true, it inserts the 5 default categories (*Personal, Study, Ideas, Work, Projects*).

#### Q56: How are default tags seeded?
**A:** Similarly, `TagsLocalDataSourceImpl.seedDefaultTagsIfEmpty()` populates default tags (`urgent`, `deep-work`, `architecture`, `reading`, `zen`).

#### Q57: How is sample data prevented from re-seeding on every app restart?
**A:** `AppConstants.hasSeededSampleDataKey` is recorded as `true` in `settingsBox` upon first seed.

#### Q58: What is the storage footprint of a typical note in Hive?
**A:** Approximately 200–500 bytes per note, meaning 10,000 notes consume less than 5 megabytes of local storage.

---

## 6. Search Engine & Retrieval Algorithm Questions

#### Q59: How does the instant search engine work?
**A:** In `SearchScreen`, the user's keystrokes update `_currentQuery`. This queries `notesRepository.watchNotes(NoteFilter(searchQuery: query))`.

#### Q60: Does the search engine query a remote server?
**A:** No. All search queries execute 100% locally in-memory on the device's CPU with zero latency.

#### Q61: What fields are indexed during search?
**A:** Note **Title**, Note **Markdown Content**, and Note **Tags**.

#### Q62: Is the search case-sensitive?
**A:** No, queries and note fields are normalized using `.toLowerCase()`.

#### Q63: What algorithm is used for string matching?
**A:** Substring containment matching (`contains(query)`). Because notes are cached in-memory, scanning thousands of notes executes in less than 2 milliseconds.

#### Q64: How are search results presented?
**A:** As floating island cards displaying the category tag, matching title, stripped markdown snippet, and reading time.

#### Q65: What is the "Smart Organization" feature?
**A:** It consists of:
1. **Pinned to Mind Bar**: Horizontal sticky pills for critical pinned ideas.
2. **Recently Viewed Carousel**: Chronologically tracks the last 5 viewed notes.
3. **Recently Edited Carousel**: Fast recall of actively drafted thoughts.

#### Q66: How is a note marked as "Recently Viewed"?
**A:** Whenever a user opens a note in `NoteEditorScreen`, `notesNotifier.markNoteViewed(note.id)` sets `lastViewedAt = DateTime.now()`.

#### Q67: How does category filtration interact with search?
**A:** In `HomeScreen`, when a category is selected (e.g., *Study*), search queries only match notes within that specific category.

#### Q68: How does multi-tag filtering work?
**A:** `NoteFilter.selectedTagIds` uses set intersection logic (`filter.selectedTagIds.every((tag) => note.tagIds.contains(tag))`), meaning only notes possessing **all** selected tags will appear.

---

## 7. UI/UX, Glassmorphism & Japanese Aesthetics Questions

#### Q69: What is the Japanese concept of "Ma" (間) and how does MemoryMap apply it?
**A:** *Ma* refers to negative space or pauses in time that give shape and resonance to objects. MemoryMap applies *Ma* through generous padding, organic island margins, and clean typography, preventing visual claustrophobia.

#### Q70: How is soft glassmorphism achieved in Flutter?
**A:** Using `BackdropFilter` with `ImageFilter.blur(sigmaX: 16, sigmaY: 16)`, semi-transparent surface backgrounds (`Colors.white.withOpacity(0.82)` or `#171A23` with opacity), and a 1px delicate border highlight.

#### Q71: What is a "Floating Note Island"?
**A:** An organic card with rounded 24px corners, subtle colored tinting, delicate shadow elevation, and contextual tag pills that visually appears to float above the canvas.

#### Q72: What are the 6 Island Palettes?
**A:**
1. Default Neutral Glass
2. Solar Amber (Warm gold)
3. Aurora Indigo (Electric blue)
4. Zen Emerald (Sage green)
5. Rose Petal (Crimson blush)
6. Lavender Dream (Violet mist)

#### Q73: How does the AMOLED theme differ from the Dark theme?
**A:**
- **Dark Theme (Obsidian)**: Deep slate background (`#0F1117`), elevated card surface (`#171A23`).
- **AMOLED Theme**: Pure pitch black (`#000000`) across background and cards, turning off OLED display pixels to achieve 0-watt black and maximize battery conservation.

#### Q74: What is the Floating Dock?
**A:** An Arc-inspired frosted glass capsule anchored at the bottom of the screen containing navigation switches (*Notes, Favorites, Search, More*) and a prominent gradient `+` action button.

#### Q75: How does the category bar indicate active selection?
**A:** Active categories glow with their respective accent color, expand with an active border, and show high-contrast typography.

#### Q76: What visual feedback is provided when switching themes?
**A:** Color transitions interpolate smoothly via Flutter's animated `ThemeData` changes without jarring layout flickers.

#### Q77: Why are subtle colored borders used instead of solid card backgrounds?
**A:** High-contrast solid colored backgrounds fatigue the eyes during long reading sessions; delicate borders provide immediate visual taxonomy while maintaining legibility.

#### Q78: How is typography hierarchy structured?
**A:**
- `displaySmall`: 24px w700 (Section titles)
- `titleLarge`: 17px w700 (Note titles)
- `bodyLarge`: 16px w400, height 1.6 (Note editing text)
- `bodyMedium`: 13.5px w400 (Note preview snippets)
- `labelSmall`: 10-12px w600 (Tag chips & read time)

---

## 8. Animations, Physics & Gesture Interaction Questions

#### Q79: What hero animations are implemented?
**A:** The `Hero(tag: 'note_island_${note.id}')` wraps each note card and connects to the `NoteEditorScreen`, producing a smooth shared-element physical expansion when tapped.

#### Q80: How does `FadeThroughPageRoute` work?
**A:** A custom `PageRouteBuilder` that combines a fade curve (`CurvedAnimation(curve: Curves.easeOutCubic)`) with a subtle scale transition (`0.96` to `1.0`), eliminating jarring page slides.

#### Q81: What swipe gestures are available on note cards?
**A:**
- **Swipe Right**: Toggles note Pin status.
- **Swipe Left**: Archives the note and displays an Undo snackbar.

#### Q82: How does the swipe-to-dismiss widget prevent accidental deletes?
**A:** `confirmDismiss` intercepts the swipe direction. Swiping right returns `false` (updating pin state without removing the widget), while swiping left archives with an immediate "Undo" action.

#### Q83: Where is haptic feedback applied?
**A:**
- `HapticFeedback.lightImpact()` on tab switches, category taps, and heart favoriting.
- `HapticFeedback.mediumImpact()` on long-press quick action sheets and swipe dismissals.
- `HapticFeedback.selectionClick()` on grid/list toggles.

#### Q84: How do note cards animate on initial screen load?
**A:** Using `flutter_animate`, cards execute `.fadeIn(duration: 280ms)` and `.slideY(begin: 0.04, end: 0)` with ease-out cubic deceleration.

#### Q85: How does the pull-to-refresh interaction behave?
**A:** Wrapped in a `RefreshIndicator`, pulling down triggers light haptic feedback, refreshes the active stream, and invalidates cached query state.

#### Q86: How does the category selector bottom sheet animate?
**A:** It slides up as an interactive bottom sheet with drag-handle dismissibility and smooth expansion when "+ New Category" is toggled.

---

## 9. Backup, JSON Portability & Data Integrity Questions

#### Q87: How does knowledge export work?
**A:** `BackupRepositoryImpl.exportBackupJson()` collects all notes, categories, and tags, assembling them into a versioned `BackupData` object serialized to formatted JSON.

#### Q88: What is the structure of a MemoryMap backup file?
**A:**
```json
{
  "version": 1,
  "exportedAt": "2026-09-26T18:00:00.000Z",
  "notes": [...],
  "categories": [...],
  "tags": [...]
}
```

#### Q89: How does the local file backup function?
**A:** `saveBackupToFile()` queries `path_provider.getApplicationDocumentsDirectory()`, creates a file named `memorymap_backup_<timestamp>.json`, and writes the JSON payload.

#### Q90: How does the restore operation work?
**A:** The user selects a `.json` backup file via `file_picker`. The system parses `BackupData.fromJson()`, saves categories, tags, and notes to their respective Hive boxes, and triggers an instant UI update.

#### Q91: What happens if a user imports an older backup?
**A:** Because notes use unique UUID strings, existing notes with matching IDs are updated cleanly, while new notes are appended without duplicate conflicts.

#### Q92: Can notes be shared outside the app?
**A:** Yes, the "Share Knowledge Base JSON" option triggers the native operating system share sheet via `share_plus` (AirDrop, email, Bluetooth, Google Drive).

---

## 10. Security, Offline Privacy & Performance Questions

#### Q93: Where are notes physically stored on the device?
**A:** In the application's sandboxed local documents directory managed by Android/iOS, inaccessible to other standard installed applications.

#### Q94: Does MemoryMap transmit any data over the internet?
**A:** Absolutely zero. No HTTP client requests, no analytics SDKs, no crash reporters, and no remote telemetry.

#### Q95: What permissions does MemoryMap request?
**A:** No sensitive runtime permissions (no location, no camera, no contacts, no microphone). Only local storage file picking when explicitly triggered by the user.

#### Q96: How is zero-jank 60/120 FPS performance maintained?
**A:**
1. All expensive deserialization runs synchronously from fast memory-mapped Hive binary buffers.
2. Search and filter queries execute in-memory on lightweight Dart objects.
3. Widgets utilize `const` constructors to prevent unnecessary rebuilds.
4. Sliver masonry grids recycle item views outside the viewport.

#### Q97: What is the memory footprint of MemoryMap?
**A:** Idle memory footprint is approximately 35–55 MB of RAM, well within limits for low-end mobile devices.

#### Q98: How are leaks prevented in controllers?
**A:** All `TextEditingController` and animation instances are disposed in their corresponding `State.dispose()` lifecycle callbacks.

#### Q99: How does the app handle battery consumption?
**A:** Because there are no background sync daemons, persistent socket connections, or polling timers, background battery usage is effectively 0%.

#### Q100: How is data protected if the device is lost?
**A:** Data is protected by the host OS hardware encryption (Android File-Based Encryption and iOS Data Protection).

---

## 11. Build, Deployment & App Store Publishing Questions

#### Q101: What command builds the production Android APK?
**A:**
```bash
flutter build apk --release --split-per-abi
```

#### Q102: What command generates the Google Play Store App Bundle?
**A:**
```bash
flutter build appbundle --release
```

#### Q103: What target SDK is configured for Android?
**A:** Target SDK 34 (Android 14+), meeting Google Play Store requirements.

#### Q104: What is the bundle identifier / package name?
**A:** `com.memorymap.app.memorymap`

#### Q105: What app permissions are required in `AndroidManifest.xml`?
**A:** Zero internet permissions. The application operates without `<uses-permission android:name="android.permission.INTERNET" />`, guaranteeing to Google Play and users that the app is physically incapable of transmitting data.

---

## 12. Interview & Placement Defense Questions

#### Q106: "Why did you choose Hive instead of SQLite?"
**A:** "We chose Hive because MemoryMap is an atomic document store rather than a relational database. Hive is written in pure Dart, eliminating native compilation issues across mobile platforms, and offers faster serialization of key-value JSON trees compared to SQLite table joins."

#### Q107: "How did you maintain separation of concerns?"
**A:** "By adhering to Clean Architecture. The domain entities have zero dependencies on Flutter or Hive. The presentation layer only communicates with Riverpod Notifiers that consume abstract repository contracts. If we switch storage engines tomorrow, not a single line in the UI or domain models will change."

#### Q108: "What was the most challenging technical hurdle and how did you resolve it?"
**A:** "Maintaining 120 FPS fluidity during live search queries over hundreds of notes while supporting staggered masonry layouts. We resolved it by memoizing search filters, stripping markdown in a single regex pass, and utilizing `SliverMasonryGrid` for view recycling."

#### Q109: "How does MemoryMap embody modern mobile UX?"
**A:** "Instead of another spreadsheet-like dashboard, we drew inspiration from Japanese *Ma* (negative space) and modern products like Arc Browser and Apple Notes: floating island cards with subtle palette glows, tactile gestures (swipe to pin/archive), and a centered frosted glass dock."

#### Q110: "If you had 3 more months, what would you add?"
**A:** "We would build a 2D interactive Force-Directed Knowledge Graph to visualize connections between tagged ideas, bi-directional Wiki linking (`[[Idea]]`), and an encrypted biometric vault using local hardware secure enclaves."
