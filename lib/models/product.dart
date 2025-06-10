import 'package:shoes_store_app/models/product_size.dart';
import 'image_product.dart';

class Product {
  Product({
    required this.id,
    required this.brandId,
    required this.name,
    required this.price,
    required this.listImageProduct,
    required this.listProductSize,
    required this.description,
    required this.createAt,
  });

  final String id;
  final String brandId;
  final String name;
  final double price;
  final Map<String, ImageProduct> listImageProduct;
  final Map<String, ProductSize> listProductSize;
  final String description;
  final String createAt;

  factory Product.fromRealtime(Map<String, dynamic> data) {
    final imageMap = (data['listImageProduct'] as Map<dynamic, dynamic>?) ?? {};
    final sizeMap = (data['listProductSize'] as Map<dynamic, dynamic>?) ?? {};

    return Product(
      id: data['id'] ?? '',
      brandId: data['brandId'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      createAt: data['createAt'] ?? '',
      listImageProduct: imageMap.map(
        (key, value) => MapEntry(
          key.toString(),
          ImageProduct.fromJson(Map<String, dynamic>.from(value)),
        ),
      ),
      listProductSize: sizeMap.map(
        (key, value) => MapEntry(
          key.toString(),
          ProductSize.fromJson(Map<String, dynamic>.from(value)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brandId': brandId,
    'name': name,
    'price': price,
    'description': description,
    'createAt': createAt,
    'listImageProduct':
    listImageProduct.map((key, value) => MapEntry(key, value.toJson())),
    'listProductSize':
    listProductSize.map((key, value) => MapEntry(key, value.toJson())),
  };
}
