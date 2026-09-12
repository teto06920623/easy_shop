import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/products_repository.dart';

class DeleteProductUseCase implements UseCase<void, String> {
  final ProductsRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Result<void>> call(String slug) {
    return repository.deleteProduct(slug);
  }
}
