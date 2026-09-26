# MemoryMap 🧠 — Project Overview

> **Elevator Pitch**: MemoryMap is a modern, offline-first "Second Brain" application designed to help users capture ideas atomically, organize knowledge organically, and retrieve thoughts with sub-millisecond latency. Fusing the tranquility of **Japanese Minimalist Design (*Ma* - 間)** with the fluid ergonomics of **Apple Notes**, **Arc Browser**, and **Obsidian**, MemoryMap turns ideas into floating, physical "islands" rather than rigid spreadsheet rows.

---

## 1. Problem Statement
Knowledge workers, researchers, software engineers, and creative thinkers constantly face **cognitive fragmentation**:
1. **Spreadsheet Clutter**: Traditional note apps force thoughts into rigid tabular lists or dense card dashboards that induce mental fatigue.
2. **Cloud Vulnerabilities & Internet Dependence**: Most second brain tools (Notion, Roam, Evernote) require continuous internet connections, store unencrypted thoughts on centralized cloud servers, and suffer from loading spinners.
3. **Overcomplicated Setup**: Tools like Obsidian require complex plugin configurations, sync fees, and steep learning curves just to jot down quick atomic thoughts.
4. **Subscription Fatigue**: Users are forced into recurring monthly payments just to search, export, or color-code their personal notes.

---

## 2. The MemoryMap Solution
MemoryMap solves these problems through an ambient, zero-latency mobile experience:
- **Floating Note Islands**: Thoughts are presented as tactile, organic physical islands with customizable color tints (*Solar Amber, Aurora Indigo, Zen Emerald, Rose Petal, Lavender Dream, Neutral Glass*).
- **100% Offline-First Architecture**: Powered by a pure Dart key-value document store (Hive) operating directly on the device filesystem. No server, no account creation, no internet connection required.
- **Japanese Minimalist Aesthetic (*Ma* - 間)**: Generous intentional whitespace, gentle curved borders, Plus Jakarta Sans typography, and frosted glassmorphic navigation docks.
- **Sub-Millisecond Retrieval**: Zero-debounce full-text search indexing across titles, content, categories, and tags simultaneously.
- **Total Data Sovereignty**: Full JSON export/import and local file-based backup without cloud vendor lock-in.

---

## 3. Target Users
- **Creative Thinkers & Writers**: Who need a calm, distraction-free sanctuary to capture fleeting sparks of inspiration.
- **Software Developers & Architects**: Who document atomic system concepts, code snippets, and architecture decisions.
- **Students & Researchers**: Who require deep-work tag taxonomy, category grouping, and reading time analytics.
- **Privacy-Conscious Individuals**: Who refuse to upload personal journals and proprietary business ideas to remote cloud servers.

---

## 4. Key Features Matrix

| Category | Features |
| :--- | :--- |
| **Notes** | Full CRUD, Rich Markdown preview mode, 6 organic island palettes, live word count, reading time calculator, sticky pins, non-destructive archiving. |
| **Categories** | Pre-configured defaults (*Personal, Study, Ideas, Work, Projects*) + Custom Category Studio with icon and color picker. |
| **Tags** | Multi-tag assignment per note, custom tag creator, dynamic tag filtering with active state chips. |
| **Search Engine** | Instant sub-millisecond search across title, body text, and tags with real-time match counters. |
| **Smart Organization** | **Pinned to Mind Bar** (sticky ideas), **Recently Viewed Carousel**, **Recently Edited** cognitive retrieval. |
| **Backup & Export** | Offline JSON export, system share sheet, local file restore, and sample atomic note seeder. |
| **Themes** | Warm Rice Paper Light Theme (`#FBFBF9`), Obsidian Slate Dark Theme (`#0F1117`), True `#000000` AMOLED Mode. |
| **Ergonomics & Physics** | Swipe Right to Pin, Swipe Left to Archive, Long-press contextual action sheets, and Pull-to-Refresh with tactile haptic feedback. |

---

## 5. Technology Stack

- **Framework**: Flutter 3.47.5 (Channel stable, Material 3 Expressive)
- **Language**: Dart 3.13.4
- **State Management**: Riverpod 3.0 (`Notifier` and `AsyncNotifier` architecture)
- **Local Storage Engine**: Hive 2.2.3 + `hive_flutter` 1.1.0 (binary key-value document store)
- **Typography**: Google Fonts (`Plus Jakarta Sans`)
- **Iconography**: Lucide Icons 0.257.0
- **Animations**: `flutter_animate` 4.5.2 + Custom `FadeThroughPageRoute`
- **Grid Layout**: `flutter_staggered_grid_view` 0.7.0 (SliverMasonryGrid)
- **Platform Interop**: `path_provider`, `share_plus`, `file_picker`

---

## 6. Architecture & Data Flow

MemoryMap follows strict **Clean Architecture** and the **Repository Pattern**:

```
[ User Interaction ] ──> [ Presentation Layer ] ──> [ Riverpod 3 Notifiers ]
                                                            │
                                                            ▼
[ Local File System ] <── [ Hive Boxes ] <── [ Repositories & Data Sources ] <── [ Domain Models ]
```

1. **User Action**: The user edits a note, toggles a pin, or changes category.
2. **Provider Dispatch**: The screen triggers a method on `NotesNotifier` or updates `noteFilterProvider`.
3. **Domain & Repository**: `NotesRepositoryImpl` coordinates business logic and updates the underlying entity.
4. **Reactive Stream**: Hive box events trigger reactive stream yields, instantaneously updating all UI listeners without page reloads.

---

## 7. Knowledge Retrieval Workflow

1. **Top-Level Scanning**: The user views the **Pinned to Mind** bar and **Recently Viewed** carousel for instant high-frequency memory recall.
2. **Category Isolation**: Single-tap on glowing category capsules (*Personal, Study, Ideas, Work, Projects*) filters notes in memory.
3. **Cross-Domain Tagging**: Multi-tag selection narrows notes across distinct categories (e.g., `#deep-work` across both Work and Study).
4. **Full-Text Query**: The search engine tokenizes user input and matches titles, content bodies, and tag names in real-time.

---

## 8. Future Roadmap

- [ ] Bi-directional Wiki linking syntax (`[[Concept]]`).
- [ ] Interactive 2D Graph View of interrelated knowledge nodes.
- [ ] Biometric App Lock (FaceID / Fingerprint) for sensitive thoughts.
- [ ] Export notes to formatted PDF and Markdown archive folders.
