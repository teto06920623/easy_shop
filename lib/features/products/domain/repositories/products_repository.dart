import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/result.dart';

abstract class ProductsRepository {
  Future<Result<List<ProductEntity>>> getProducts({bool isAdmin = false});
  Future<Result<ProductEntity>> getProductDetails(
    String slug, {
    bool isAdmin = false,
  });
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  });
  Future<Result<ProductEntity>> updateProduct({
    required String slug,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  });
  Future<Result<void>> deleteProduct(String slug);
}
