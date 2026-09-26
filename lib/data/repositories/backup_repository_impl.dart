import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/models/category.dart';
import '../../domain/models/note.dart';
import '../../domain/models/tag.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../services/storage_service.dart';
import '../datasources/categories_local_datasource.dart';
import '../datasources/notes_local_datasource.dart';
import '../datasources/tags_local_datasource.dart';

class BackupRepositoryImpl implements BackupRepository {
  final NotesLocalDataSource _notesDataSource;
  final CategoriesLocalDataSource _categoriesDataSource;
  final TagsLocalDataSource _tagsDataSource;
  final StorageService _storageService;

  BackupRepositoryImpl({
    NotesLocalDataSource? notesDataSource,
    CategoriesLocalDataSource? categoriesDataSource,
    TagsLocalDataSource? tagsDataSource,
    StorageService? storageService,
  })  : _notesDataSource = notesDataSource ?? NotesLocalDataSourceImpl(),
        _categoriesDataSource = categoriesDataSource ?? CategoriesLocalDataSourceImpl(),
        _tagsDataSource = tagsDataSource ?? TagsLocalDataSourceImpl(),
        _storageService = storageService ?? StorageService();

  @override
  Future<String> exportBackupJson() async {
    final notes = await _notesDataSource.getAllNotes();
    final categories = await _categoriesDataSource.getAllCategories();
    final tags = await _tagsDataSource.getAllTags();

    final backup = BackupData(
      version: 1,
      exportedAt: DateTime.now(),
      notes: notes,
      categories: categories,
      tags: tags,
    );

    return const JsonEncoder.withIndent('  ').convert(backup.toJson());
  }

  @override
  Future<BackupData> restoreFromJson(String jsonContent) async {
    final Map<String, dynamic> map = jsonDecode(jsonContent);
    final backup = BackupData.fromJson(map);

    // Save categories
    for (final category in backup.categories) {
      await _categoriesDataSource.saveCategory(category);
    }

    // Save tags
    for (final tag in backup.tags) {
      await _tagsDataSource.saveTag(tag);
    }

    // Save notes
    for (final note in backup.notes) {
      await _notesDataSource.saveNote(note);
    }

    return backup;
  }

  @override
  Future<String> saveBackupToFile() async {
    final jsonStr = await exportBackupJson();
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'memorymap_backup_${DateFormatter.formatBackupDate(DateTime.now())}.json';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(jsonStr);
    return file.path;
  }

  @override
  Future<int> restoreFromFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }
    final content = await file.readAsString();
    final backup = await restoreFromJson(content);
    return backup.notes.length;
  }

  @override
  Future<void> seedSampleNotesIfEmpty() async {
    final existingNotes = await _notesDataSource.getAllNotes();
    final hasSeeded = _storageService.settingsBox.get(
      AppConstants.hasSeededSampleDataKey,
      defaultValue: false,
    ) as bool;

    if (existingNotes.isNotEmpty || hasSeeded) return;

    final now = DateTime.now();

    final sampleNotes = [
      Note(
        id: 'note_welcome',
        title: 'Welcome to MemoryMap 🧠',
        content: '''# Welcome to Your Second Brain

MemoryMap is crafted for thinkers, creators, and builders who need a sanctuary for their thoughts.

### Key Philosophies
- **Offline First**: All your data lives securely in local storage on your device.
- **Island Architecture**: Notes live as organic floating islands rather than stiff spreadsheets.
- **Instant Retrieval**: Fast search across titles, contents, categories, and tags.

> "Your mind is for having ideas, not holding them." — David Allen

Try creating your first note by tapping the **+** button in the floating dock below!''',
        categoryId: 'cat_personal',
        tagIds: ['tag_deep_work', 'tag_zen'],
        isPinned: true,
        isFavorite: true,
        colorIndex: 1, // Soft amber island
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
        lastViewedAt: now,
      ),
      Note(
        id: 'note_obsidian_principles',
        title: 'Atomic Knowledge & Bi-Directional Notes',
        content: '''## Principles of Personal Knowledge Management (PKM)

1. **Keep concepts atomic**: One note should capture one coherent idea.
2. **Tag intentionally**: Use tags to connect ideas across disparate domains (e.g. psychology + software).
3. **Review iteratively**: Pin your active thoughts and archive old ones to keep your mental workspace clutter-free.

### Next Actions:
- [x] Configure MemoryMap categories
- [ ] Connect ideas between Work and Projects
- [ ] Weekly review on Sunday evenings''',
        categoryId: 'cat_study',
        tagIds: ['tag_architecture', 'tag_reading'],
        isPinned: true,
        isFavorite: false,
        colorIndex: 2, // Indigo island
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        lastViewedAt: now.subtract(const Duration(minutes: 45)),
      ),
      Note(
        id: 'note_product_ideas',
        title: 'Minimalist Ambient Soundscape Engine',
        content: '''High concept for an ambient generative music synthesizer:
- Generates procedural rainfall, distant thunder, and Japanese temple bells.
- Controlled via subtle gyroscope tilting of the phone.
- Seamless loop with zero audio pops.
- Color palette: Charcoal, Rice paper, Warm bamboo.''',
        categoryId: 'cat_ideas',
        tagIds: ['tag_urgent', 'tag_deep_work'],
        isPinned: false,
        isFavorite: true,
        colorIndex: 3, // Purple island
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Note(
        id: 'note_clean_architecture',
        title: 'Clean Architecture & Riverpod Synergy',
        content: '''Notes on Clean Architecture implementation:
- **Domain Layer**: Independent from any external framework or database. Pure entities & contracts.
- **Data Layer**: Concrete datasources (Hive local key-value store) and repository implementations.
- **Presentation Layer**: StateNotifier / Riverpod providers managing pure immutable states.
- Zero dependencies on cloud servers. Instant load times!''',
        categoryId: 'cat_projects',
        tagIds: ['tag_architecture'],
        isPinned: false,
        isFavorite: false,
        colorIndex: 4, // Rose island
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Note(
        id: 'note_zen_quote',
        title: 'Ma (間) — The Art of Negative Space',
        content: '''In Japanese aesthetics, "Ma" refers to a pause in time, an interval or emptiness in space.

It is not merely empty space, but space that gives shape and resonance to the objects within it. When designing digital tools, allowing generous breathing room around ideas gives the mind serenity to contemplate.''',
        categoryId: 'cat_personal',
        tagIds: ['tag_zen'],
        isPinned: false,
        isFavorite: true,
        colorIndex: 5, // Sage green island
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];

    for (final note in sampleNotes) {
      await _notesDataSource.saveNote(note);
    }

    await _storageService.settingsBox.put(AppConstants.hasSeededSampleDataKey, true);
  }
}
