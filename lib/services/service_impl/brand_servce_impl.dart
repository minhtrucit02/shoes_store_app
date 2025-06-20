import 'dart:convert';

import 'package:shoes_store_app/models/brand.dart';
import 'package:shoes_store_app/services/brand_service.dart';
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
        if (data != null && data is Map) {
          final List<Brand> brands = [];

          data.forEach((key, value) {
            try {
              final brand = Brand.fromJson(Map<String, dynamic>.from(value));
              brands.add(brand);
            } catch (e) {
              print("Lỗi khi parse brand: $e | Dữ liệu: $value");
            }
          });

          return brands;
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
  Future<Brand?> getBrandById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/brands/$id.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          return Brand.fromJson(Map<String, dynamic>.from(data));
        } else {
          print('Không tìm thấy brand với id: $id');
          return null;
        }
      } else {
        throw Exception('Lỗi khi tải brand: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy brand theo id: $e');
      return null;
    }
  }

  @override
  Future<String?> getBrandNameById(String brandId) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/brands/$brandId.json'));
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        if(data != null && data['name'] != null){
          return data['name'] as String;
        } else{
          print('Không tìm thấy tên thương hiệu cho ID: $brandId');
          return null;        }
      } else{
        throw Exception('Lỗi khi tải brand name: ${response.statusCode}');
      }
    }catch(e){
      print('Lỗi khi lấy brand name theo ID: $e');
      return null;
    }
  }
  
}