import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/services/cart_item_service.dart';
import 'package:shoes_store_app/services/service_impl/cart_item_service_impl.dart';

import '../models/cart_item.dart';

class SelectedCartNotifier extends StateNotifier<Set<String>> {
  SelectedCartNotifier() : super({});

  void toggleSelection(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }

  void add(String id) {
    state = {...state, id};
  }

  void remove(String id) {
    state = {...state}..remove(id);
  }

  void selectAll(List<CartItem> items) {
    state = items.map((item) => item.id).toSet();
  }

  void clear() {
    state = {};
  }
}

class CartQuantityController extends AsyncNotifier<Map<String, int>> {
  @override
  FutureOr<Map<String, int>> build() async {
    return {};
  }

  Future<void> updateQuantity({
    required String cartId,
    required int newQuantity,
    required String userId,
  }) async {
    if (newQuantity <= 0) return;

    final previousQuantity = state.value?[cartId] ?? 1;
    state = AsyncData({...state.value ?? {}, cartId: newQuantity});

    try {
      final service = ref.read(cartItemServiceProvider);
      await service.updateQuantity(cartId, newQuantity);
      ref.invalidate(getCartItemByUserIdProvider(userId));
    } catch (e, st) {
      // Trả lại số lượng cũ nếu có lỗi
      state = AsyncError(e, st);
      state = AsyncData({...state.value ?? {}, cartId: previousQuantity});
    }
  }
}

final cartQuantityControllerProvider =
    AsyncNotifierProvider<CartQuantityController, Map<String, int>>(
      CartQuantityController.new,
    );

final selectedCartItem = StateProvider<int?>((ref) => null);

final cartItemServiceProvider = Provider<CartItemService>((ref) {
  return CartItemServiceImpl();
});

final addCartItemProvider = FutureProvider.family<void, CartItem>((
  ref,
  cartItem,
) async {
  final service = ref.read(cartItemServiceProvider);
  await service.addCartItem(cartItem);
  ref.invalidate(getCartItemByUserIdProvider);
});

final getCartItemByUserIdProvider =
    FutureProvider.family<List<CartItem>, String>((ref, userId) {
      final service = ref.watch(cartItemServiceProvider);
      return service.getCartItemByUserId(userId);
    });

final selectedCartProvider =
    StateNotifierProvider<SelectedCartNotifier, Set<String>>(
      (ref) => SelectedCartNotifier(),
    );

final selectedItemsTotalProvider = Provider.family<double, List<CartItem>>((
  ref,
  cartItems,
) {
  final selectedIds = ref.watch(selectedCartProvider);
  return cartItems
      .where((item) => selectedIds.contains(item.id))
      .fold(0, (total, item) => total + (item.productPrice * item.quantity));
});

final deleteCartItemProvider = FutureProvider.family<void, String>((
  ref,
  cartItemId,
) async {
  final service = ref.read(cartItemServiceProvider);
  await service.deleteCartItem(cartItemId);
  ref.invalidate(getCartItemByUserIdProvider);
});

final selectedCartItemProvider = StateProvider<List<CartItem>>((ref) => []);
