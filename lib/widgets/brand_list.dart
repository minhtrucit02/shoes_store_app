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

    return brandAsync.when(
      loading: () => _buildLoadingShimmer(),
      error: (error, _) => Center(
        child: Text('Lỗi: $error'),
      ),
      data: (brands) {
        final uniqueBrands = brands
            .map((e) => {'brand': e.name, 'imagePath': e.imagePath})
            .toSet()
            .toList();

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            key: ValueKey<int>(uniqueBrands.length),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: uniqueBrands.length,
              itemBuilder: (context, index) {
                final brand = uniqueBrands[index];
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 200 + (index * 100)),
                  opacity: 1.0,
                  child: AnimatedSlide(
                    duration: Duration(milliseconds: 200 + (index * 100)),
                    offset: const Offset(0, 0),
                    child: BrandCard(
                      brand: brand['brand']!,
                      logo: 'assets/logo/${brand['imagePath']}',
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

  Widget _buildLoadingShimmer() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: const SizedBox(),
          );
        },
      ),
    );
  }
}
