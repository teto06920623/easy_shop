

import 'package:dio/dio.dart';
import '../../../../core/helpers/file_upload_helper.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({bool isAdmin = false});
  Future<ProductModel> getProductDetails(String slug, {bool isAdmin = false});
  Future<ProductModel> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  });
  Future<ProductModel> updateProduct({
    required String slug,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  });
  Future<void> deleteProduct(String slug);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<ProductModel>> getProducts({bool isAdmin = false}) async {
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
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductDetails(
    String slug, {
    bool isAdmin = false,
  }) async {
    final endpoint = isAdmin
        ? ApiConstants.adminProductDetails(slug)
        : ApiConstants.clientProductDetails(slug);

    final response = await dio.get(endpoint);
    final rawData = response.data;
    final productData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['product'] ?? rawData)
        : {};

    return ProductModel.fromJson(productData as Map<String, dynamic>);
  }

  @override
  Future<ProductModel> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    final imageFile = await FileUploadHelper.toMultipart(imagePath);

    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'visible': isVisible ? 1 : 0,
      if (imageFile != null) 'image': imageFile,
    });

    final response = await dio.post(
      ApiConstants.adminStoreProduct,
      data: formData,
    );

    final rawData = response.data;
    final productData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['product'] ?? rawData)
        : {};

    return ProductModel.fromJson(productData as Map<String, dynamic>);
  }

  @override
  Future<ProductModel> updateProduct({
    required String slug,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required bool isVisible,
    String? imagePath,
  }) async {
    final imageFile = await FileUploadHelper.toMultipart(imagePath);

    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'visible': isVisible ? 1 : 0,
      if (imageFile != null) 'image': imageFile,
    });

    final response = await dio.post(
      ApiConstants.adminUpdateProduct(slug),
      data: formData,
    );

    final rawData = response.data;
    final productData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['product'] ?? rawData)
        : {};

    return ProductModel.fromJson(productData as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProduct(String slug) async {
    await dio.delete(ApiConstants.adminDeleteProduct(slug));
  }
}
