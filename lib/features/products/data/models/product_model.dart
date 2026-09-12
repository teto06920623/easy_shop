import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';


class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.price,
    required super.quantity,
    required super.categoryId,
    super.categoryName,
    super.description,
    super.isVisible = true,
    super.imageUrl,
    super.storeName,
    super.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    
    String? categoryName;
    if (json['category'] is Map<String, dynamic>) {
      categoryName = json['category']['name']?.toString();
    } else if (json['category_name'] != null) {
      categoryName = json['category_name'].toString();
    }

    
    String? storeName;
    if (json['admin'] is Map<String, dynamic>) {
      storeName =
          json['admin']['business_name']?.toString() ??
          json['admin']['name']?.toString();
    } else if (json['store_name'] != null) {
      storeName = json['store_name'].toString();
    }

    
    bool isVisible = true;
    if (json['visible'] != null) {
      if (json['visible'] is bool) {
        isVisible = json['visible'];
      } else if (json['visible'] is num) {
        isVisible = json['visible'] == 1;
      }
    }

    return ProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: categoryName,
      description: json['description']?.toString(),
      isVisible: isVisible,
      imageUrl: _buildImageUrl(json['image_url'] ?? json['image']),
      storeName: storeName,
      isFavorite: json['is_favorite'] == true,
    );
  }

  static String? _buildImageUrl(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    if (s.startsWith('http')) return s;
    if (s.startsWith('/')) return 'https://easylearn.devawy.com$s';
    return 'https://easylearn.devawy.com/storage/$s';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'price': price,
      'quantity': quantity,
      'category_id': categoryId,
      'description': description,
      'visible': isVisible ? 1 : 0,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
    };
  }

  @override
  ProductModel copyWith({
    int? id,
    String? name,
    String? slug,
    double? price,
    int? quantity,
    int? categoryId,
    String? categoryName,
    String? description,
    bool? isVisible,
    String? imageUrl,
    String? storeName,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      isVisible: isVisible ?? this.isVisible,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
