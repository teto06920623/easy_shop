import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/get_order_details_usecase.dart';
import '../../../domain/usecases/get_orders_usecase.dart';
import 'client_order_state.dart';

class ClientOrderCubit extends Cubit<ClientOrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  ClientOrderCubit({
    required this.getOrdersUseCase,
    required this.getOrderDetailsUseCase,
  }) : super(ClientOrderInitial());

  Future<void> fetchOrders() async {
    emit(ClientOrderLoading());
    final result = await getOrdersUseCase(false);

    switch (result) {
      case Success(data: final orders):
        emit(ClientOrderLoaded(orders));
      case Err(failure: final failure):
        emit(ClientOrderError(failure.message));
    }
  }

  Future<void> fetchOrderDetails(String code) async {
    emit(ClientOrderLoading());
    final result = await getOrderDetailsUseCase(
      GetOrderDetailsParams(code: code, isAdmin: false),
    );

    switch (result) {
      case Success(data: final order):
        emit(ClientOrderDetailsLoaded(order));
      case Err(failure: final failure):
        emit(ClientOrderError(failure.message));
    }
  }
}
