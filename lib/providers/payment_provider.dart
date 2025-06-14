import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/enum_payment.dart';
import 'package:shoes_store_app/services/payment_service.dart';
import 'package:shoes_store_app/services/service_impl/payment_service_impl.dart';

import '../models/payment.dart';

final paymentServiceProvider = Provider<PaymentService>((ref){
  return PaymentServiceImpl();
});

final addPaymentProvider = FutureProvider.family<void,Payment>((ref,payment) async{
  final service = ref.watch(paymentServiceProvider);
  await service.addPayment(payment);
});
final selectedMethodProvider = StateProvider<MethodPayment>((ref) => MethodPayment.paymentCard);