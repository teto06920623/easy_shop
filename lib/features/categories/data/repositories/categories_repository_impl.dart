

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/helpers/secure_storage_helper.dart'; 
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<CategoryEntity>>> getCategories({
    bool isAdmin = false,
  }) async {
    try {
      final result = await remoteDataSource.getCategories(isAdmin: isAdmin);

      if (!isAdmin) {
        return Success(result);
      }

      final adminId = await SecureStorageHelper.getUserId();
      if (adminId == null) {
        return const Success([]);
      }

      final mySlugs = await SecureStorageHelper.getMerchantCategorySlugs(
        adminId,
      );
      final myCategories = result
          .where((cat) => mySlugs.contains(cat.slug))
          .toList();

      return Success(myCategories);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<CategoryEntity>> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final result = await remoteDataSource.createCategory(
        name: name,
        description: description,
      );

      final adminId = await SecureStorageHelper.getUserId();
      if (adminId != null) {
        await SecureStorageHelper.addMerchantCategorySlug(adminId, result.slug);
      }

      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<CategoryEntity>> updateCategory({
    required String slug,
    required String name,
    String? description,
  }) async {
    try {
      final result = await remoteDataSource.updateCategory(
        slug: slug,
        name: name,
        description: description,
      );
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> deleteCategory(String slug) async {
    try {
      await remoteDataSource.deleteCategory(slug);

      final adminId = await SecureStorageHelper.getUserId();
      if (adminId != null) {
        await SecureStorageHelper.removeMerchantCategorySlug(adminId, slug);
      }

      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
