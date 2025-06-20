import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/cart_provider.dart';
import 'package:shoes_store_app/widgets/history_payment_card.dart';

class HistoryPaymentScreen extends ConsumerWidget {
  const HistoryPaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final getHistoryCardItem = ref.watch(getHistoryCartItemProvider(user!.uid));
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: getHistoryCardItem.when(
        data: (cartItem) {
          return ListView.builder(
            itemCount: cartItem.length,
              itemBuilder: (context,index){
              return HistoryPaymentCard(cartItem: cartItem[index]);
              }
          );
        },
        error: (e, _) => Scaffold(body: Center(child: Text('Have error: $e'))),
        loading:
            () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}
