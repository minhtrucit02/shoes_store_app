import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/payment_provider.dart';
import 'package:shoes_store_app/widgets/customer_infor_card.dart';

class AddressUser extends ConsumerWidget {
  const AddressUser({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final getPaymentAsync = ref.watch(getPaymentByUserIdProvider(user!.uid));

    return getPaymentAsync.when(
      data: (paymentInfor) {
        if (paymentInfor.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No address information found')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Address Information'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paymentInfor.length,
              itemBuilder: (context, index) {
                final payment = paymentInfor[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CustomerInfoCard(
                    fullName: payment.username,
                    phone: payment.phone,
                    address: payment.address,
                  ),
                );
              },
            ),
          ),
        );
      },
      error: (e, _) => Scaffold(
        body: Center(child: Text('Have error: $e')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
