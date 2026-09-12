import '../../../../core/errors/result.dart';
import '../entities/order_response_entity.dart';

abstract class CheckoutRepository {
  Future<Result<OrderResponseEntity>> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
  });

  Future<Result<String?>> payOrder(String orderCode);

  Future<Result<Map<String, dynamic>>> processPayment({
    required double amount,
    required String orderCode,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
}
