import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AdminHomeState {}

class AdminHomeInitial extends AdminHomeState {}

class AdminHomeLoading extends AdminHomeState {}

class AdminHomeLoaded extends AdminHomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;

  AdminHomeLoaded({required this.categories, required this.products});
}

class AdminHomeError extends AdminHomeState {
  final String message;
  AdminHomeError(this.message);
}
