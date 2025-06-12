import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/cart_item.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';
import 'package:shoes_store_app/providers/brand_service_provider.dart';
import 'package:shoes_store_app/providers/cart_item_provider.dart';
import 'package:shoes_store_app/providers/product_provider.dart';
import 'package:shoes_store_app/screeen/shopping_cart_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  ProductDetailScreen(this.productId, {super.key});
  final String productId;
  final List<int> productSize = [38, 39, 40, 41, 42, 43];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(getProductByIdProvider(productId));
    return Scaffold(
      body: productAsync.when(
        data: (product) {
          final imagePaths =
              product?.listImageProduct.values.map((e) => e.url).toList();
          final brandAsync = ref.watch(getBrandByIdProvider(product!.brandId));
          final selectedSize = ref.watch(selectedSizeProvider);
          final selectedImageProduct = ref.watch(selectedImageProductProvider);
          return brandAsync.when(
            data:
                (brand) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: Image product
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: Image.asset(
                          'assets/${brand?.name}/${selectedImageProduct ?? imagePaths?.first}',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),

                      //TODO: Product detail
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'BEST SELLER',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  brand!.name.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            //TODO: product name
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                letterSpacing: 0.5,
                              ),
                            ),

                            //TODO: price
                            const SizedBox(height: 8),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.black,
                                height: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            //TODO: description
                            const SizedBox(height: 16),
                            Text(
                              product.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                height: 1.5,
                                fontSize: 14,
                              ),
                            ),
                            //TODO: gallery
                            const SizedBox(height: 24),
                            const Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imagePaths?.length,
                                itemBuilder: (context, index) {
                                  final image = imagePaths?[index];
                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(
                                            selectedImageProductProvider
                                                .notifier,
                                          )
                                          .state = image;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/${brand.name}/${imagePaths?[index]}',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            //TODO: product Size
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productSize.length,
                                itemBuilder: (context, index) {
                                  final size = productSize[index];
                                  final isSelected = selectedSize == size;
                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(selectedSizeProvider.notifier)
                                          .state = size;
                                    },
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.blue
                                                : Colors.white,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow:
                                            isSelected
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.blue
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$size',
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 18),
                            //TODO: add to shopping Cart
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Bạn cần đăng nhập để thêm vào giỏ hàng',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (selectedSize == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Vui lòng chọn size trước khi thêm vào giỏ hàng',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (selectedImageProduct == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Vui lòng chọn ảnh sản phẩm')),
                                        );
                                        return;
                                      }
                                      final cartItem = CartItem(
                                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                                        userId: user.uid,
                                        productId: product.id,
                                        productName: product.name,
                                        productImage: 'assets/${brand.name}/${selectedImageProduct ?? imagePaths?.first}',
                                        productPrice: product.price,
                                        productSize: selectedSize,
                                        quantity: 1,
                                        status: CartStatus.unpaid,
                                        buyDate: DateTime.now().toIso8601String(),
                                      );
                                      try{
                                        await ref.read(addCartItemProvider(cartItem).future);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Đã thêm thành công')),
                                        );
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartScreen()));
                                      }catch(e){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Lỗi: ${e.toString()}')),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Add To Cart",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const Center(child: Text("Không thể tải")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text("Không thể tải sản phẩm")),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
        centerTitle: true,
      ),
    );
  }
}
