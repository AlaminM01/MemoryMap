import '../models/note.dart';
import '../models/note_filter.dart';

abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(String id);
  Future<void> saveNote(Note note);
  Future<void> deleteNotePermanently(String id);
  Future<void> togglePinNote(String id);
  Future<void> toggleFavoriteNote(String id);
  Future<void> toggleArchiveNote(String id);
  Future<void> moveToTrash(String id);
  Future<void> restoreFromTrash(String id);
  Future<void> emptyTrash();
  Future<void> markNoteViewed(String id);
  Stream<List<Note>> watchNotes(NoteFilter filter);
}
