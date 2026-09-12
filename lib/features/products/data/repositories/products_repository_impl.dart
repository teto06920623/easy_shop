import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<ProductEntity>>> getProducts({
    bool isAdmin = false,
  }) async {
    try {
      final result = await remoteDataSource.getProducts(isAdmin: isAdmin);
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<ProductEntity>> getProductDetails(
    String slug, {
    bool isAdmin = false,
  }) async {
    try {
      final result = await remoteDataSource.getProductDetails(
        slug,
        isAdmin: isAdmin,
      );
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    try {
      final result = await remoteDataSource.createProduct(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        isVisible: isVisible,
        imagePath: imagePath,
      );
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<ProductEntity>> updateProduct({
    required String slug,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    try {
      final result = await remoteDataSource.updateProduct(
        slug: slug,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        isVisible: isVisible,
        imagePath: imagePath,
      );
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> deleteProduct(String slug) async {
    try {
      await remoteDataSource.deleteProduct(slug);
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
