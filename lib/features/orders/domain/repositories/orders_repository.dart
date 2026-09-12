import '../../../../core/errors/result.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Result<List<OrderEntity>>> getOrders({bool isAdmin = false});
  Future<Result<OrderEntity>> getOrderDetails(
    String code, {
    bool isAdmin = false,
  });
}
