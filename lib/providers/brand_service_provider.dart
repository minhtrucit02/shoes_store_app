import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/services/service_impl/brand_servce_impl.dart';
import 'package:shoes_store_app/services/brand_service.dart';

import '../models/brand.dart';

final brandServiceProvider = Provider<BrandService>((ref){
  return BrandServiceImpl();
});
final selectedBrandIndexProvider = StateProvider<int>((ref) => 0);

final brandListProvider = FutureProvider((ref) {
  final service = ref.watch(brandServiceProvider);
  return service.getAllBrands();
});

final getBrandByIdProvider = FutureProvider.family<Brand?,String>((ref,id){
  final service = ref.watch(brandServiceProvider);
  return service.getBrandById(id);
});

final getBrandNameByIdProvider = FutureProvider.family<String?,String>((ref,brandId){
  final service = ref.watch(brandServiceProvider);
  return service.getBrandNameById(brandId);
});