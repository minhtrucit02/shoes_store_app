import 'package:shoes_store_app/models/product_size.dart';

class ImageProduct {
  ImageProduct({
    required this.url,
    required this.listProductSize,
  });

  final String url;
  final Map<String, ProductSize> listProductSize;

  factory ImageProduct.fromJson(Map<String, dynamic> json) {
    final sizeMap = (json['listProductSize'] as Map<dynamic, dynamic>? ?? {});

    return ImageProduct(
      url: json['url'] ?? '',
      listProductSize: sizeMap.map(
            (key, value) => MapEntry(
          key.toString(),
          ProductSize.fromJson(Map<String, dynamic>.from(value)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'listProductSize': listProductSize.map(
          (key, value) => MapEntry(key, value.toJson()),
    ),
  };
}
