class OrderResponseEntity {
  final int id;
  final String orderCode;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final String? paymentUrl;

  const OrderResponseEntity({
    required this.id,
    required this.orderCode,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    this.paymentUrl,
  });
}
