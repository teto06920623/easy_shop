import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.productName,
    required super.quantity,
    required super.price,
    super.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productName:
          json['product_name']?.toString() ??
          json['name']?.toString() ??
          json['product']?['name']?.toString() ??
          'Product',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image']?.toString() ?? json['product']?['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.code,
    required super.status,
    required super.totalPrice,
    required super.paymentMethod,
    required super.address,
    required super.createdAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List rawItems = [];
    if (json['items'] is List) {
      rawItems = json['items'];
    } else if (json['order_items'] is List) {
      rawItems = json['order_items'];
    } else if (json['products'] is List) {
      rawItems = json['products'];
    }

    return OrderModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code:
          json['code']?.toString() ??
          json['order_code']?.toString() ??
          '#${json['id'] ?? ''}',
      status: json['status']?.toString() ?? 'Pending',
      totalPrice: json['total_price'] is num
          ? (json['total_price'] as num).toDouble()
          : double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method']?.toString() ?? 'Cash',
      address: json['address']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      items: rawItems
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'status': status,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'address': address,
      'created_at': createdAt,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
    };
  }
}
