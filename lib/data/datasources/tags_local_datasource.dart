import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/tag.dart';
import '../../services/storage_service.dart';

abstract class TagsLocalDataSource {
  Future<List<Tag>> getAllTags();
  Future<Tag?> getTagById(String id);
  Future<void> saveTag(Tag tag);
  Future<void> deleteTag(String id);
  Future<void> seedDefaultTagsIfEmpty();
  Stream<BoxEvent> watchTagsBox();
}

class TagsLocalDataSourceImpl implements TagsLocalDataSource {
  final StorageService _storageService;

  TagsLocalDataSourceImpl({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Box<Map> get _box => _storageService.tagsBox;

  @override
  Future<List<Tag>> getAllTags() async {
    await seedDefaultTagsIfEmpty();
    final list = <Tag>[];
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        try {
          final map = Map<String, dynamic>.from(data);
          list.add(Tag.fromJson(map));
        } catch (_) {}
      }
    }
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  @override
  Future<Tag?> getTagById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return Tag.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> saveTag(Tag tag) async {
    await _box.put(tag.id, tag.toJson());
  }

  @override
  Future<void> deleteTag(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> seedDefaultTagsIfEmpty() async {
    if (_box.isEmpty) {
      for (final tag in Tag.defaultTags) {
        await _box.put(tag.id, tag.toJson());
      }
    }
  }

  @override
  Stream<BoxEvent> watchTagsBox() {
    return _box.watch();
  }
}
