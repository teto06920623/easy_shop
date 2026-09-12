import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/products_repository.dart';

class GetProductDetailsParams {
  final String slug;
  final bool isAdmin;

  const GetProductDetailsParams({required this.slug, this.isAdmin = false});
}

class GetProductDetailsUseCase
    implements UseCase<ProductEntity, GetProductDetailsParams> {
  final ProductsRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Result<ProductEntity>> call(GetProductDetailsParams params) {
    return repository.getProductDetails(params.slug, isAdmin: params.isAdmin);
  }
}
