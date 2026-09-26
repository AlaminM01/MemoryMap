import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/categories_repository.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepositoryImpl();
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoriesRepositoryProvider);
  return repo.watchCategories();
});

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  late final CategoriesRepository _repository;

  @override
  FutureOr<List<Category>> build() {
    _repository = ref.watch(categoriesRepositoryProvider);
    return _repository.getAllCategories();
  }

  Future<void> saveCategory(Category category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveCategory(category);
      return await _repository.getAllCategories();
    });
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteCategory(id);
      return await _repository.getAllCategories();
    });
  }
}

final categoriesNotifierProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
  CategoriesNotifier.new,
);
