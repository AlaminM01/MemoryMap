# MemoryMap 🧠 — System Architecture & Diagrams

This document illustrates the technical design, data flows, component relationships, and user journeys of MemoryMap using **Mermaid.js** diagrams.

---

## 1. Clean Architecture Layer Hierarchy

The application is structured into four decoupled layers adhering to the Dependency Inversion Principle:

```mermaid
flowchart TD
    subgraph UI_Layer ["Presentation Layer (Flutter & Riverpod 3)"]
        UI_Screens["Screens: HomeScreen, NoteEditorScreen, SearchScreen, SettingsSheet"]
        UI_Widgets["Widgets: NoteIslandCard, FloatingDock, CategoryIslandBar, SmartOrgBar"]
        UI_Providers["Riverpod 3: NotesNotifier, NoteFilterNotifier, ThemeNotifier, BackupNotifier"]
    end

    subgraph Domain_Layer ["Domain Layer (Pure Dart)"]
        Domain_Models["Entities: Note, Category, Tag, NoteFilter, BackupData"]
        Domain_Repos["Contracts: NotesRepository, CategoriesRepository, TagsRepository, BackupRepository"]
        Domain_Failures["Failures: StorageFailure, BackupFailure, ValidationFailure"]
    end

    subgraph Data_Layer ["Data Layer (Concrete Implementations)"]
        Data_Repos["Implementations: NotesRepositoryImpl, CategoriesRepositoryImpl, BackupRepositoryImpl"]
        Data_Sources["DataSources: NotesLocalDataSource, CategoriesLocalDataSource, TagsLocalDataSource"]
    end

    subgraph Storage_Engine ["Storage Layer (Hive Local Engine)"]
        Hive_Notes["Box: memorymap_notes_box"]
        Hive_Categories["Box: memorymap_categories_box"]
        Hive_Tags["Box: memorymap_tags_box"]
        Hive_Settings["Box: memorymap_settings_box"]
    end

    UI_Screens --> UI_Widgets
    UI_Widgets --> UI_Providers
    UI_Providers --> Domain_Repos
    UI_Providers --> Domain_Models
    Data_Repos --> Domain_Repos
    Data_Repos --> Data_Sources
    Data_Sources --> Storage_Engine
```

---

## 2. Reactive Data Flow & Stream Pipeline

How data streams reactively from local disk to the user interface upon changes:

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant UI as HomeScreen / NoteIslandCard
    participant Filter as NoteFilterNotifier
    participant Provider as filteredNotesProvider
    participant Repo as NotesRepositoryImpl
    participant DataSource as NotesLocalDataSourceImpl
    participant Hive as HiveBox (memorymap_notes_box)

    User->>UI: Selects 'Study' Category Chip
    UI->>Filter: updateFilter(selectedCategoryId = 'cat_study')
    Filter-->>Provider: Notifies filter state change
    Provider->>Repo: watchNotes(activeFilter)
    Repo->>DataSource: getAllNotes()
    DataSource->>Hive: Reads cached key-value maps
    Hive-->>DataSource: Returns Raw Map Entries
    DataSource-->>Repo: Returns List<Note>
    Repo->>Repo: Filters & sorts notes in-memory
    Repo-->>Provider: Yields List<Note>
    Provider-->>UI: Updates SliverMasonryGrid reactively
```

---

## 3. Note Creation & Persistence Lifecycle

Execution trace of writing and saving an atomic note:

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Editor as NoteEditorScreen
    participant Notifier as NotesNotifier (Riverpod)
    participant Repo as NotesRepositoryImpl
    participant DataSource as NotesLocalDataSourceImpl
    participant Hive as HiveBox (Notes Box)

    User->>Editor: Types Idea Title & Content
    Editor->>Editor: Recalculates words & read time in real-time
    User->>Editor: Swatches 'Zen Emerald' palette (#3)
    User->>Editor: Hits 'Done' or swipes back (PopScope)
    Editor->>Notifier: saveNote(updatedNote)
    Notifier->>Repo: saveNote(note)
    Repo->>DataSource: saveNote(note)
    DataSource->>Hive: box.put(note.id, note.toJson())
    Hive-->>DataSource: Write completed & fsync
    Hive->>DataSource: box.watch() fires BoxEvent
    DataSource->>Repo: Triggers reactive watchNotes stream
    Repo-->>Editor: Navigator.pop(context)
```

---

## 4. Component Interaction Diagram

How presentation components collaborate within `HomeScreen`:

```mermaid
flowchart LR
    subgraph Home_Screen ["HomeScreen Viewport"]
        Header["Header: Large Typography & Actions"]
        SmartBar["SmartOrganizationBar: Pinned Ideas"]
        RecentCarousel["Recently Viewed Notes Carousel"]
        CategoryBar["CategoryIslandBar: Horizontal Pills"]
        IslandGrid["SliverMasonryGrid: Floating Note Islands"]
        Dock["FloatingDock: Frosted Glass Nav Capsule"]
    end

    Header -->|Toggle Layout| IslandGrid
    CategoryBar -->|Selects Category| IslandGrid
    SmartBar -->|Opens Pinned Note| NoteEditor["NoteEditorScreen"]
    RecentCarousel -->|Recalls Recent Note| NoteEditor
    IslandGrid -->|Hero Transition| NoteEditor
    Dock -->|Taps Center +| NoteEditor
    Dock -->|Taps Search| SearchScreen["SearchScreen"]
    Dock -->|Taps More| SettingsSheet["SettingsSheet"]
```

---

## 5. User Journey & Navigation State Flow

States and routes traversable by the user:

```mermaid
flowchart TD
    Start([App Cold Launch]) --> InitCheck{First Launch?}
    InitCheck -- Yes --> SeedData[Seed Default Categories & 5 Sample Atomic Notes]
    InitCheck -- No --> LoadBoxes[Open Local Hive Boxes]
    SeedData --> LoadBoxes
    LoadBoxes --> HomeScreen[Display HomeScreen Canvas]

    HomeScreen -->|Tap + Button| EditorNew[NoteEditorScreen: New Idea]
    HomeScreen -->|Tap Note Island| EditorEdit[NoteEditorScreen: Edit Note]
    HomeScreen -->|Tap Search| SearchScreen[SearchScreen: Instant Retrieval]
    HomeScreen -->|Tap Settings| SettingsSheet[SettingsSheet: Preferences & Backup]

    HomeScreen -->|Swipe Right on Card| PinAction[Toggle Sticky Pin]
    HomeScreen -->|Swipe Left on Card| ArchiveAction[Move to Archive + Undo Toast]
    HomeScreen -->|Long Press Card| QuickMenu[Quick Actions & Palette Picker]

    SettingsSheet -->|Export JSON| ShareSheet[OS Native Share Sheet]
    SettingsSheet -->|Import JSON| FilePicker[Local File Picker]
    SettingsSheet -->|Toggle AMOLED| AMOLEDMode[Apply #000000 Pitch Black]

    EditorNew -->|PopScope on Back| SaveNote[Auto-Save Note to Hive]
    EditorEdit -->|PopScope on Back| SaveNote
    SaveNote --> HomeScreen
```

---

## 6. Offline Data Model Topology

Entity relationships inside MemoryMap's domain:

```mermaid
classDiagram
    class Note {
        +String id
        +String title
        +String content
        +String categoryId
        +List~String~ tagIds
        +bool isPinned
        +bool isFavorite
        +bool isArchived
        +bool isTrashed
        +int colorIndex
        +DateTime createdAt
        +DateTime updatedAt
        +DateTime lastViewedAt
        +int wordCount
        +int readingTimeMinutes
        +String preview
        +copyWith()
        +toJson()
        +fromJson()
    }

    class Category {
        +String id
        +String name
        +int colorValue
        +String iconName
        +bool isDefault
        +DateTime createdAt
        +toJson()
        +fromJson()
    }

    class Tag {
        +String id
        +String name
        +int colorValue
        +DateTime createdAt
        +toJson()
        +fromJson()
    }

    class NoteFilter {
        +String searchQuery
        +String selectedCategoryId
        +Set~String~ selectedTagIds
        +NoteSection section
        +NoteSortBy sortBy
        +bool onlyPinned
        +bool hasActiveFilter
    }

    Category "1" -- "0..*" Note : groups
    Tag "0..*" -- "0..*" Note : classifies
    NoteFilter ..> Note : filters
```
