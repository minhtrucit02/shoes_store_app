import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/services/cart_service.dart';
import 'package:shoes_store_app/services/service_impl/cart_service_impl.dart';

import '../models/cart_item.dart';

final cartServiceProvider = Provider<CartService>((ref){
  return CartServiceImpl();
});


final createCartProvider = FutureProvider.family<void, String>((ref, userId) {
  final cartService = ref.read(cartServiceProvider);
  return cartService.createCartForUser(userId);
});

final addCartItemInCartProvider = FutureProvider.family<void,(CartItem, String)>((ref,tuple){
  final cartService = ref.read(cartServiceProvider);
  final cartItem =tuple.$1;
  final userId =tuple.$2;
  return cartService.addCartItemInCart(cartItem, userId);
});

final updateCartProvider = FutureProvider.family<void, (String userId, int quantity, double totalPrices)>((ref, args) {
  final service = ref.watch(cartServiceProvider);
  return service.updateCartBeforePayment(args.$1, args.$2, args.$3);
});

final getHistoryCartItemProvider = FutureProvider.family<List<CartItem>, String>((ref, userId) async {
  final service = ref.read(cartServiceProvider);
  return service.getHistoryCartItemPained(userId);
});

