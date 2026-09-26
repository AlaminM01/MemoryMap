import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/note.dart';
import '../../services/storage_service.dart';

abstract class NotesLocalDataSource {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(String id);
  Future<void> saveNote(Note note);
  Future<void> deleteNote(String id);
  Future<void> clearAllNotes();
  Stream<BoxEvent> watchNotesBox();
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final StorageService _storageService;

  NotesLocalDataSourceImpl({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Box<Map> get _box => _storageService.notesBox;

  @override
  Future<List<Note>> getAllNotes() async {
    final list = <Note>[];
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        try {
          final map = Map<String, dynamic>.from(data);
          list.add(Note.fromJson(map));
        } catch (_) {
          // ignore corrupted single entry
        }
      }
    }
    return list;
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return Note.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> saveNote(Note note) async {
    await _box.put(note.id, note.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAllNotes() async {
    await _box.clear();
  }

  @override
  Stream<BoxEvent> watchNotesBox() {
    return _box.watch();
  }
}
