import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/order_response_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<OrderResponseModel> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod, 
  });

  Future<String?> payOrder(String orderCode);

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String orderCode,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<OrderResponseModel> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
  }) async {
    final response = await dio.post(
      ApiConstants.clientStoreOrder,
      data: {
        'product_id': productIds,
        'quantity': quantities,
        'price': prices,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'payment_method': paymentMethod,
      },
    );

    final rawData = response.data;
    final orderData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['order'] ?? rawData)
        : {};

    return OrderResponseModel.fromJson(orderData as Map<String, dynamic>);
  }

  @override
  Future<String?> payOrder(String orderCode) async {
    final response = await dio.post(ApiConstants.clientPayOrder(orderCode));
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      return rawData['payment_url']?.toString() ??
          rawData['url']?.toString() ??
          rawData['data']?['payment_url']?.toString();
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String orderCode,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final response = await dio.post(
      ApiConstants.clientProcessPayment,
      data: {
        'gateway_type': 'paymob',
        'amount': amount,
        'currency': 'EGP',
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
        'email': email,
        'code': orderCode,
      },
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : {'data': response.data};
  }
}
