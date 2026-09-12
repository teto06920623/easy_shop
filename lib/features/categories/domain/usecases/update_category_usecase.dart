import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/categories_repository.dart';

class UpdateCategoryParams {
  final String slug;
  final String name;
  final String? description;

  const UpdateCategoryParams({
    required this.slug,
    required this.name,
    this.description,
  });
}

class UpdateCategoryUseCase
    implements UseCase<CategoryEntity, UpdateCategoryParams> {
  final CategoriesRepository repository;

  UpdateCategoryUseCase(this.repository);

  @override
  Future<Result<CategoryEntity>> call(UpdateCategoryParams params) {
    return repository.updateCategory(
      slug: params.slug,
      name: params.name,
      description: params.description,
    );
  }
}
