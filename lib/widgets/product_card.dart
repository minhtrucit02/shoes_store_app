import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screeen/product_detail_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  bool isFavorited = false;
  late AnimationController _favoriteController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstImage = widget.product.listImageProduct.values.first;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(widget.product.id),
          ),
        );

      },
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleController.value * 0.05),
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            child: Image.network(
                              firstImage.url,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: screenWidth * 0.12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorited = !isFavorited;
                              });
                              if (isFavorited) {
                                _favoriteController.forward();
                              } else {
                                _favoriteController.reverse();
                              }
                            },
                            child: AnimatedBuilder(
                              animation: _favoriteController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_favoriteController.value * 0.2),
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.015),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isFavorited ? Icons.favorite : Icons.favorite_border,
                                      size: screenWidth * 0.05,
                                      color: isFavorited ? Colors.red : Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.025),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenWidth * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(screenWidth * 0.015),
                    ),
                    child: Text(
                      'BEST SELLER',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.035,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.product.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: screenWidth * 0.045,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}