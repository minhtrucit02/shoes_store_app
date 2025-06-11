import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/product_provider.dart';
import 'package:shoes_store_app/widgets/product_card.dart';

class PopularProduct extends ConsumerWidget {
  final void Function(String productId) onProductTap;

  const PopularProduct({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(productsStreamProvider);

    return productStream.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No data product'));
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => onProductTap(product.id),
              child: ProductCard(product: product),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi: $e')),
    );
  }
}
