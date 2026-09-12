

import '../../../../core/errors/result.dart';
import '../../data/models/cart_item_model.dart';

abstract class CartRepository {
  Future<Result<List<CartItemModel>>> getCartItems();
  Future<Result<void>> addToCart({
    required int productId,
    required int quantity,
  });
  Future<Result<void>> removeFromCart(int productId);
}
