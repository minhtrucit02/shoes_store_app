import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shoes_store_app/models/payment.dart';
import 'package:shoes_store_app/services/payment_service.dart';
import 'package:http/http.dart' as http;

class PaymentServiceImpl implements PaymentService{
  final String baseUrl = 'https://shosestore-7c86e-default-rtdb.firebaseio.com/';
  @override
  Future<void> addPayment(Payment payment) async {
    final url = Uri.parse('$baseUrl/payments.json');
    final response = await http.post(
      url,
      body: jsonEncode(payment),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add payment');
    }
  }

  @override
  Future<List<Payment>> getPaymentByUserId(String userId)async {
    final ref = FirebaseDatabase.instance.ref('payments');
    final snapshot = await ref.get();

    final List<Payment> listPayment= [];
    if(snapshot.exists && snapshot.value is Map){
      final data = snapshot.value as Map<dynamic,dynamic>;
      
      data.forEach((key,value){
        if(value is Map && value['userId'] == userId){
          final item = Payment.fromJson(Map<String,dynamic>.from(value));
          listPayment.add(item);
        }
      });
    }
    return listPayment;
  }

  @override
  Future<List<Payment>> getPayment() {
    // TODO: implement getPayment
    throw UnimplementedError();
  }

}