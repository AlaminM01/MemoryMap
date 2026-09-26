import 'package:flutter_test/flutter_test.dart';
import 'package:memorymap/core/utils/date_formatter.dart';
import 'package:memorymap/core/utils/text_utils.dart';
import 'package:memorymap/domain/models/category.dart';
import 'package:memorymap/domain/models/note.dart';
import 'package:memorymap/domain/models/note_filter.dart';
import 'package:memorymap/domain/models/tag.dart';
import 'package:memorymap/domain/repositories/backup_repository.dart';

void main() {
  group('MemoryMap Unit Tests', () {
    test('TextUtils calculates words and reading time accurately', () {
      const sample = 'MemoryMap is a modern second brain application for creative thinkers.';
      final words = TextUtils.countWords(sample);
      expect(words, 10);

      final readTime = TextUtils.calculateReadingTime(sample);
      expect(readTime, 1);
    });

    test('TextUtils strips markdown formatting cleanly', () {
      const md = '# Header\nThis is **bold** and *italic* text with [link](url).\n> A quote';
      final clean = TextUtils.stripMarkdown(md);
      expect(clean.contains('#'), false);
      expect(clean.contains('**'), false);
      expect(clean.contains('>'), false);
    });

    test('DateFormatter returns human readable relative times', () {
      final now = DateTime.now();
      expect(DateFormatter.formatNoteDate(now), 'Just now');

      final fiveMinsAgo = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.formatNoteDate(fiveMinsAgo), '5 mins ago');
    });

    test('Note serialization and copyWith works correctly', () {
      final note = Note(
        id: 'test_1',
        title: 'Quantum Computing',
        content: 'Exploration of qubits and superposition',
        categoryId: 'cat_study',
        tagIds: const ['tag_deep_work'],
        isPinned: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );

      final json = note.toJson();
      final reconstructed = Note.fromJson(json);

      expect(reconstructed.id, note.id);
      expect(reconstructed.title, note.title);
      expect(reconstructed.isPinned, true);
      expect(reconstructed.tagIds, contains('tag_deep_work'));

      final modified = note.copyWith(title: 'Quantum Information Theory');
      expect(modified.title, 'Quantum Information Theory');
      expect(modified.id, note.id);
    });

    test('Default categories and tags are properly configured', () {
      final defaultCats = Category.defaultCategories;
      expect(defaultCats.length, greaterThanOrEqualTo(5));
      expect(defaultCats.any((c) => c.name == 'Personal'), true);
      expect(defaultCats.any((c) => c.name == 'Ideas'), true);
      expect(defaultCats.any((c) => c.name == 'Projects'), true);

      final defaultTags = Tag.defaultTags;
      expect(defaultTags.length, greaterThanOrEqualTo(5));
      expect(defaultTags.any((t) => t.name == 'deep-work'), true);
    });

    test('NoteFilter correctly identifies active filters', () {
      const emptyFilter = NoteFilter();
      expect(emptyFilter.hasActiveFilter, false);

      final searchFilter = emptyFilter.copyWith(searchQuery: 'zen');
      expect(searchFilter.hasActiveFilter, true);

      final catFilter = emptyFilter.copyWith(selectedCategoryId: () => 'cat_work');
      expect(catFilter.hasActiveFilter, true);

      final tagFilter = emptyFilter.copyWith(selectedTagIds: {'tag_urgent'});
      expect(tagFilter.hasActiveFilter, true);
    });

    test('BackupData correctly roundtrips serialization', () {
      final note = Note(
        id: 'note_1',
        title: 'Arch Note',
        content: 'Clean architecture design',
        categoryId: 'cat_projects',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 2),
      );
      final cat = Category(
        id: 'cat_custom',
        name: 'Custom',
        colorValue: 0xFF6366F1,
        iconName: 'folder',
        createdAt: DateTime(2026, 1, 1),
      );
      final tag = Tag(
        id: 'tag_custom',
        name: 'test',
        colorValue: 0xFF10B981,
        createdAt: DateTime(2026, 1, 1),
      );

      final backup = BackupData(
        version: 1,
        exportedAt: DateTime(2026, 2, 1),
        notes: [note],
        categories: [cat],
        tags: [tag],
      );

      final json = backup.toJson();
      final reconstructed = BackupData.fromJson(json);

      expect(reconstructed.notes.length, 1);
      expect(reconstructed.notes.first.title, 'Arch Note');
      expect(reconstructed.categories.length, 1);
      expect(reconstructed.tags.length, 1);
    });
  });
}
