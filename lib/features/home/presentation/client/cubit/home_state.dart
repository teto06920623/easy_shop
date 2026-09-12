import 'package:easy_shop/features/categories/data/models/category_model.dart';
import 'package:flutter/foundation.dart';
import '../../../../products/data/models/product_model.dart';

@immutable
abstract class ClientHomeState {}

class ClientHomeInitial extends ClientHomeState {}

class ClientHomeLoading extends ClientHomeState {}

class ClientHomeLoaded extends ClientHomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final int? selectedCategoryId;

  ClientHomeLoaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
  });

  ClientHomeLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    int? selectedCategoryId,
  }) {
    return ClientHomeLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class ClientHomeError extends ClientHomeState {
  final String message;
  ClientHomeError(this.message);
}

class ClientHomeActionSuccess extends ClientHomeState {
  final String message;
  ClientHomeActionSuccess(this.message);
}
