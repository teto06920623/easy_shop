import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/checkout_repository.dart';

class PayOrderUseCase implements UseCase<String?, String> {
  final CheckoutRepository repository;

  PayOrderUseCase(this.repository);

  @override
  Future<Result<String?>> call(String orderCode) {
    return repository.payOrder(orderCode);
  }
}
