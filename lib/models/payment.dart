import 'package:shoes_store_app/models/enum_payment.dart';
import 'package:shoes_store_app/models/userDB.dart';

class Payment {
  Payment({
    required this.id,
    required this.userPayment,
    required this.totalPrice,
    required this.address,
    required this.method,
  });

  final String id;
  final UserDB userPayment;
  final double totalPrice;
  final String address;
  final MethodPayment method;

  factory Payment.fromJson(Map<String, dynamic> data) {
    return Payment(
      id: data['id'],
      userPayment: UserDB.fromJson(data['userPayment']),
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0.0,
      address: data['address'] ?? '',
      method: MethodPayment.values.firstWhere(
            (e) => e.name == data['method'],
        orElse: () => MethodPayment.offline,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userPayment': userPayment.toJson(),
    'totalPrice': totalPrice,
    'address': address,
    'method': method.name,
  };
}
