import 'package:flutter/foundation.dart';
import '../../../domain/entities/order_response_entity.dart';

@immutable
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutOrderPlacedSuccess extends CheckoutState {
  final OrderResponseEntity order;
  CheckoutOrderPlacedSuccess({required this.order});
}

class CheckoutPaymentUrlReady extends CheckoutState {
  final String paymentUrl;
  final OrderResponseEntity order;
  CheckoutPaymentUrlReady({required this.paymentUrl, required this.order});
}

class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError({required this.message});
}
