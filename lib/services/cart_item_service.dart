import 'package:shoes_store_app/models/cart_item.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';

abstract class CartItemService{
  Stream<List<CartItem>> getCartItemByUserId(String userId);
  Future<void> deleteCartItem(String id);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> updateQuantity(String cartId, int newQuantity);
  Future<void> changeStatusCart(String cartItemId, CartItemStatus cartItemStatus);
  Future<void> addCartItemIdInCart(String cartItemId, String cartId);
  Stream<CartItem?> getCheckedCartItemsByCartItemId(String cartItemId);
} 