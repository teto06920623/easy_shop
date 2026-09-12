class ProductEntity {
  final int id;
  final String name;
  final String slug;
  final double price;
  final int quantity;
  final int categoryId;
  final String? categoryName;
  final String? description;
  final bool isVisible;
  final String? imageUrl;
  final String? storeName;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.quantity,
    required this.categoryId,
    this.categoryName,
    this.description,
    this.isVisible = true,
    this.imageUrl,
    this.storeName,
    this.isFavorite = false,
  });

  ProductEntity copyWith({
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
    return ProductEntity(
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
