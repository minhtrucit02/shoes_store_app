import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/brand_service_provider.dart';
import 'band_card.dart';


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

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: uniqueBrands.length,
            itemBuilder: (context, index) {
              final brand = uniqueBrands[index];
              return BrandCard(
                brand: brand['brand'] as String,
                logo: 'assets/logo/${brand['imagePath']}',
                isSelected: index == selectedIndex,
                onTap: () {
                  ref.read(selectedBrandIndexProvider.notifier).state = index;
                },
              );
            },
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
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
