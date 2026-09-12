import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/products_repository.dart';

class UpdateProductParams {
  final String slug;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final int categoryId;
  final bool isVisible;
  final String? imagePath;

  const UpdateProductParams({
    required this.slug,
    required this.name,
     this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.isVisible,
    this.imagePath,
  });
}

class UpdateProductUseCase
    implements UseCase<ProductEntity, UpdateProductParams> {
  final ProductsRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Result<ProductEntity>> call(UpdateProductParams params) {
    return repository.updateProduct(
      slug: params.slug,
      name: params.name,
      description: params.description ?? '',
      price: params.price,
      quantity: params.quantity,
      categoryId: params.categoryId,
      isVisible: params.isVisible,
      imagePath: params.imagePath,
    );
  }
}
