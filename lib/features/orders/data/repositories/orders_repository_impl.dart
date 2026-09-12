

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<OrderModel>>> getOrders({bool isAdmin = false}) async {
    try {
      final orders = await remoteDataSource.getOrders(isAdmin: isAdmin);
      return Success(orders);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<OrderModel>> getOrderDetails(
    String code, {
    bool isAdmin = false,
  }) async {
    try {
      final order = await remoteDataSource.getOrderDetails(
        code,
        isAdmin: isAdmin,
      );
      return Success(order);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
