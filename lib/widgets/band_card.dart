import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final String brand;
  final String logo;
  final bool isSelected;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.brand,
    required this.logo,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              logo,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}