import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_response_entity.dart';
import '../repositories/checkout_repository.dart';

class CreateOrderParams {
  final List<int> productIds;
  final List<int> quantities;
  final List<double> prices;
  final String address;
  final double latitude;
  final double longitude;
  final String paymentMethod;

  const CreateOrderParams({
    required this.productIds,
    required this.quantities,
    required this.prices,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethod,
  });
}

class CreateOrderUseCase
    implements UseCase<OrderResponseEntity, CreateOrderParams> {
  final CheckoutRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Result<OrderResponseEntity>> call(CreateOrderParams params) {
    return repository.createOrder(
      productIds: params.productIds,
      quantities: params.quantities,
      prices: params.prices,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      paymentMethod: params.paymentMethod,
    );
  }
}
