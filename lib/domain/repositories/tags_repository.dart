import '../models/tag.dart';

abstract class TagsRepository {
  Future<List<Tag>> getAllTags();
  Future<Tag?> getTagById(String id);
  Future<void> saveTag(Tag tag);
  Future<void> deleteTag(String id);
  Stream<List<Tag>> watchTags();
}
