<div align="center">

```
 __  __                                __  __             
|  \/  | ___ _ __ ___   ___  _ __ _   _|  \/  | __ _ _ __  
| |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | | |\/| |/ _` | '_ \ 
| |  | |  __/ | | | | | (_) | |  | |_| | |  | | (_| | |_) |
|_|  |_|\___|_| |_| |_|\___/|_|   \__, |_|  |_|\__,_| .__/ 
                                  |___/             |_|    
```

# MemoryMap 🧠
### *The Ambient Second Brain for Deep Thinkers & Creators*

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.4-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material 3](https://img.shields.io/badge/Material_3-Expressive-7C3AED?logo=materialdesign&logoColor=white)](https://m3.material.io)
[![Storage](https://img.shields.io/badge/Storage-Hive_Local_DB-FF6F00?logo=hive&logoColor=white)](https://pub.dev/packages/hive)
[![State](https://img.shields.io/badge/State-Riverpod_3-00B4D8)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-emerald)](LICENSE)
[![Offline](https://img.shields.io/badge/Offline-100%25_Private-green)](#offline-first-architecture)

<br/>

<p align="center">
  <b>A sanctuary for thoughts. Not another dashboard.</b><br/>
  MemoryMap bridges the tranquility of <i>Japanese Minimalist Design (Ma - 間)</i> with the fluid ergonomics of <i>Apple Notes</i>, <i>Arc Browser</i>, and <i>Obsidian</i>.
</p>

</div>

---

## ✦ The Vision: Why MemoryMap?

Typical productivity apps trap your thoughts inside rigid spreadsheet tables, cluttered multi-column dashboards, and heavy cloud subscriptions.

**MemoryMap is fundamentally different.**
- 🏝️ **Floating Note Islands**: Ideas exist as organic, floating physical islands rather than stiff database rows.
- 🧘 **Minimal Japanese Aesthetic (Ma - 間)**: Embraces deliberate negative space and serene typography to foster deep contemplation.
- ⚡ **100% Offline & Private**: Zero backend. Zero tracking. Zero cloud APIs. Your second brain is stored exclusively on your device hardware with lightning-fast Hive storage.
- 🎨 **Tri-Theme Precision**: Warm Rice Paper Light Mode, Smoked Slate Obsidian Dark Mode, and True `#000000` AMOLED Mode.

---

## 📸 Screenshots Showcase

<div align="center">

| Warm Rice Paper (Light) | Obsidian Slate (Dark) | Pitch Black (AMOLED) |
| :---: | :---: | :---: |
| *(Floating Islands & Dock)* | *(Smoked Glassmorphism)* | *(True #000000 OLED Saver)* |
| `[ 📱 Light Preview ]` | `[ 📱 Dark Preview ]` | `[ 📱 AMOLED Preview ]` |

| Markdown Studio | Instant Search Engine | Smart Mind Organization |
| :---: | :---: | :---: |
| *(Preview, Word & Read Time)* | *(Titles, Content & Tags)* | *(Pinned Thoughts & Recent)* |
| `[ 📝 Editor Preview ]` | `[ 🔍 Search Preview ]` | `[ 🧠 Mind Map Preview ]` |

</div>

---

## 🌟 Core Features

### 1. 🏝️ Floating Note Islands
- **Dynamic Island Color Palettes**: Choose from 6 organic tints (*Solar Amber, Aurora Indigo, Zen Emerald, Rose Petal, Lavender Dream, Neutral Glass*).
- **Tactile Gesture Interactions**:
  - **Swipe Right**: Toggle Pin with tactile feedback.
  - **Swipe Left**: One-touch Archive with Undo safety toast.
  - **Long Press**: Contextual bottom sheet for instant palette switching and quick triage.
- **Hero Transitions**: Smooth shared-element expansion when opening or closing notes.

### 2. 📁 Categories & Knowledge Folders
- Pre-configured defaults: **Personal**, **Study**, **Ideas**, **Work**, **Projects**.
- **Custom Category Studio**: Create infinite categories with tailored color swatches and bespoke Lucide icons.
- **Glowing Category Island Bar**: Horizontal scrollable pills with active indicators and count badges.

### 3. 🏷️ Multi-Tag Taxonomy
- Assign multiple tags per note (`#deep-work`, `#architecture`, `#reading`, `#zen`).
- Custom tag builder with vibrant tag color identifiers.
- Real-time tag filtration across your entire knowledge library.

### 4. 🔍 Instant Search Engine
- Sub-millisecond full-text search across titles, markdown content, and tag strings.
- Real-time result counter and dedicated zero-result calm state.

### 5. ❤️ Favorites & Smart Organization
- Instant star/heart favoriting.
- **Pinned to Mind Bar**: Sticky top-level thoughts that stay top of mind.
- **Recently Viewed & Recently Edited**: Adaptive carousels for fast cognitive retrieval.
- **Archive & Recycle Bin**: Non-destructive note management with restore and permanent empty controls.

### 6. 💾 Local JSON Backup & Knowledge Export
- **Export to JSON**: One-tap full database backup.
- **Restore from File**: Seamlessly import existing `.json` memory maps using native file pickers.
- **System Share Sheet**: Share your knowledge base via AirDrop, Bluetooth, Drive, or messaging apps.
- **Sample Knowledge Seeder**: Instantly populate curated atomic notes on first launch.

---

## 🏛️ Architecture & Engineering

MemoryMap follows strict **Clean Architecture** and the **Repository Pattern** powered by **Riverpod 3.0**:

```
                              ┌────────────────────────┐
                              │   Presentation Layer   │
                              │ (Screens, Docks, Cards)│
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │    Riverpod 3 State    │
                              │ (Notifiers & Streams)  │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │      Domain Layer      │
                              │ (Entities & Contracts) │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │       Data Layer       │
                              │ (Repositories & Hive)  │
                              └───────────┬────────────┘
                                          │
                                          ▼
                              ┌────────────────────────┐
                              │   Offline Hive Engine  │
                              │ (Key-Value Document DB)│
                              └────────────────────────┘
```

### Folder Structure
```
lib/
 ├── core/
 │    ├── constants/       # App metadata, keys, durations
 │    ├── errors/          # Functional failures & domain error models
 │    ├── extensions/      # BuildContext theme extensions
 │    ├── theme/           # AppColors, AppTypography, AppTheme (Light/Dark/AMOLED)
 │    └── utils/           # DateFormatter, TextUtils, PageTransitions
 ├── data/
 │    ├── datasources/     # Hive local box datasources (Notes, Categories, Tags)
 │    └── repositories/    # Clean implementations of domain contracts
 ├── domain/
 │    ├── models/          # Pure immutable entities (Note, Category, Tag, Filter)
 │    └── repositories/    # Abstract repository contracts
 ├── presentation/
 │    ├── providers/       # Riverpod 3 Notifiers (Notes, Categories, Tags, Theme, Backup)
 │    ├── screens/         # HomeScreen, NoteEditorScreen, SearchScreen, SettingsSheet
 │    └── widgets/         # SmartOrganizationBar, etc.
 ├── widgets/              # FloatingDock, NoteIslandCard, CategoryIslandBar, etc.
 ├── services/             # StorageService (Hive lifecycle & box compaction)
 └── main.dart             # App bootstrap, edge-to-edge system UI, ProviderScope
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.20.0` or stable channel)
- Dart SDK (`>= 3.10.0`)
- Android Studio / VS Code with Flutter extension
- Android SDK (API 34+) or Xcode (iOS 15+)

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AlaminM01/MemoryMap.git
   cd MemoryMap
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run unit tests**:
   ```bash
   flutter test --no-test-assets
   ```

4. **Launch application**:
   ```bash
   flutter run
   ```

---

## 📦 Production Build Instructions

### Android Release APK
To compile a standalone release APK:
```bash
flutter build apk --release --split-per-abi
```
The output binaries will be located at:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

### Android App Bundle (Google Play Store)
To compile an `.aab` bundle for the Google Play Store:
```bash
flutter build appbundle --release
```
The bundle will be generated at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 📋 Google Play Store & Apple App Store Checklist

- [x] **Material 3 Expressive Design**: Complies with latest Android design guidelines.
- [x] **Edge-to-Edge Experience**: Translucent status bar and system gesture navigation.
- [x] **Zero Cloud / Zero API Key**: No backend dependencies or external network requirements.
- [x] **Target SDK 34**: Meets Google Play Store target API level requirements.
- [x] **100% Free & Open**: Zero in-app purchases, zero ads, zero privacy disclosures needed.
- [x] **Data Safety Friendly**: No user data collected, transmitted, or shared.
- [x] **Adaptive Display**: Fully tested for phone, foldable, tablet, and portrait/landscape orientations.

---

## 🗺️ Future Roadmap

- [ ] Bi-directional Wiki links (`[[Note Name]]`)
- [ ] Graph visualization of interrelated ideas
- [ ] Local encrypted vault with biometric authentication (Fingerprint / FaceID)
- [ ] Desktop layout enhancements (macOS & Windows native shortcuts)
- [ ] Custom PDF export styling

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for details.

<div align="center">
  <sub>Crafted with passion for minimalist productivity. MemoryMap © 2026.</sub>
</div>
