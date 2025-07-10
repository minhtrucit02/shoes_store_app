import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/product_provider.dart';
import 'package:shoes_store_app/widgets/product_card.dart';

class SeeAllProduct extends ConsumerWidget {
  const SeeAllProduct(this.onProductTap, {super.key});
  final void Function(String productId) onProductTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getAllProduct = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        centerTitle: true,
      ),
      body: getAllProduct.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products found',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => onProductTap(product.id),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 160,
                    child: ProductCard(product: product),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Products'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(productsStreamProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Products'),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}