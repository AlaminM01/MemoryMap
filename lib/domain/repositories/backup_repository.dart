import '../models/note.dart';
import '../models/category.dart';
import '../models/tag.dart';

class BackupData {
  final int version;
  final DateTime exportedAt;
  final List<Note> notes;
  final List<Category> categories;
  final List<Tag> tags;

  const BackupData({
    required this.version,
    required this.exportedAt,
    required this.notes,
    required this.categories,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.toIso8601String(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      version: json['version'] as int? ?? 1,
      exportedAt: json['exportedAt'] != null
          ? DateTime.parse(json['exportedAt'] as String)
          : DateTime.now(),
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => Note.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }
}

abstract class BackupRepository {
  Future<String> exportBackupJson();
  Future<BackupData> restoreFromJson(String jsonContent);
  Future<String> saveBackupToFile();
  Future<int> restoreFromFile(String filePath);
  Future<void> seedSampleNotesIfEmpty();
}
