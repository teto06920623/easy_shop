import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase implements UseCase<List<OrderEntity>, bool> {
  final OrdersRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Result<List<OrderEntity>>> call(bool isAdmin) {
    return repository.getOrders(isAdmin: isAdmin);
  }
}
