import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase implements UseCase<List<ProductEntity>, bool> {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Result<List<ProductEntity>>> call(bool isAdmin) {
    return repository.getProducts(isAdmin: isAdmin);
  }
}
