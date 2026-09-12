import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories({bool isAdmin = false});
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
  });
  Future<CategoryModel> updateCategory({
    required String slug,
    required String name,
    String? description,
  });
  Future<void> deleteCategory(String slug);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<CategoryModel>> getCategories({bool isAdmin = false}) async {
    final endpoint = isAdmin
        ? ApiConstants.adminCategories
        : ApiConstants.clientCategories;
    final response = await dio.get(endpoint);

    final rawData = response.data;
    List items = [];

    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['categories'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CategoryModel> createCategory({
    required String name,
    String? description,
  }) async {
    final response = await dio.post(
      ApiConstants.adminStoreCategory,
      data: {'name': name, 'description': description ?? ''},
    );

    final rawData = response.data;
    final categoryData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData)
        : {};
    return CategoryModel.fromJson(categoryData);
  }

  @override
  Future<CategoryModel> updateCategory({
    required String slug,
    required String name,
    String? description,
  }) async {
    final response = await dio.put(
      ApiConstants.adminUpdateCategory(slug),
      data: {'name': name, 'description': description ?? ''},
    );

    final rawData = response.data;
    final categoryData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData)
        : {};
    return CategoryModel.fromJson(categoryData);
  }

  @override
  Future<void> deleteCategory(String slug) async {
    await dio.delete(ApiConstants.adminDeleteCategory(slug));
  }
}
