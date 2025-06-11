import 'package:shoes_store_app/models/brand.dart';

abstract class BrandService {
  Future<String?> getBrandNameById(String brandId);
  Future<void> addBrand(Brand brand);
  Future<List<Brand>> getAllBrands();
  Future<Brand?> getBrandById(String id);
  Future<void> deleteBrand(int id);
}