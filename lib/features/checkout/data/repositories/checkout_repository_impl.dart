import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/order_response_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_data_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<OrderResponseEntity>> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
  }) async {
    try {
      final order = await remoteDataSource.createOrder(
        productIds: productIds,
        quantities: quantities,
        prices: prices,
        address: address,
        latitude: latitude,
        longitude: longitude,
        paymentMethod: paymentMethod,
      );
      return Success(order);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<String?>> payOrder(String orderCode) async {
    try {
      final url = await remoteDataSource.payOrder(orderCode);
      return Success(url);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> processPayment({
    required double amount,
    required String orderCode,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final result = await remoteDataSource.processPayment(
        amount: amount,
        orderCode: orderCode,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
