import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/widgets/product_card.dart';

import '../providers/product_provider.dart' show productsStreamProvider;

class PopularProduct extends ConsumerWidget {
  final void Function(String productId) onProductTap;

  const PopularProduct({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(productsStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return productStream.when(
      data: (products) {
        if (products.isEmpty) {
          return SizedBox(
            height: screenHeight * 0.3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: screenWidth * 0.15,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  Text(
                    'No products available',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: screenHeight * 0.32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => onProductTap(product.id),
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.04),
                  child: SizedBox(
                    width: screenWidth * 0.42,
                    child: ProductCard(product: product),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: screenHeight * 0.32,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Loading products...',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
      error: (e, _) => SizedBox(
        height: screenHeight * 0.3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: screenWidth * 0.15,
                color: Colors.red[400],
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Error loading products',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.red[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
              Text(
                '$e',
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}