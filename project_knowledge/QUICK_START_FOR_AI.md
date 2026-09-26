# MemoryMap - AI Quick Start Guide (Cheat Sheet)

> **Audience**: AI Assistants (ChatGPT, Claude, Gemini, Copilot, Antigravity) & Engineers  
> **Purpose**: Instant project ingestion (1-2 pages) to discuss, explain, debug, or extend MemoryMap without reading the entire repository.

---

## 1. Executive Summary
- **App Name**: MemoryMap
- **Tagline**: Minimalist Japanese *Ma*-Inspired "Second Brain" Notes Application
- **Platform**: Flutter (Android & iOS)
- **Design Philosophy**: Floating Note Islands, Generous Breathing Room (*Ma*), Soft Elevation, Zero Generic Dashboards
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: Flutter Riverpod 3.0 (`Notifier` & `AsyncNotifier` paradigm)
- **Persistence**: Hive (NoSQL, embedded binary key-value, 100% offline, zero cloud, zero backend)
- **Themes**: Tri-Theme Engine (Paper Light, Slate Dark, Pure `#000000` AMOLED)

---

## 2. Tech Stack & Key Libraries
| Dependency | Version | Purpose |
| :--- | :--- | :--- |
| `flutter` | `>=3.3.0` | Cross-platform UI toolkit with Material 3 |
| `flutter_riverpod` | `^3.0.0` | Declarative, compile-safe reactive state management |
| `hive_flutter` | `^1.1.0` | Ultra-fast local key-value document storage |
| `uuid` | `^4.5.1` | Cryptographically secure unique note ID generation |
| `intl` | `^0.20.2` | Date & timestamp formatting |
| `share_plus` | `^12.0.1` | Native OS sharing for notes and export archives |
| `file_picker` | `^13.0.0` | Local system file selection for JSON backup restoration |

---

## 3. Directory Map & Critical Files
```text
lib/
├── core/
│   ├── constants/       # app_colors.dart, app_strings.dart
│   ├── theme/           # app_theme.dart (Light, Dark, AMOLED ThemeData)
│   └── utils/           # date_formatter.dart
├── data/
│   ├── datasources/     # local/hive_helper.dart (Hive box initialization & compaction)
│   ├── models/          # note_hive_model.dart (TypeAdapter binary serialization)
│   ├── repositories/    # note_repository_impl.dart (CRUD operations)
│   └── services/        # backup_service.dart (JSON export/import engine)
├── domain/
│   ├── models/          # note_model.dart (Immutable entity), category_model.dart
│   └── repositories/    # note_repository.dart (Repository contract)
├── presentation/
│   ├── providers/       # notes_provider.dart, search_provider.dart, theme_provider.dart
│   ├── screens/         # home/, editor/, search/, settings/
│   └── widgets/         # note_card.dart, category_chip_bar.dart, tag_input_field.dart
└── main.dart            # Hive init, ProviderScope mount, runApp
```

---

## 4. Domain Data Model (`NoteModel`)
```dart
class NoteModel {
  final String id;              // UUID v4
  final String title;           // Note headline
  final String content;         // Note body content
  final String category;        // 'Personal' | 'Study' | 'Ideas' | 'Work' | 'Projects' | Custom
  final List<String> tags;      // Contextual keywords e.g. ['#draft', '#design']
  final bool isPinned;          // Floats to the top of list
  final bool isFavorite;        // Quick access star filter
  final bool isArchived;        // Hidden from main view, preserved in archive
  final DateTime createdAt;     // Creation timestamp
  final DateTime updatedAt;     // Last modified timestamp
}
```

---

## 5. State Management Blueprint (Riverpod 3.0)
- **`notesNotifierProvider`**: Manages the complete reactive note collection.
  - `loadNotes()`: Loads all notes from Hive box.
  - `createNote(NoteModel)` / `updateNote(NoteModel)` / `deleteNote(id)`: Atomic persistence + state refresh.
  - `togglePin(id)` / `toggleFavorite(id)` / `toggleArchive(id)`: Instant boolean flips.
- **`activeFilterProvider`**: Manages the selected category filter (`'All'` or category string).
- **`searchQueryProvider` & `searchResultsProvider`**:
  - In-memory substring matching across `title`, `content`, and `tags`.
  - Debounced at 300ms to eliminate UI stutter.
- **`themeNotifierProvider`**:
  - Manages `AppThemeMode` enum (`light`, `dark`, `amoled`).
  - Persists preference in Hive settings box across app restarts.

---

## 6. Backup & Restore JSON Schema
```json
{
  "version": 1,
  "exportedAt": "2026-09-26T19:00:00.000Z",
  "notes": [
    {
      "id": "uuid-v4",
      "title": "Clean Architecture Notes",
      "content": "Domain layer should have zero Flutter dependencies.",
      "category": "Study",
      "tags": ["architecture", "flutter"],
      "isPinned": true,
      "isFavorite": true,
      "isArchived": false,
      "createdAt": "2026-09-20T10:00:00.000Z",
      "updatedAt": "2026-09-25T14:30:00.000Z"
    }
  ]
}
```

---

## 7. How to Make Common Changes

### A. Adding a New Field to Notes
1. Add field to `lib/domain/models/note_model.dart` + update `copyWith`, `toJson`, `fromJson`.
2. Add `@HiveField(N)` in `lib/data/models/note_hive_model.dart`.
3. Update `NoteRepositoryImpl` mapping methods.
4. Run `flutter packages pub run build_runner build --delete-conflicting-outputs` if using generator, or update manual adapter.

### B. Adding a New Custom Color or Theme
1. Define colors in `lib/core/constants/app_colors.dart`.
2. Extend `AppTheme` in `lib/core/theme/app_theme.dart`.
3. Add enum variant in `theme_provider.dart` and expose in `SettingsScreen`.

---

## 8. Essential Developer Commands
- **Run App**: `flutter run`
- **Analyze Code**: `flutter analyze` *(Expected: 0 warnings, 0 errors)*
- **Run Tests**: `flutter test --no-test-assets` *(Flags required on restricted Windows policies)*
- **Build Release APK**: `flutter build apk --release`
- **Build App Bundle**: `flutter build appbundle --release`

---

## 9. AI Response Prompting Directive
When answering user inquiries about MemoryMap:
- Always enforce **Clean Architecture** boundaries (keep Domain independent of Flutter UI/Hive).
- Use **Riverpod 3.0** `Notifier` / `AsyncNotifier` syntax (avoid legacy `StateNotifierProvider`).
- Prioritize **offline data sovereignty** (no cloud, no Firebase, no tracking).
- Emphasize **Japanese *Ma*** minimalist aesthetics (breathing space, floating note islands, soft gradients).
