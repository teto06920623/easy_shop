import 'package:easy_shop/core/errors/result.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:easy_shop/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_home_state.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  AdminHomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(AdminHomeInitial());

  Future<void> fetchDashboardData() async {
    emit(AdminHomeLoading());

    try {
      final results = await Future.wait([
        getCategoriesUseCase(true),
        getProductsUseCase(true),
      ]);

      final categoriesResult = results[0] as Result<List<CategoryEntity>>;
      final productsResult = results[1] as Result<List<ProductEntity>>;

      List<CategoryEntity> categories = [];
      List<ProductEntity> products = [];

      if (categoriesResult is Success<List<CategoryEntity>>) {
        categories = categoriesResult.data;
      }
      if (productsResult is Success<List<ProductEntity>>) {
        products = productsResult.data;
      }

      emit(AdminHomeLoaded(categories: categories, products: products));
    } catch (e) {
      emit(AdminHomeError(e.toString()));
    }
  }
}
