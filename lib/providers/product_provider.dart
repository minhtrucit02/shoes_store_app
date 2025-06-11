import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/product.dart';
import 'package:shoes_store_app/services/service_impl/product_service_impl.dart';

final selectedSizeProvider = StateProvider<int?>((ref) => null);
final selectedImageProductProvider = StateProvider<String?>((ref) => null);

final productServiceProvider = Provider<ProductServiceImpl>((ref){
  return ProductServiceImpl();
});

final productsStreamProvider = StreamProvider<List<Product>>((ref){
  final service = ref.watch(productServiceProvider);
  return service.getAllProducts();
});

final getProductByIdProvider = FutureProvider.family<Product?,String>((ref,String productId){
  final service = ref.watch(productServiceProvider);
  return service.getProductById(productId);
});


