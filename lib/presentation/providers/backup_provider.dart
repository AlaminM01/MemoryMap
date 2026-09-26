import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/backup_repository_impl.dart';
import '../../domain/repositories/backup_repository.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepositoryImpl();
});

class BackupNotifier extends AsyncNotifier<String?> {
  late final BackupRepository _repository;

  @override
  FutureOr<String?> build() {
    _repository = ref.watch(backupRepositoryProvider);
    return null;
  }

  Future<String> exportJson() async {
    state = const AsyncValue.loading();
    try {
      final json = await _repository.exportBackupJson();
      state = const AsyncValue.data(null);
      return json;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<String> saveToFile() async {
    state = const AsyncValue.loading();
    try {
      final path = await _repository.saveBackupToFile();
      state = AsyncValue.data('Saved to: $path');
      return path;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<int> restoreFromFile(String path) async {
    state = const AsyncValue.loading();
    try {
      final count = await _repository.restoreFromFile(path);
      state = AsyncValue.data('Restored $count notes');
      return count;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> restoreFromJson(String json) async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.restoreFromJson(json);
      state = AsyncValue.data('Restored ${data.notes.length} notes');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> seedSampleData() async {
    state = const AsyncValue.loading();
    try {
      await _repository.seedSampleNotesIfEmpty();
      state = const AsyncValue.data('Sample notes seeded');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final backupNotifierProvider =
    AsyncNotifierProvider<BackupNotifier, String?>(BackupNotifier.new);
