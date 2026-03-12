import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/api_provider.dart';
import '../models/category.dart';

part 'category_repository.g.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory(String name, {List<String>? subcategories});
  Future<Category> updateCategory(
    String id, {
    String? name,
    List<String>? subcategories,
  });
  Future<void> deleteCategory(String id);
  Future<Category> addSubcategory(String id, String subcategoryName);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepositoryImpl(this._apiClient);

  @override
  Future<List<Category>> getCategories() async {
    final response = await _apiClient.dio.get('categories');
    return (response.data as List).map((e) => Category.fromJson(e)).toList();
  }

  @override
  Future<Category> createCategory(
    String name, {
    List<String>? subcategories,
  }) async {
    final response = await _apiClient.dio.post(
      'categories',
      data: {'name': name, 'subcategories': ?subcategories},
    );
    return Category.fromJson(response.data);
  }

  @override
  Future<Category> updateCategory(
    String id, {
    String? name,
    List<String>? subcategories,
  }) async {
    final response = await _apiClient.dio.put(
      'categories/$id',
      data: {'name': ?name, 'subcategories': ?subcategories},
    );
    return Category.fromJson(response.data);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _apiClient.dio.delete('categories/$id');
  }

  @override
  Future<Category> addSubcategory(String id, String subcategoryName) async {
    final response = await _apiClient.dio.post(
      'categories/$id/subcategories',
      data: {'name': subcategoryName},
    );
    return Category.fromJson(response.data);
  }
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(apiClientProvider));
}
