import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, bool> {
  final CategoriesRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Result<List<CategoryEntity>>> call(bool isAdmin) {
    return repository.getCategories(isAdmin: isAdmin);
  }
}
