import '../models/category.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(String id);
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(String id);
  Stream<List<Category>> watchCategories();
}
