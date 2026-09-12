import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/create_product_usecase.dart';
import '../../../domain/usecases/delete_product_usecase.dart';
import '../../../domain/usecases/get_product_details_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/update_product_usecase.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductsCubit({
    required this.getProductsUseCase,
    required this.getProductDetailsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductsInitial());

  Future<void> getProducts({bool isAdmin = false}) async {
    emit(ProductsLoading());

    final result = await getProductsUseCase(isAdmin);

    switch (result) {
      case Success(data: final products):
        emit(ProductsLoaded(products: products));
      case Err(failure: final failure):
        emit(ProductsError(message: failure.message));
    }
  }

  Future<void> getProductDetails(String slug, {bool isAdmin = false}) async {
    emit(ProductsLoading());

    final result = await getProductDetailsUseCase(
      GetProductDetailsParams(slug: slug, isAdmin: isAdmin),
    );

    switch (result) {
      case Success(data: final product):
        emit(ProductDetailsLoaded(product: product));
      case Err(failure: final failure):
        emit(ProductsError(message: failure.message));
    }
  }

  Future<void> createProduct({
    required String name,
    String? description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    emit(ProductsLoading());

    final result = await createProductUseCase(
      CreateProductParams(
        name: name,
        description: description ?? '',
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        isVisible: isVisible,
        imagePath: imagePath,
      ),
    );

    switch (result) {
      case Success():
        emit(ProductActionSuccess(message: 'Product created successfully'));
        await getProducts(isAdmin: true);
      case Err(failure: final failure):
        emit(ProductsError(message: failure.message));
    }
  }

  Future<void> updateProduct({
    required String slug,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    emit(ProductsLoading());

    final result = await updateProductUseCase(
      UpdateProductParams(
        slug: slug,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        isVisible: isVisible,
        imagePath: imagePath,
      ),
    );

    switch (result) {
      case Success():
        emit(ProductActionSuccess(message: 'Product updated successfully'));
        await getProducts(isAdmin: true);
      case Err(failure: final failure):
        emit(ProductsError(message: failure.message));
    }
  }

  Future<void> deleteProduct(String slug) async {
    emit(ProductsLoading());

    final result = await deleteProductUseCase(slug);

    switch (result) {
      case Success():
        emit(ProductActionSuccess(message: 'Product deleted successfully'));
        await getProducts(isAdmin: true);
      case Err(failure: final failure):
        emit(ProductsError(message: failure.message));
    }
  }
}
