import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';
import 'package:shoes_store_app/models/enum_payment.dart';
import 'package:shoes_store_app/models/payment.dart';
import 'package:shoes_store_app/models/product_update.dart';
import 'package:shoes_store_app/providers/cart_item_provider.dart';
import 'package:shoes_store_app/providers/cart_provider.dart';
import 'package:shoes_store_app/providers/payment_provider.dart';
import 'package:shoes_store_app/providers/product_provider.dart';
import 'package:shoes_store_app/widgets/address_user.dart';

import '../models/cart_item.dart';
import '../widgets/payment_success.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    double shopping = 40;
    double totalCost = shopping + widget.totalAmount;
    final selectedMethod = ref.watch(selectedMethodProvider);
    final addPayment = ref.watch(paymentServiceProvider);

    @override
    void dispose() {
      userNameController.dispose();
      phoneController.dispose();
      addressController.dispose();
      super.dispose();
    }

    String methodPaymentToString(MethodPayment method) {
      switch (method) {
        case MethodPayment.paymentCard:
          return 'Credit Card';
        case MethodPayment.offline:
          return 'Offline';
        case MethodPayment.online:
          return 'Online';
      }
    }

    void handlePayment() async {
      if (userNameController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
      } else {
        final paymentAction = Payment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          username: userNameController.text.trim(),
          phone: phoneController.text.trim(),
          address: addressController.text.trim(),
          totalPrice: totalCost,
          method: ref.read(selectedMethodProvider),
          createAt: DateTime.now().toString(),
        );

        try {
          await addPayment.addPayment(paymentAction);
          final user = FirebaseAuth.instance.currentUser;
          final selectedCartItem = ref.read(selectedCartProvider);

          int totalQuantity = 0;
          Map<String, CartItem> processedItems = {};

          for (final id in selectedCartItem) {
            final cartItem = await ref.read(
              getCheckedCartItemsProvider(id).future,
            );

            if (cartItem != null) {
              totalQuantity += cartItem.quantity;
              processedItems[id] = cartItem;
            }
          }

          // Then process each item
          for (final entry in processedItems.entries) {
            final id = entry.key;
            final cartItem = entry.value;

            await ref.read(
              changeCartStatusProvider((id, CartItemStatus.paid)).future,
            );

            final updatedCartItem = CartItem(
              id: cartItem.id,
              cartId: cartItem.cartId,
              productId: cartItem.productId,
              productImage: cartItem.productImage,
              productName: cartItem.productName,
              productSize: cartItem.productSize,
              quantity: cartItem.quantity,
              price: cartItem.price,
              cartStatus: CartItemStatus.paid,
              createdAt: cartItem.createdAt,
            );

            await ref.read(
              addCartItemInCartProvider((updatedCartItem, user!.uid)).future,
            );

            // Update product quantity
            final productUpdate = ProductUpdate(
              productId: updatedCartItem.productId,
              productSize: updatedCartItem.productSize,
              quantity: updatedCartItem.quantity,
              imageUrl: updatedCartItem.productImage,
            );
            await ref.read(
              updateQuantityProductSizeProvider(productUpdate).future,
            );

            await ref.read(deleteCartItemProvider(id).future);
          }

          // Update cart with total quantity once at the end
          await ref.read(
            updateCartProvider((
            user!.uid,
            totalQuantity,
            widget.totalAmount,
            )).future,
          );

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PaymentSuccessDialog(),
          );
        } catch (e) {
          throw Exception('Error: $e');
        }
      }
    }    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //TODO: contact information
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 16),

                      //TODO: edit user email
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_outline_outlined,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: userNameController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Username',
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                          ),
                          Icon(Icons.edit, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 16),

                      //TODO: edit user phone
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.phone_outlined, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: phoneController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Phone',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit, color: Colors.grey),
                        ],
                      ),

                      //TODO: address
                      const SizedBox(height: 18),
                      Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addressController,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'your address',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final selectedAddress = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddressUser(),
                                ),
                              );

                              if (selectedAddress != null &&
                                  selectedAddress is String) {
                                addressController.text = selectedAddress;
                              }
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: const Color(0xFFE8F1FF),
                          height: 70,
                          width: double.infinity,
                          child: const Center(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 36,
                            ),
                          ),
                        ),
                      ),

                      //TODO: payment method
                      const SizedBox(height: 18),
                      Text(
                        'Payment method',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F1FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment card',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "**** **** 0696 4629",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          DropdownButton<MethodPayment>(
                            value: selectedMethod,
                            onChanged: (MethodPayment? newValue) {
                              if (newValue != null) {
                                ref
                                    .read(selectedMethodProvider.notifier)
                                    .state = newValue;
                              }
                            },
                            items:
                                MethodPayment.values.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Text(methodPaymentToString(method)),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                      //TODO: List of cartItem
                      const SizedBox(height: 150),
                      //TODO: Total price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${widget.totalAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shopping',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${shopping.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 28, thickness: 1.2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total cost',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '\$${totalCost.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: Payment button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5CA9F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: handlePayment,
                    child: Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
