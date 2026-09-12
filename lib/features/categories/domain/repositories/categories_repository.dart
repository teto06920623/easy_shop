import '../../../../core/errors/result.dart';
import '../entities/category_entity.dart';

abstract class CategoriesRepository {
  Future<Result<List<CategoryEntity>>> getCategories({bool isAdmin = false});
  Future<Result<CategoryEntity>> createCategory({
    required String name,
    String? description,
  });
  Future<Result<CategoryEntity>> updateCategory({
    required String slug,
    required String name,
    String? description,
  });
  Future<Result<void>> deleteCategory(String slug);
}
