import 'dart:convert';

import 'package:shoes_store_app/models/userDB.dart';
import 'package:shoes_store_app/services/user_service.dart';
import 'package:http/http.dart' as http;

class UserServiceImpl implements UserService{
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com';

  @override
  Future<void> addUser(UserDB user) async {
    final url = Uri.parse('$baseUrl/users/${user.id}.json');
    final response = await http.put(
      url,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  @override
  Future<String?> getEmailUser(String userId)async {
    final url = Uri.parse('$baseUrl/users/$userId.json');
    final response = await http.get(url);
    if(response.statusCode ==200){
      final data = jsonDecode(response.body);
      if(data != null && data['email'] != null ){
        return data['email'] as String;
      }
    }
    return null;
  }



}