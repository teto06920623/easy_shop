import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProductEntity> favorites; 
  FavoritesLoaded({required this.favorites});
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError({required this.message});
}
