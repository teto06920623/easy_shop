

import 'package:easy_shop/core/errors/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/cart_repository.dart';
import '../../../data/models/cart_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({required this.cartRepository}) : super(CartInitial());

  List<CartItemModel> _currentItems = [];

  double get subtotal => _currentItems.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  double get total => subtotal;

  Future<void> getCartItems() async {
    if (isClosed) return;
    emit(CartLoading());

    final result = await cartRepository.getCartItems();

    if (isClosed) return; 

    switch (result) {
      case Success(data: final items):
        _currentItems = items;
        emit(
          CartLoaded(
            items: List.from(_currentItems),
            subtotal: subtotal,
            total: total,
          ),
        );
      case Err(failure: final failure):
        emit(CartError(message: failure.message));
    }
  }

  Future<void> addToCart({required int productId, int quantity = 1}) async {
    if (isClosed) return;
    emit(CartLoading());

    final result = await cartRepository.addToCart(
      productId: productId,
      quantity: quantity,
    );

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(CartActionSuccess(message: 'Item added to cart!'));
        await getCartItems();
      case Err(failure: final failure):
        emit(CartError(message: failure.message));
    }
  }

  Future<void> removeFromCart(int productId) async {
    if (isClosed) return;

    _currentItems.removeWhere((item) => item.productId == productId);

    emit(
      CartLoaded(
        items: List.from(_currentItems),
        subtotal: subtotal,
        total: total,
      ),
    );

    final result = await cartRepository.removeFromCart(productId);

    if (isClosed) return;

    switch (result) {
      case Success():
        emit(CartActionSuccess(message: 'Item removed from cart!'));
      case Err(failure: final failure):
        emit(CartError(message: failure.message));
        await getCartItems();
    }
  }

  Future<void> updateQuantity({
    required int productId,
    required int newQuantity,
  }) async {
    if (newQuantity < 1) return;

    final index = _currentItems.indexWhere(
      (item) => item.productId == productId,
    );

    if (index != -1) {
      _currentItems[index] = _currentItems[index].copyWith(
        quantity: newQuantity,
      );
      emit(
        CartLoaded(
          items: List.from(_currentItems),
          subtotal: subtotal,
          total: total,
        ),
      );
    }

    final result = await cartRepository.addToCart(
      productId: productId,
      quantity: newQuantity,
    );

    switch (result) {
      case Success():
        break;
      case Err(failure: final failure):
        emit(CartError(message: failure.message));
        await getCartItems();
    }
  }
}
