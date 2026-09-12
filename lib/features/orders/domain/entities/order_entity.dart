class OrderItemEntity {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final String? image;

  const OrderItemEntity({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    this.image,
  });
}

class OrderEntity {
  final int id;
  final String code;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final String address;
  final String createdAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
    required this.items,
  });
}
