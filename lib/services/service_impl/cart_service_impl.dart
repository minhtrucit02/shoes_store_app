import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shoes_store_app/models/cart.dart';
import 'package:shoes_store_app/models/cart_item.dart';
import 'package:shoes_store_app/services/cart_service.dart';
import 'package:http/http.dart' as http;

class CartServiceImpl implements CartService {
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com';

  @override
  Future<void> createCartForUser(String userId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.uid != userId) {
        print('Invalid user or mismatched userId');
        return;
      }

      final url = Uri.parse('$baseUrl/carts/$userId.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null || userId != user.uid) {
          final newCart = Cart(
            id: user.uid,
            listCartItem: {},
            userId: user.uid,
            totalQuantity: 0,
            totalPrice: 0,
          );

          final createResponse = await http.put(
            url,
            body: jsonEncode(newCart.toJson()),
          );

          if (createResponse.statusCode != 200) {
            throw Exception('Failed to create new cart');
          } else {
            print('Cart created for user ${user.uid}');
          }
        } else {
          print('Cart already exists for user $userId');
        }
      } else {
        throw Exception('Failed to check cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  @override
  Stream<List<CartItem>> listCartItem(String cartId) {
    // TODO: implement listCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> updateCartBeforePayment(String userId, int addedQuantity, double addedTotalPrices) async {
    final ref = FirebaseDatabase.instance.ref('carts/$userId');

    try {
      final snapshot = await ref.get();

      int currentQuantity = 0;
      double currentTotalPrice = 0.0;

      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        currentQuantity = (data['totalQuantity'] as int?) ?? 0;
        currentTotalPrice = (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
      }

      final newQuantity = currentQuantity + addedQuantity;
      final newTotalPrices = currentTotalPrice + addedTotalPrices;

      await ref.update({
        'totalQuantity': newQuantity,
        'totalPrice': newTotalPrices,
      });
    } catch (e) {
      throw Exception('Error updating cart before payment: $e');
    }
  }

  @override
  Future<void> addCartItemInCart(CartItem cartItem, String userId) async {
    final ref = FirebaseDatabase.instance.ref('carts/$userId/listCartItem');

    try {
      await ref.child(cartItem.id).set(cartItem.toJson());
    } catch (e) {
      throw Exception('Error adding cart item: $e');
    }
  }

  @override
  Future<List<CartItem>> getHistoryCartItemPained(String userId) async{
    final ref = FirebaseDatabase.instance.ref('carts/$userId/listCartItem');
    final List<CartItem> historyCartItem = [];
    try{
      final snapshot = await ref.get();
      if(snapshot.exists && snapshot.value is Map){
        final data = Map<String,dynamic>.from(snapshot.value as Map);
        data.forEach((key,value){
          if(value is Map ){
            final item = CartItem.fromJson(Map<String,dynamic>.from(value));
            historyCartItem.add(item);
          }
        });
      }
      return historyCartItem;
    }catch(e){
      throw  Exception('Error: $e');
    }

  }
}
