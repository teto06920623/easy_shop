import 'package:flutter/foundation.dart';
import '../../../domain/entities/order_entity.dart';

@immutable
abstract class AdminOrderState {}

class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrderLoaded extends AdminOrderState {
  final List<OrderEntity> orders;
  AdminOrderLoaded(this.orders);
}

class AdminOrderDetailsLoaded extends AdminOrderState {
  final OrderEntity order;
  AdminOrderDetailsLoaded(this.order);
}

class AdminOrderError extends AdminOrderState {
  final String message;
  AdminOrderError(this.message);
}
