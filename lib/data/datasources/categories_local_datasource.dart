import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/category.dart';
import '../../services/storage_service.dart';

abstract class CategoriesLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> seedDefaultCategoriesIfEmpty();
  Stream<BoxEvent> watchCategoriesBox();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  final StorageService _storageService;

  CategoriesLocalDataSourceImpl({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  Box<Map> get _box => _storageService.categoriesBox;

  @override
  Future<List<Category>> getAllCategories() async {
    await seedDefaultCategoriesIfEmpty();
    final list = <Category>[];
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        try {
          final map = Map<String, dynamic>.from(data);
          list.add(Category.fromJson(map));
        } catch (_) {}
      }
    }
    // Sort so defaults come first or ordered
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final data = _box.get(id);
    if (data == null) return null;
    return Category.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> saveCategory(Category category) async {
    await _box.put(category.id, category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> seedDefaultCategoriesIfEmpty() async {
    if (_box.isEmpty) {
      for (final cat in Category.defaultCategories) {
        await _box.put(cat.id, cat.toJson());
      }
    }
  }

  @override
  Stream<BoxEvent> watchCategoriesBox() {
    return _box.watch();
  }
}
