import 'package:shoes_store_app/models/enum_payment.dart';
import 'package:shoes_store_app/models/userDB.dart';

class Payment {
  Payment({
    required this.id,
    required this.userId,
    required this.username,
    required this.phone,
    required this.address,
    required this.totalPrice,
    required this.method,
    required this.createAt,
  });

  final String id;
  final String userId;
  final String username;
  final String phone;
  final String address;
  final double totalPrice;
  final MethodPayment method;
  final String createAt;

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      id: data['id'],
      userId: data['userId'],
      username: data['username'],
      phone: data['phone'],
      address: data['address'] ?? '',
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      method: MethodPayment.values.firstWhere(
            (e) => e.name == data['method'],
        orElse: () => MethodPayment.offline,
      ),
      createAt: data['createAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId':userId,
    'username':username,
    'phone':phone,
    'address': address,
    'totalPrice': totalPrice,
    'method': method.name,
    'createAt': createAt
  };
}
