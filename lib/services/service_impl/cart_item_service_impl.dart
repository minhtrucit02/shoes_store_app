import 'dart:convert';

import 'package:shoes_store_app/models/cart_item.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';
import 'package:shoes_store_app/services/cart_item_service.dart';
import 'package:http/http.dart' as http;

class CartItemServiceImpl implements CartItemService {
  final String baseUrl =
      'https://shosestore-7c86e-default-rtdb.firebaseio.com/';
  @override
  Future<void> addCartItem(CartItem cartItem) async {
    final getUrl = Uri.parse('$baseUrl/cartItems.json');
    final getResponse = await http.get(getUrl);

    if (getResponse.statusCode == 200) {
      final data = jsonDecode(getResponse.body);

      if (data != null && data is Map<String, dynamic>) {
        String? existingId;
        int existingQuantity = 0;

        data.forEach((key, value) {
          final item = CartItem.fromJson({
            ...Map<String, dynamic>.from(value),
            'id': key,
          });

          if (item.userId == cartItem.userId &&
              item.productId == cartItem.productId &&
              item.productSize == cartItem.productSize &&
              item.productImage == cartItem.productImage &&
              item.status == cartItem.status) {
            existingId = key;
            existingQuantity = item.quantity;
          }
        });

        if (existingId != null) {
          final updateUrl = Uri.parse('$baseUrl/cartItems/$existingId.json');
          final patchResponse = await http.patch(
            updateUrl,
            body: jsonEncode({'quantity': existingQuantity + 1}),
          );
          if (patchResponse.statusCode != 200) {
            throw Exception('Failed to update cart quantity');
          }
          return;
        }
      }
    }

    final postUrl = Uri.parse('$baseUrl/cartItems.json');
    final postResponse = await http.post(
      postUrl,
      body: jsonEncode(cartItem.toJson()),
    );
    if (postResponse.statusCode != 200) {
      throw Exception('Failed to add cart item');
    }
  }

  @override
  Future<void> deleteCartItem(String id) async {
    final url = Uri.parse('$baseUrl/cartItems/$id.json');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart item');
    }
  }

  @override
  Future<List<CartItem>> getCartItemByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/cartItems.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null && data is Map<String, dynamic>) {
        final List<CartItem> items = [];

        data.forEach((key, value) {
          final item = CartItem.fromJson({
            ...Map<String, dynamic>.from(value),
            'id': key,
          });

          if (item.userId == userId && item.status == CartStatus.unpaid) {
            items.add(item);
          }
        });

        return items;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  @override
  Future<void> updateQuantity(String cartId, int newQuantity) async {
    final url = Uri.parse('$baseUrl/cartItems/$cartId.json');
    final response = await http.patch(
      url,
      body: jsonEncode({'quantity': newQuantity}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update quantity');
    }
  }
}
