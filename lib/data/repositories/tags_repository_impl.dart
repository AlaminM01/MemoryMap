import '../../domain/models/tag.dart';
import '../../domain/repositories/tags_repository.dart';
import '../datasources/tags_local_datasource.dart';

class TagsRepositoryImpl implements TagsRepository {
  final TagsLocalDataSource _localDataSource;

  TagsRepositoryImpl({TagsLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? TagsLocalDataSourceImpl();

  @override
  Future<List<Tag>> getAllTags() async {
    return await _localDataSource.getAllTags();
  }

  @override
  Future<Tag?> getTagById(String id) async {
    return await _localDataSource.getTagById(id);
  }

  @override
  Future<void> saveTag(Tag tag) async {
    await _localDataSource.saveTag(tag);
  }

  @override
  Future<void> deleteTag(String id) async {
    await _localDataSource.deleteTag(id);
  }

  @override
  Stream<List<Tag>> watchTags() async* {
    yield await _localDataSource.getAllTags();
    await for (final _ in _localDataSource.watchTagsBox()) {
      yield await _localDataSource.getAllTags();
    }
  }
}
