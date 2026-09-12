import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../products/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories({required bool isAdmin});
  Future<List<ProductModel>> getProducts({required bool isAdmin});
  Future<void> toggleFavorite({required int productId, required bool isFav});
  Future<void> addToCart({required int productId, required int quantity});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<CategoryModel>> getCategories({required bool isAdmin}) async {
    final endpoint = isAdmin
        ? ApiConstants.adminCategories
        : ApiConstants.clientCategories;
    final response = await dio.get(endpoint);
    final rawData = response.data;
    List items = [];
    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['categories'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }
    return items
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getProducts({required bool isAdmin}) async {
    final endpoint = isAdmin
        ? ApiConstants.adminProducts
        : ApiConstants.clientProducts;
    final response = await dio.get(endpoint);
    final rawData = response.data;
    List items = [];
    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['products'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }
    return items
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> toggleFavorite({
    required int productId,
    required bool isFav,
  }) async {
    if (isFav) {
      await dio.delete(
        ApiConstants.clientDeleteFavorite,
        data: {'product_id': productId},
      );
    } else {
      await dio.post(
        ApiConstants.clientStoreFavorite,
        data: {'product_id': productId},
      );
    }
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
}
