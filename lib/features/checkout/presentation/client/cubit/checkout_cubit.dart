import 'package:easy_shop/core/errors/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_order_usecase.dart';
import '../../../domain/usecases/pay_order_usecase.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateOrderUseCase createOrderUseCase;
  final PayOrderUseCase payOrderUseCase;

  CheckoutCubit({
    required this.createOrderUseCase,
    required this.payOrderUseCase,
  }) : super(CheckoutInitial());

  Future<void> submitOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
  }) async {
    emit(CheckoutLoading());

    final result = await createOrderUseCase(
      CreateOrderParams(
        productIds: productIds,
        quantities: quantities,
        prices: prices,
        address: address,
        latitude: latitude,
        longitude: longitude,
        paymentMethod: paymentMethod,
      ),
    );

    switch (result) {
      case Err(failure: final failure):
        emit(CheckoutError(message: failure.message));
      case Success(data: final order):
        if (paymentMethod == 'card') {
          final payResult = await payOrderUseCase(order.orderCode);

          switch (payResult) {
            case Success(data: final url):
              if (url != null && url.isNotEmpty) {
                emit(CheckoutPaymentUrlReady(paymentUrl: url, order: order));
              } else {
                emit(CheckoutOrderPlacedSuccess(order: order));
              }
            case Err():
              emit(CheckoutOrderPlacedSuccess(order: order));
          }
        } else {
          emit(CheckoutOrderPlacedSuccess(order: order));
        }
    }
  }
}
