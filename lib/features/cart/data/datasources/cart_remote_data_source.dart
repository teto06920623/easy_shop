import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart({required int productId, required int quantity});
  Future<void> removeFromCart(int productId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final response = await dio.get(ApiConstants.clientCarts);
    final rawData = response.data;
    List items = [];

    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['carts'] ?? rawData['items'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    await dio.post(
      ApiConstants.clientStoreCart,
      data: {'product_id': productId, 'quantity': quantity},
    );
  }

  @override
  Future<void> removeFromCart(int productId) async {
    await dio.delete(
      ApiConstants.clientDeleteCart,
      data: {'product_id': productId},
    );
  }
}
