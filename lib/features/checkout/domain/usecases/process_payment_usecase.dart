import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/checkout_repository.dart';

class ProcessPaymentParams {
  final double amount;
  final String orderCode;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const ProcessPaymentParams({
    required this.amount,
    required this.orderCode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}

class ProcessPaymentUseCase
    implements UseCase<Map<String, dynamic>, ProcessPaymentParams> {
  final CheckoutRepository repository;

  ProcessPaymentUseCase(this.repository);

  @override
  Future<Result<Map<String, dynamic>>> call(ProcessPaymentParams params) {
    return repository.processPayment(
      amount: params.amount,
      orderCode: params.orderCode,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
    );
  }
}
