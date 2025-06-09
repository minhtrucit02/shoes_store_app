import 'package:shoes_store_app/models/brand.dart';

abstract class BrandService {
  Future<void> addBrand(Brand brand);
  Future<List<Brand>> getAllBrands();
  Future<Brand> getBrandById(int id);
  Future<void> deleteBrand(int id);
}