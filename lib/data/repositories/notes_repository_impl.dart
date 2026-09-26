import 'dart:async';
import '../../domain/models/note.dart';
import '../../domain/models/note_filter.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource _localDataSource;

  NotesRepositoryImpl({NotesLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? NotesLocalDataSourceImpl();

  @override
  Future<List<Note>> getAllNotes() async {
    return await _localDataSource.getAllNotes();
  }

  @override
  Future<Note?> getNoteById(String id) async {
    return await _localDataSource.getNoteById(id);
  }

  @override
  Future<void> saveNote(Note note) async {
    await _localDataSource.saveNote(note);
  }

  @override
  Future<void> deleteNotePermanently(String id) async {
    await _localDataSource.deleteNote(id);
  }

  @override
  Future<void> togglePinNote(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      await _localDataSource.saveNote(
        note.copyWith(
          isPinned: !note.isPinned,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> toggleFavoriteNote(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      await _localDataSource.saveNote(
        note.copyWith(
          isFavorite: !note.isFavorite,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> toggleArchiveNote(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      final willArchive = !note.isArchived;
      await _localDataSource.saveNote(
        note.copyWith(
          isArchived: willArchive,
          // If archived, unpin
          isPinned: willArchive ? false : note.isPinned,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> moveToTrash(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      await _localDataSource.saveNote(
        note.copyWith(
          isTrashed: true,
          isPinned: false,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> restoreFromTrash(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      await _localDataSource.saveNote(
        note.copyWith(
          isTrashed: false,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> emptyTrash() async {
    final allNotes = await _localDataSource.getAllNotes();
    for (final note in allNotes) {
      if (note.isTrashed) {
        await _localDataSource.deleteNote(note.id);
      }
    }
  }

  @override
  Future<void> markNoteViewed(String id) async {
    final note = await _localDataSource.getNoteById(id);
    if (note != null) {
      await _localDataSource.saveNote(
        note.copyWith(lastViewedAt: DateTime.now()),
      );
    }
  }

  @override
  Stream<List<Note>> watchNotes(NoteFilter filter) async* {
    // Initial emission
    yield _filterAndSortNotes(await _localDataSource.getAllNotes(), filter);

    // Watch hive box changes
    await for (final _ in _localDataSource.watchNotesBox()) {
      yield _filterAndSortNotes(await _localDataSource.getAllNotes(), filter);
    }
  }

  List<Note> _filterAndSortNotes(List<Note> allNotes, NoteFilter filter) {
    var filtered = allNotes.where((note) {
      // Handle sections
      switch (filter.section) {
        case NoteSection.all:
          if (note.isTrashed || note.isArchived) return false;
          break;
        case NoteSection.favorites:
          if (note.isTrashed || note.isArchived || !note.isFavorite) return false;
          break;
        case NoteSection.archived:
          if (note.isTrashed || !note.isArchived) return false;
          break;
        case NoteSection.trash:
          if (!note.isTrashed) return false;
          break;
      }

      // Pin filter
      if (filter.onlyPinned && !note.isPinned) return false;

      // Category filter
      if (filter.selectedCategoryId != null &&
          note.categoryId != filter.selectedCategoryId) {
        return false;
      }

      // Tags filter (must contain all selected tags)
      if (filter.selectedTagIds.isNotEmpty) {
        final noteTagSet = note.tagIds.toSet();
        if (!filter.selectedTagIds.every((tagId) => noteTagSet.contains(tagId))) {
          return false;
        }
      }

      // Search Query filter (matches title, content, or tag names)
      if (filter.searchQuery.trim().isNotEmpty) {
        final query = filter.searchQuery.trim().toLowerCase();
        final titleMatch = note.title.toLowerCase().contains(query);
        final contentMatch = note.content.toLowerCase().contains(query);
        if (!titleMatch && !contentMatch) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort notes
    filtered.sort((a, b) {
      // Pinned notes always surface first in 'all' section
      if (filter.section == NoteSection.all) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
      }

      switch (filter.sortBy) {
        case NoteSortBy.updatedAtDesc:
          return b.updatedAt.compareTo(a.updatedAt);
        case NoteSortBy.updatedAtAsc:
          return a.updatedAt.compareTo(b.updatedAt);
        case NoteSortBy.createdAtDesc:
          return b.createdAt.compareTo(a.createdAt);
        case NoteSortBy.createdAtAsc:
          return a.createdAt.compareTo(b.createdAt);
        case NoteSortBy.titleAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case NoteSortBy.titleDesc:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
    });

    return filtered;
  }
}
