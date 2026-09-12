import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders({bool isAdmin = false});
  Future<OrderModel> getOrderDetails(String code, {bool isAdmin = false});
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<List<OrderModel>> getOrders({bool isAdmin = false}) async {
    final endpoint = isAdmin
        ? ApiConstants.adminOrders
        : ApiConstants.clientOrders;
    final response = await dio.get(endpoint);

    final rawData = response.data;
    List items = [];

    if (rawData is Map<String, dynamic>) {
      items = rawData['data'] ?? rawData['orders'] ?? [];
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> getOrderDetails(
    String code, {
    bool isAdmin = false,
  }) async {
    final endpoint = isAdmin
        ? ApiConstants.adminOrderDetails(code)
        : ApiConstants.clientOrderDetails(code);

    final response = await dio.get(endpoint);
    final rawData = response.data;
    final orderData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['order'] ?? rawData)
        : {};

    return OrderModel.fromJson(orderData as Map<String, dynamic>);
  }
}
