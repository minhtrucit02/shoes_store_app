import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/services/brand_service/brand_servce_impl.dart';
import 'package:shoes_store_app/services/brand_service/brand_service.dart';

final brandServiceProvider = Provider<BrandService>((ref){
  return BrandServiceImpl();
});

final brandListProvider = FutureProvider((ref) {
  final service = ref.watch(brandServiceProvider);
  return service.getAllBrands();
});
final selectedBrandIndexProvider = StateProvider<int>((ref) => 0);
