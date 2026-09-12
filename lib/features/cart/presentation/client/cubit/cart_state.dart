import 'package:flutter/foundation.dart';
import '../../../data/models/cart_item_model.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double subtotal;
  final double total;

  CartLoaded({
    required this.items,
    required this.subtotal,
    required this.total,
  });
}

class CartActionSuccess extends CartState {
  final String message;
  CartActionSuccess({required this.message});
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});
}
