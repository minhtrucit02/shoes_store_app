import 'package:shoes_store_app/models/enum_cart_status.dart';

class CartItem {
  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productSize,
    required this.quantity,
    required this.price,
    required this.cartStatus,
    required this.createdAt,
  });
  final String id;
  final String cartId;
  final String productId;
  final String productImage;
  final String productName;
  final int productSize;
  final int quantity;
  final double price;
  final CartItemStatus cartStatus;
  final String createdAt;

  factory CartItem.fromJson(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'] ?? '',
      cartId: data['cartId'] ?? '',
      productId: data['productId'] ?? '',
      productImage: data['productImage'] ?? '',
      productName: data['productName'] ?? '',
      productSize: data['productSize'] ?? 0,
      quantity: data['quantity'] ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      cartStatus: parseCartItemStatus(data['cartStatus']),
      createdAt: data['createdAt'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'cartId': cartId,
    'productId': productId,
    'productImage': productImage,
    'productName': productName,
    'productSize': productSize,
    'quantity': quantity,
    'price': price,
    'cartStatus': cartStatus.name,
    'createdAt':createdAt,
  };

  static CartItemStatus parseCartItemStatus(String status){
    switch (status.toLowerCase()) {
      case 'unpaid':
        return CartItemStatus.unpaid;
      case 'paid':
        return CartItemStatus.paid;
      case 'checked':
        return CartItemStatus.checked;
      default:
        return CartItemStatus.unpaid;
    }
  }
}
