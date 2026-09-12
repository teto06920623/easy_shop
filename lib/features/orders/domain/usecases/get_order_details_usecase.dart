import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailsParams {
  final String code;
  final bool isAdmin;

  const GetOrderDetailsParams({required this.code, this.isAdmin = false});
}

class GetOrderDetailsUseCase
    implements UseCase<OrderEntity, GetOrderDetailsParams> {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  @override
  Future<Result<OrderEntity>> call(GetOrderDetailsParams params) {
    return repository.getOrderDetails(params.code, isAdmin: params.isAdmin);
  }
}
