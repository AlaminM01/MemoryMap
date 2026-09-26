import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/tags_repository_impl.dart';
import '../../domain/models/tag.dart';
import '../../domain/repositories/tags_repository.dart';

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepositoryImpl();
});

final tagsStreamProvider = StreamProvider<List<Tag>>((ref) {
  final repo = ref.watch(tagsRepositoryProvider);
  return repo.watchTags();
});

class TagsNotifier extends AsyncNotifier<List<Tag>> {
  late final TagsRepository _repository;

  @override
  FutureOr<List<Tag>> build() {
    _repository = ref.watch(tagsRepositoryProvider);
    return _repository.getAllTags();
  }

  Future<void> saveTag(Tag tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveTag(tag);
      return await _repository.getAllTags();
    });
  }

  Future<void> deleteTag(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTag(id);
      return await _repository.getAllTags();
    });
  }
}

final tagsNotifierProvider =
    AsyncNotifierProvider<TagsNotifier, List<Tag>>(TagsNotifier.new);
