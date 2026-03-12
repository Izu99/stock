import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/category.dart';
import '../../data/repositories/category_repository.dart';

part 'category_provider.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  FutureOr<List<Category>> build() {
    return ref.watch(categoryRepositoryProvider).getCategories();
  }

  Future<void> addCategory(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(categoryRepositoryProvider).createCategory(name);
      return ref.read(categoryRepositoryProvider).getCategories();
    });
  }

  Future<void> addSubcategory(String categoryId, String subcategoryName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(categoryRepositoryProvider)
          .addSubcategory(categoryId, subcategoryName);
      return ref.read(categoryRepositoryProvider).getCategories();
    });
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(categoryRepositoryProvider).deleteCategory(id);
      return ref.read(categoryRepositoryProvider).getCategories();
    });
  }

  Future<void> updateCategory(
    String id, {
    String? name,
    List<String>? subcategories,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(categoryRepositoryProvider)
          .updateCategory(id, name: name, subcategories: subcategories);
      return ref.read(categoryRepositoryProvider).getCategories();
    });
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
