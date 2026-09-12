import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/get_order_details_usecase.dart';
import '../../../domain/usecases/get_orders_usecase.dart';
import 'admin_order_state.dart';

class AdminOrderCubit extends Cubit<AdminOrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  AdminOrderCubit({
    required this.getOrdersUseCase,
    required this.getOrderDetailsUseCase,
  }) : super(AdminOrderInitial());

  Future<void> fetchOrders() async {
    emit(AdminOrderLoading());
    final result = await getOrdersUseCase(true);

    switch (result) {
      case Success(data: final orders):
        emit(AdminOrderLoaded(orders));
      case Err(failure: final failure):
        emit(AdminOrderError(failure.message));
    }
  }

  Future<void> fetchOrderDetails(String code) async {
    emit(AdminOrderLoading());
    final result = await getOrderDetailsUseCase(
      GetOrderDetailsParams(code: code, isAdmin: true),
    );

    switch (result) {
      case Success(data: final order):
        emit(AdminOrderDetailsLoaded(order));
      case Err(failure: final failure):
        emit(AdminOrderError(failure.message));
    }
  }
}
