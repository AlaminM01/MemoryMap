import '../../domain/models/category.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_local_datasource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesLocalDataSource _localDataSource;

  CategoriesRepositoryImpl({CategoriesLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? CategoriesLocalDataSourceImpl();

  @override
  Future<List<Category>> getAllCategories() async {
    return await _localDataSource.getAllCategories();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    return await _localDataSource.getCategoryById(id);
  }

  @override
  Future<void> saveCategory(Category category) async {
    await _localDataSource.saveCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
  }

  @override
  Stream<List<Category>> watchCategories() async* {
    yield await _localDataSource.getAllCategories();
    await for (final _ in _localDataSource.watchCategoriesBox()) {
      yield await _localDataSource.getAllCategories();
    }
  }
}
