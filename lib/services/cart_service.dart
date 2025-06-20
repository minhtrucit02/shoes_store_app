import 'package:shoes_store_app/models/cart_item.dart';

abstract class CartService {
  Future<void> createCartForUser(String userId);

  Future<void> addCartItemInCart(CartItem cartItem, String userId);

  Stream<List<CartItem>> listCartItem(String cartId);

  Future<void> updateCartBeforePayment(String userId, int addedQuantity,
      double addedTotalPrices);

  Future<List<CartItem>> getHistoryCartItemPained(String userId);
}