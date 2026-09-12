import 'package:flutter/foundation.dart';
import '../../../domain/entities/order_entity.dart';

@immutable
abstract class ClientOrderState {}

class ClientOrderInitial extends ClientOrderState {}

class ClientOrderLoading extends ClientOrderState {}

class ClientOrderLoaded extends ClientOrderState {
  final List<OrderEntity> orders;
  ClientOrderLoaded(this.orders);
}

class ClientOrderDetailsLoaded extends ClientOrderState {
  final OrderEntity order;
  ClientOrderDetailsLoaded(this.order);
}

class ClientOrderError extends ClientOrderState {
  final String message;
  ClientOrderError(this.message);
}