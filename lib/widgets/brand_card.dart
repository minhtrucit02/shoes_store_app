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
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(right: screenWidth * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                logo,
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: screenWidth * 0.04,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? screenWidth * 0.02 : 0,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1.0 : 0.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? null : 0,
                child: isSelected
                    ? Text(
                  brand,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.032,
                  ),
                )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
