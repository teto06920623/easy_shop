import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/products_repository.dart';

class CreateProductParams {
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final int categoryId;
  final bool isVisible;
  final String? imagePath;

  const CreateProductParams({
    required this.name,
     this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.isVisible,
    this.imagePath,
  });
}

class CreateProductUseCase
    implements UseCase<ProductEntity, CreateProductParams> {
  final ProductsRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Result<ProductEntity>> call(CreateProductParams params) {
    return repository.createProduct(
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
