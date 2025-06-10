import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/product.dart';
import 'package:shoes_store_app/services/service_impl/product_service_impl.dart';

final productServiceProvider = Provider<ProductServiceImpl>((ref){
  return ProductServiceImpl();
});

final productsStreamProvider = StreamProvider<List<Product>>((ref){
  final service = ref.watch(productServiceProvider);
  return service.getAllProducts();
});
