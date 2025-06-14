import 'dart:convert';

import 'package:shoes_store_app/models/payment.dart';
import 'package:shoes_store_app/services/payment_service.dart';
import 'package:http/http.dart' as http;

class PaymentServiceImpl implements PaymentService{
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com/';
  @override
  Future<void> addPayment(Payment payment)async {
   final url = Uri.parse('$baseUrl/payments.json');
   final response = await http.put(url,body: jsonEncode(payment));
   if (response.statusCode != 200 && response.statusCode != 201) {
     throw Exception('Failed to add user');
   }
  }

  @override
  Future<List<Payment>> getPayment() {
    // TODO: implement getPayment
    throw UnimplementedError();
  }

}