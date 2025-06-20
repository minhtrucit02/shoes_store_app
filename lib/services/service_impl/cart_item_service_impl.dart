import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
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

          if (item.productId == cartItem.productId &&
              item.productSize == cartItem.productSize &&
              item.productImage == cartItem.productImage &&
              item.productName == cartItem.productName) {
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
  Stream<List<CartItem>> getCartItemByUserId(String userId) {
    final ref = FirebaseDatabase.instance.ref('cartItems');

    return ref.onValue.map((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        final List<CartItem> items = [];

        data.forEach((key, value) {
          final item = CartItem.fromJson({
            ...Map<String, dynamic>.from(value),
            'id': key,
          });

          if (item.cartStatus != CartItemStatus.paid &&
              item.cartId == userId) {
            items.add(item);
          }
        });

        return items;
      } else {
        return [];
      }
    });
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

  @override
  Future<void> changeStatusCart (
    String cartItemId,
    CartItemStatus cartItemStatus,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/cartItems/$cartItemId.json');
      final response = await http.patch(
        url,
        body: jsonEncode({'cartStatus': cartItemStatus.name}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to change cart status');
      }
    } catch (e) {
      print("Error changing cart status: $e");
      rethrow;
    }
  }

  @override
  Future<void> addCartItemIdInCart(String cartItemId, String cartId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/carts/$cartId/listCartId/$cartItemId.json',
      );
      final response = await http.put(url, body: jsonEncode(true));

      if (response.statusCode == 200) {
        print('Successfully added cartItemId to cart.');
      } else {
        throw Exception(
          'Failed to add cartItemId to cart. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error adding cartItemId to cart: $e');
    }
  }

  @override
  Stream<CartItem?> getCheckedCartItemsByCartItemId(String cartItemId) {
    final ref = FirebaseDatabase.instance.ref('cartItems/$cartItemId');
    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      final item = CartItem.fromJson(Map<String, dynamic>.from(data));
      return item.cartStatus.displayName == 'checked' ? item : null;
    });
  }


}
