import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/models/note.dart';
import '../../domain/models/note_filter.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../services/storage_service.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl();
});

class NoteFilterNotifier extends Notifier<NoteFilter> {
  @override
  NoteFilter build() => const NoteFilter();

  void setFilter(NoteFilter filter) {
    state = filter;
  }

  void updateFilter(NoteFilter Function(NoteFilter) updateFn) {
    state = updateFn(state);
  }
}

final noteFilterProvider =
    NotifierProvider<NoteFilterNotifier, NoteFilter>(NoteFilterNotifier.new);

class GridViewNotifier extends Notifier<bool> {
  late final StorageService _storageService;

  @override
  bool build() {
    _storageService = StorageService();
    return _storageService.settingsBox.get(
      AppConstants.isGridViewKey,
      defaultValue: true,
    ) as bool;
  }

  void toggle() {
    state = !state;
    _storageService.settingsBox.put(AppConstants.isGridViewKey, state);
  }
}

final isGridViewProvider =
    NotifierProvider<GridViewNotifier, bool>(GridViewNotifier.new);

/// Reactive notes stream based on current filter
final filteredNotesProvider = StreamProvider<List<Note>>((ref) {
  final repo = ref.watch(notesRepositoryProvider);
  final filter = ref.watch(noteFilterProvider);
  return repo.watchNotes(filter);
});

/// All active notes (not trashed, not archived)
final allActiveNotesStreamProvider = StreamProvider<List<Note>>((ref) {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchNotes(const NoteFilter(section: NoteSection.all));
});

/// Smart Organization: Pinned Notes
final pinnedNotesProvider = Provider<List<Note>>((ref) {
  final notesAsync = ref.watch(allActiveNotesStreamProvider);
  return notesAsync.maybeWhen(
    data: (notes) => notes.where((n) => n.isPinned).toList(),
    orElse: () => [],
  );
});

/// Smart Organization: Recently Viewed Notes
final recentlyViewedNotesProvider = Provider<List<Note>>((ref) {
  final notesAsync = ref.watch(allActiveNotesStreamProvider);
  return notesAsync.maybeWhen(
    data: (notes) {
      final viewed = notes.where((n) => n.lastViewedAt != null).toList();
      viewed.sort((a, b) => b.lastViewedAt!.compareTo(a.lastViewedAt!));
      return viewed.take(5).toList();
    },
    orElse: () => [],
  );
});

/// Smart Organization: Recently Edited Notes
final recentlyEditedNotesProvider = Provider<List<Note>>((ref) {
  final notesAsync = ref.watch(allActiveNotesStreamProvider);
  return notesAsync.maybeWhen(
    data: (notes) {
      final list = List<Note>.from(notes);
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list.take(5).toList();
    },
    orElse: () => [],
  );
});

/// Notes Action Controller
class NotesNotifier extends AsyncNotifier<void> {
  late final NotesRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(notesRepositoryProvider);
  }

  Future<void> saveNote(Note note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveNote(note);
    });
  }

  Future<void> deleteNotePermanently(String id) async {
    state = await AsyncValue.guard(() async {
      await _repository.deleteNotePermanently(id);
    });
  }

  Future<void> togglePin(String id) async {
    await _repository.togglePinNote(id);
  }

  Future<void> toggleFavorite(String id) async {
    await _repository.toggleFavoriteNote(id);
  }

  Future<void> toggleArchive(String id) async {
    await _repository.toggleArchiveNote(id);
  }

  Future<void> moveToTrash(String id) async {
    await _repository.moveToTrash(id);
  }

  Future<void> restoreFromTrash(String id) async {
    await _repository.restoreFromTrash(id);
  }

  Future<void> emptyTrash() async {
    await _repository.emptyTrash();
  }

  Future<void> markNoteViewed(String id) async {
    await _repository.markNoteViewed(id);
  }
}

final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, void>(NotesNotifier.new);
