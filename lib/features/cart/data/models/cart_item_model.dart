import '../../../products/data/models/product_model.dart';

class CartItemModel {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final ProductModel? product;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    ProductModel? prod;
    if (json['product'] is Map<String, dynamic>) {
      prod = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
    }

    return CartItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id']?.toString() ?? '0') ??
                (prod?.id ?? 0),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: json['price'] != null
          ? (double.tryParse(json['price'].toString()) ?? prod?.price ?? 0.0)
          : (prod?.price ?? 0.0),
      product: prod,
    );
  }

  CartItemModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? price,
    ProductModel? product,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      if (product != null) 'product': product!.toJson(),
    };
  }
}
