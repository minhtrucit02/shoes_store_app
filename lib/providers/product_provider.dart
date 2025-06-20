import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/product.dart';
import 'package:shoes_store_app/models/product_update.dart';
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

final getProductSizesProvider = FutureProvider.family<Map<int, int>, (String productId, String imageKey)>((ref, params) async {
  final service = ref.watch(productServiceProvider);
  final (productId, imageKey) = params;

  final productSizes = await service.getProductSizes(productId, imageKey).first;

  return {
    for (var ps in productSizes)
      ps.size: ps.quantity,
  };
});

final updateQuantityProductSizeProvider = FutureProvider.family<void,ProductUpdate>((ref,productUpdate) async{
  final service = ref.watch(productServiceProvider);
  await service.updateProductSizeQuantity(productUpdate);
});