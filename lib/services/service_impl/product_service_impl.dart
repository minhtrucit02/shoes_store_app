import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shoes_store_app/models/product.dart';
import 'package:shoes_store_app/services/product_service.dart';
import 'package:http/http.dart' as http;

class ProductServiceImpl implements ProductService{
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com';
  final database = FirebaseDatabase.instance;

  @override
  Future<void> addProduct(Product product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(int productId) {
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
  Future<Product> getProductById(int productId) {
    // TODO: implement getProductById
    throw UnimplementedError();

  }
  
}