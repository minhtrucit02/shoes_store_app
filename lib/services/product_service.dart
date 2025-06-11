import '../models/product.dart';

abstract class ProductService{
  Future<void> addProduct(Product product);
  Stream<List<Product>> getAllProducts();
  Future<Product?> getProductById(String productId);
  Future<void> deleteProduct(String productId);
}