import 'package:shoes_store_app/models/product_size.dart';
import 'package:shoes_store_app/models/product_update.dart';

import '../models/product.dart';

abstract class ProductService{
  Future<void> addProduct(Product product);
  Stream<List<Product>> getAllProducts();
  Future<Product?> getProductById(String productId);
  Future<void> deleteProduct(String productId);
  Stream<List<ProductSize>> getProductSizes(String productId,String imageKey);
  Future<void> updateProductSizeQuantity(ProductUpdate productUpdate);
}