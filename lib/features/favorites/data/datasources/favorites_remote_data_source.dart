import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../products/data/models/product_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<void> addFavorite(int productId);
  Future<void> removeFavorite(int productId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<ProductModel>> getFavorites() async {
    final response = await dio.get(ApiConstants.clientFavorites);
    final rawData = response.data;
    List items = [];

    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['favorites'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .map((item) {
          final productData =
              item is Map<String, dynamic> && item.containsKey('product')
              ? item['product']
              : item;
          return ProductModel.fromJson(
            productData as Map<String, dynamic>,
          ).copyWith(isFavorite: true);
        })
        .where((product) => product.isVisible) 
        .toList();
  }

  @override
  Future<void> addFavorite(int productId) async {
    await dio.post(
      ApiConstants.clientStoreFavorite,
      data: {'product_id': productId},
    );
  }

  @override
  Future<void> removeFavorite(int productId) async {
    await dio.delete(
      ApiConstants.clientDeleteFavorite,
      data: {'product_id': productId},
    );
  }
}
