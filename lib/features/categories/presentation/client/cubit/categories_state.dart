import 'package:flutter/foundation.dart';
import '../../../domain/entities/category_entity.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryEntity> categories;
  CategoriesLoaded({required this.categories});
}

class CategoryActionSuccess extends CategoriesState {
  final String message;
  CategoryActionSuccess({required this.message});
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError({required this.message});
}
