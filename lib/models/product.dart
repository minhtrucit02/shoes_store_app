
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
  final int id;
  final int brandId;
  final String name;
  final double price;
  final List<ImageProduct> listImageProduct;
  final List<ProductSize> listProductSize;
  final String description;
  final String createAt;

  factory Product.fromRealtime(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      brandId: data['brandId'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      description: data['description'],
      createAt: data['createAt'],
      listImageProduct: (data['listImageProduct'] as List<dynamic>?)
          ?.map((e) => ImageProduct.fromJson(e))
          .toList() ?? [],
      listProductSize: (data['listProductSize'] as List<dynamic>?)
          ?.map((e) => ProductSize.fromJson(e))
          .toList() ?? [],
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'brandId': brandId,
    'name': name,
    'price': price,
    'description': description,
    'createAt': createAt,
    'listImageProduct': listImageProduct.map((e) => e.toJson()).toList(),
    'listProductSize': listProductSize.map((e) => e.toJson()).toList(),
  };
}

