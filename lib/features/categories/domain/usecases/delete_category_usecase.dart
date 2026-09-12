import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/categories_repository.dart';

class DeleteCategoryUseCase implements UseCase<void, String> {
  final CategoriesRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Result<void>> call(String slug) {
    return repository.deleteCategory(slug);
  }
}
