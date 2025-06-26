import 'package:shoes_store_app/models/cart_item.dart';

abstract class CartItemService{
  Future<List<CartItem>> getCartItemByUserId(String userId);
  Future<void> deleteCartItem(String id);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> updateQuantity(String cartId, int newQuantity);
}