import 'package:shoes_store_app/models/payment.dart';

abstract class PaymentService {
  Future<void> addPayment(Payment payment);
  Future<List<Payment>>getPaymentByUserId(String userId);
}