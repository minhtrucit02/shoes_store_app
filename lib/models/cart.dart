import 'package:shoes_store_app/models/cart_item.dart';

class Cart {
  Cart({
    required this.id,
    required this.listCartItem,
    required this.userId,
    required this.totalQuantity,
    required this.totalPrice,
  });

  final String id;
  final Map<String, CartItem> listCartItem;
  final String userId;
  final int totalQuantity;
  final double totalPrice;

  factory Cart.fromJson(Map<String, dynamic> data) {
    final rawItems = data['listCartItem'] as Map<String, dynamic>? ?? {};

    return Cart(
      id: data['id'] ?? '',
      listCartItem: rawItems.map((key, value) => MapEntry(
        key,
        CartItem.fromJson(value),
      )),
      userId: data['userId'] ?? '',
      totalQuantity: data['totalQuantity'] ?? 0,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listCartItem': listCartItem.map(
            (key, item) => MapEntry(key, item.toJson()),
      ),
      'userId': userId,
      'totalQuantity': totalQuantity,
      'totalPrice': totalPrice,
    };
  }
}
