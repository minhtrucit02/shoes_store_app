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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          'Men\'s Shoes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
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
                      backgroundColor: Colors.redAccent,
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
                size: 24,
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
                          // Product image with enhanced styling
                          Container(
                            width: double.infinity,
                            height: 320,
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Stack(
                              children: [
                                // Circular background decoration
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                // Product image
                                Center(
                                  child: Transform.rotate(
                                    angle: -0.2,
                                    child: Image.network(
                                      product.listImageProduct[getImageKey]?.url ?? '',
                                      height: 240,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Product details section
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
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
                                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'BEST SELLER',
                                      style: TextStyle(
                                        color: Color(0xFF4A90E2),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),

                                  // Product name
                                  const SizedBox(height: 12),
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: -0.5,
                                      height: 1.2,
                                    ),
                                  ),

                                  // Price
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF4A90E2),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  // Product description
                                  const SizedBox(height: 20),
                                  ExpandableText(text: product.description),

                                  // Gallery section
                                  const SizedBox(height: 28),
                                  const Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
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
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            margin: const EdgeInsets.only(right: 12),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF4A90E2).withOpacity(0.1)
                                                  : Colors.grey.shade50,
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xFF4A90E2)
                                                    : Colors.grey.shade200,
                                                width: isSelected ? 2 : 1,
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                imageUrl,
                                                width: 68,
                                                height: 68,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Size Selection
                                  const SizedBox(height: 28),
                                  Row(
                                    children: [
                                      const Text(
                                        'Size',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Size guide indicators
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: const Row(
                                          children: [
                                            Text('EU', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                            SizedBox(width: 16),
                                            Text('US', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                            SizedBox(width: 16),
                                            Text('UK', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 56,
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
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            width: 56,
                                            height: 56,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF4A90E2)
                                                  : isAvailable
                                                  ? Colors.white
                                                  : Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(28),
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xFF4A90E2)
                                                    : isAvailable
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade200,
                                                width: isSelected ? 2 : 1,
                                              ),
                                              boxShadow: isSelected ? [
                                                BoxShadow(
                                                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ] : null,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              size.toString(),
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : isAvailable
                                                    ? Colors.black
                                                    : Colors.grey.shade400,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Extra spacing at bottom
                                  const SizedBox(height: 120),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Enhanced Bottom Section - Price and Add to Cart
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -10),
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
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Add to Cart Button
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90E2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                                shadowColor: const Color(0xFF4A90E2).withOpacity(0.3),
                              ),
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bạn cần đăng nhập để thêm vào giỏ hàng',
                                      ),
                                      backgroundColor: Colors.redAccent,
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
                                      backgroundColor: Colors.orange,
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
                                      backgroundColor: Colors.orange,
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

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã thêm vào giỏ hàng thành công!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

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
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Add To Cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
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
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
              ),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Không thể tải thông tin size",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.refresh(getProductSizesProvider((product!.id, getImageKey!))),
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ),
        ),
        error: (e, _) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "Không thể tải sản phẩm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(getProductByIdProvider(productId)),
                  child: const Text("Thử lại"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}