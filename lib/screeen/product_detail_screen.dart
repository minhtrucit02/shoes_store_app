import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/cart_item.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';
import 'package:shoes_store_app/providers/cart_item_provider.dart';
import 'package:shoes_store_app/providers/product_provider.dart';
import 'package:shoes_store_app/screeen/shopping_cart_screen.dart';
import 'package:shoes_store_app/widgets/description_widget.dart';

import '../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen(this.productId, {super.key});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(getProductByIdProvider(productId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Bạn cần đăng nhập để xem giỏ hàng"),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
                );
              },
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          final selectedSize = ref.watch(selectedSizeProvider);
          final getImageKey = ref.watch(selectedImageProductProvider) ??
              product?.listImageProduct.entries.first.key;
          final productSizeAsync = ref.watch(
            getProductSizesProvider((product!.id, getImageKey!)),
          );
          final imageLength = product.listImageProduct.keys.toList();

          return productSizeAsync.when(
            data: (sizes) {
              return Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          //TODO: product image
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Image.network(
                              product.listImageProduct[getImageKey]?.url ?? '',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Best Seller Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'BEST SELLER',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  //TODO: product name
                                  const SizedBox(height: 12),
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  //TODO: price
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //TODO: product description
                                  const SizedBox(height: 20),
                                  ExpandableText(text: product.description),

                                  // TODO: gallery
                                  const SizedBox(height: 24),
                                  const Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imageLength.length,
                                      itemBuilder: (context, index) {
                                        final imageKey = imageLength[index];
                                        final isSelected = imageKey == getImageKey;
                                        final imageUrl = product
                                            .listImageProduct[imageKey]?.url ??
                                            '';
                                        return GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(selectedImageProductProvider
                                                .notifier)
                                                .state = imageKey;
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 12),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey.shade300,
                                                width: isSelected ? 2 : 1,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                imageUrl,
                                                width: 72,
                                                height: 72,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Size Selection
                                  const SizedBox(height: 24),

                                  const SizedBox(height: 24),
                                  const Text(
                                    'Size',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sizes.length,
                                      itemBuilder: (context, index) {
                                        final size = sizes.keys.elementAt(index);
                                        final quantity = sizes[size] ?? 0;
                                        final isAvailable = quantity > 0;
                                        final isSelected = selectedSize == size;
                                        return GestureDetector(
                                          onTap: () {
                                            if (isAvailable) {
                                              ref
                                                  .read(selectedSizeProvider.notifier)
                                                  .state = size;
                                            }
                                          },
                                          child: Container(
                                            width: 50,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color:
                                              isAvailable
                                                  ? (isSelected
                                                  ? Colors.blue
                                                  : Colors.white)
                                                  : Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(25),
                                              border: Border.all(
                                                color:
                                                isAvailable
                                                    ? (isSelected
                                                    ? Colors.blue
                                                    : Colors.grey)
                                                    : Colors.grey.shade400,
                                                width: 1.5,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              size.toString(),
                                              style: TextStyle(
                                                color:
                                                isAvailable
                                                    ? (isSelected
                                                    ? Colors.white
                                                    : Colors.black)
                                                    : Colors.grey.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Extra spacing at bottom
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Bottom Section - Price and Add to Cart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          // Price Section
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Add to Cart Button
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bạn cần đăng nhập để thêm vào giỏ hàng',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (sizes.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Sản phẩm hiện không có size khả dụng.",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (selectedSize == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Vui lòng chọn size trước khi thêm vào giỏ hàng',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final cartItem = CartItem(
                                  id: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  productId: product.id,
                                  productName: product.name,
                                  productImage: product
                                      .listImageProduct[getImageKey]?.url ??
                                      '',
                                  price: product.price,
                                  productSize: selectedSize,
                                  quantity: 1,
                                  cartStatus: CartItemStatus.unpaid,
                                  cartId: user.uid,
                                  createdAt: DateTime.now().toIso8601String(),
                                );

                                try {
                                  await ref
                                      .watch(addCartItemProvider(cartItem).future);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShoppingCartScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Lỗi: ${e.toString()}'),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Add To Cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const Center(child: Text("Không thể tải sản phẩm")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text("Không thể tải sản phẩm")),
      ),
    );
  }
}