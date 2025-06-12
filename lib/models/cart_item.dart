  import 'package:shoes_store_app/models/enum_cart_status.dart';

  class CartItem {
    CartItem({
      required this.id,
      required this.userId,
      required this.productId,
      required this.productName,
      required this.productImage,
      required this.productPrice,
      required this.productSize,
      required this.quantity,
      required this.status,
      required this.buyDate,
    });
    final String id;
    final String userId;
    final String productId;
    final String productName;
    final String productImage;
    final double productPrice;
    final int productSize;
    final int quantity;
    final CartStatus status;
    final String buyDate;

    factory CartItem.fromJson(Map<String, dynamic> data) {
      return CartItem(
        id: data['id'] ?? '',
        userId: data['userId'] ?? '',
        productId: data['productId'] ?? '',
        productName: data['productName'] ?? '',
        productImage: data['productImage'] ?? '',
        productPrice: (data['productPrice'] as num).toDouble(),
        productSize: data['productSize'] ?? 0,
        quantity: data['quantity'] ?? 1,
        status: CartStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => CartStatus.unpaid,
        ),
        buyDate: data['buyDate'] ?? '',
      );
    }

    Map<String, dynamic> toJson() => {
      'id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'productSize': productSize,
      'quantity': quantity,
      'status': status.name,
      'buyDate': buyDate,
    };
  }
