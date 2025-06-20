import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/brand_service_provider.dart';
import 'brand_card.dart';

class BrandList extends ConsumerWidget {
  const BrandList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandAsync = ref.watch(brandListProvider);
    final selectedIndex = ref.watch(selectedBrandIndexProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return brandAsync.when(
      loading: () => _buildLoadingShimmer(screenWidth),
      error: (error, _) => Center(
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Text(
            'Lỗi: $error',
            style: TextStyle(
              color: Colors.red[400],
              fontSize: screenWidth * 0.035,
            ),
          ),
        ),
      ),
      data: (brands) {
        final uniqueBrands = brands
            .map((e) => {'brand': e.name, 'imagePath': e.imagePath})
            .toSet()
            .toList();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SizedBox(
            key: ValueKey<int>(uniqueBrands.length),
            height: screenWidth * 0.13,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              physics: const BouncingScrollPhysics(),
              itemCount: uniqueBrands.length,
              itemBuilder: (context, index) {
                final brand = uniqueBrands[index];
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  opacity: 1.0,
                  child: AnimatedSlide(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    offset: const Offset(0, 0),
                    child: BrandCard(
                      brand: brand['brand']!,
                      logo: '${brand['imagePath']}',
                      isSelected: index == selectedIndex,
                      onTap: () {
                        ref.read(selectedBrandIndexProvider.notifier).state = index;
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer(double screenWidth) {
    return SizedBox(
      height: screenWidth * 0.13,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: screenWidth * 0.03),
            width: screenWidth * 0.25,
            height: screenWidth * 0.13,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}