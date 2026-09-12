import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/categories_repository.dart';

class CreateCategoryParams {
  final String name;
  final String? description;

  const CreateCategoryParams({required this.name, this.description});
}

class CreateCategoryUseCase
    implements UseCase<CategoryEntity, CreateCategoryParams> {
  final CategoriesRepository repository;

  CreateCategoryUseCase(this.repository);

  @override
  Future<Result<CategoryEntity>> call(CreateCategoryParams params) {
    return repository.createCategory(
      name: params.name,
      description: params.description,
    );
  }
}
