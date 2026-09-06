class ProductModel {
  final int id;
  final String title;
  final num price;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Product',
      price: json['price'] ?? 0,
      imageUrl: json['image'] ?? json['imageUrl'] ?? 'https://images.unsplash.com/photo-1584917865442-de89df76afd3',
    );
  }
}