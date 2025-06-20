import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shoes_store_app/main.dart';
import 'package:shoes_store_app/models/product.dart';
import 'package:shoes_store_app/models/product_size.dart';
import 'package:shoes_store_app/models/product_update.dart';
import 'package:shoes_store_app/services/product_service.dart';
import 'package:http/http.dart' as http;

class ProductServiceImpl implements ProductService {
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com';
  final database = FirebaseDatabase.instance;

  @override
  Future<void> addProduct(Product product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String productId) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> getAllProducts() {
    final ref = database.ref('products');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];
      final List<Product> products = [];
      data.forEach((key, value) {
        try {
          final productMap = Map<String, dynamic>.from(value as Map);
          final product = Product.fromRealtime(productMap);
          products.add(product);
        } catch (e) {
          print("Lỗi khi parse product: $e | Dữ liệu: $value");
        }
      });

      products.sort((a, b) => a.id.compareTo(b.id));
      return products;
    });
  }

  @override
  Future<Product?> getProductById(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId.json'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          return Product.fromRealtime(Map<String, dynamic>.from(data));
        } else {
          print('Không tìm thấy product với id: $productId');
          return null;
        }
      } else {
        throw Exception('Lỗi khi tải product: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy product theo id: $e');
      return null;
    }
  }

  @override
  Stream<List<ProductSize>> getProductSizes(String productId, String imageKey) {
    final ref = database.ref(
      'products/$productId/listImageProduct/$imageKey/listProductSize',
    );

    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      final sizes =
          data.entries
              .map((entry) {
                final map = Map<String, dynamic>.from(entry.value);
                return ProductSize.fromJson(map);
              })
              .where((ps) => ps.quantity >= 0)
              .toList();

      return sizes;
    });
  }

  @override
  Future<void> updateProductSizeQuantity(ProductUpdate productUpdate) async {
    final ref = database.ref(
      'products/${productUpdate.productId}/listImageProduct',
    );
    try {
      final snapshot = await ref.get();
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        for (final entry in data.entries) {
          final imageKey = entry.key;
          final imageData = Map<String, dynamic>.from(entry.value);
          final listProductSize = Map<String, dynamic>.from(
            imageData['listProductSize'] ?? {},
          );
          final url = imageData['url'];
          if (url == productUpdate.imageUrl) {
            final sizeKey = productUpdate.productSize.toString();
            if (listProductSize.containsKey(sizeKey)) {
              final sizeData = Map<String, dynamic>.from(listProductSize[sizeKey]);
              final currentQuantity = sizeData['quantity'] as int;

              final updatedQuantity = (currentQuantity - productUpdate.quantity).clamp(0, currentQuantity);
              sizeData['quantity'] = updatedQuantity;
              listProductSize[sizeKey] = sizeData;

              await ref.child(imageKey).update({
                'listProductSize': listProductSize,
              });

              print('Update Successfully $sizeKey: $updatedQuantity');
            }
          }
        }
      }
    } catch (e) {
      print('Error updating product size quantity: $e');
      rethrow;
    }
  }
}
