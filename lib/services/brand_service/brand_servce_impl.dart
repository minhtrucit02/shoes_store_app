import 'dart:convert';

import 'package:shoes_store_app/models/brand.dart';
import 'package:shoes_store_app/services/brand_service/brand_service.dart';
import 'package:http/http.dart' as http;


class BrandServiceImpl implements BrandService{
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com';
  @override
  Future<void> addBrand(Brand brand) {
    // TODO: implement addBrand
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBrand(int id) {
    // TODO: implement deleteBrand
    throw UnimplementedError();
  }

  @override
  Future<List<Brand>> getAllBrands() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/brands.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is List) {
          return data
              .where((item) => item != null)
              .map((item) => Brand.fromJson(item))
              .toList();
        } else {
          print("Dữ liệu không hợp lệ: $data");
          return [];
        }
      } else {
        throw Exception('Lỗi khi tải dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy danh sách brand: $e');
      rethrow;
    }
  }
  @override
  Future<Brand> getBrandById(int id) {
    // TODO: implement getBrandById
    throw UnimplementedError();
  }
  
}