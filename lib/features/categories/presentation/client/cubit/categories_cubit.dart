import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/create_category_usecase.dart';
import '../../../domain/usecases/delete_category_usecase.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/update_category_usecase.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoriesCubit({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoriesInitial());

  Future<void> getCategories({bool isAdmin = false}) async {
    emit(CategoriesLoading());

    final result = await getCategoriesUseCase(isAdmin);

    switch (result) {
      case Success(data: final categories):
        emit(CategoriesLoaded(categories: categories));
      case Err(failure: final failure):
        emit(CategoriesError(message: failure.message));
    }
  }

  Future<void> createCategory({
    required String name,
    String? description,
  }) async {
    emit(CategoriesLoading());

    final result = await createCategoryUseCase(
      CreateCategoryParams(name: name, description: description),
    );

    switch (result) {
      case Success():
        emit(CategoryActionSuccess(message: 'Category created successfully'));
        await getCategories(isAdmin: true);
      case Err(failure: final failure):
        emit(CategoriesError(message: failure.message));
    }
  }

  Future<void> updateCategory({
    required String slug,
    required String name,
    String? description,
  }) async {
    emit(CategoriesLoading());

    final result = await updateCategoryUseCase(
      UpdateCategoryParams(slug: slug, name: name, description: description),
    );

    switch (result) {
      case Success():
        emit(CategoryActionSuccess(message: 'Category updated successfully'));
        await getCategories(isAdmin: true);
      case Err(failure: final failure):
        emit(CategoriesError(message: failure.message));
    }
  }

  Future<void> deleteCategory(String slug) async {
    emit(CategoriesLoading());

    final result = await deleteCategoryUseCase(slug);

    switch (result) {
      case Success():
        emit(CategoryActionSuccess(message: 'Category deleted successfully'));
        await getCategories(isAdmin: true);
      case Err(failure: final failure):
        emit(CategoriesError(message: failure.message));
    }
  }
}
