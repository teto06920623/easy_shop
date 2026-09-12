import '../../domain/entities/order_response_entity.dart';

class OrderResponseModel extends OrderResponseEntity {
  const OrderResponseModel({
    required super.id,
    required super.orderCode,
    required super.totalPrice,
    required super.status,
    required super.paymentMethod,
    super.paymentUrl,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode:
          json['code']?.toString() ??
          json['order_code']?.toString() ??
          json['id']?.toString() ??
          '',
      totalPrice: json['total_price'] is num
          ? (json['total_price'] as num).toDouble()
          : double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      paymentMethod: json['payment_method']?.toString() ?? 'cash',
      paymentUrl:
          json['payment_url']?.toString() ??
          json['iframe_url']?.toString() ??
          json['redirect_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': orderCode,
      'total_price': totalPrice,
      'status': status,
      'payment_method': paymentMethod,
      'payment_url': paymentUrl,
    };
  }
}
