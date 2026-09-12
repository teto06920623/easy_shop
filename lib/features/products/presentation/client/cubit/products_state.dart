import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  ProductsLoaded({required this.products});
}

class ProductDetailsLoaded extends ProductsState {
  final ProductEntity product;
  ProductDetailsLoaded({required this.product});
}

class ProductActionSuccess extends ProductsState {
  final String message;
  ProductActionSuccess({required this.message});
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError({required this.message});
}
