import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/widgets/app_bar_card.dart';

import '../widgets/brand_list.dart';
import '../widgets/popular_product.dart';
import '../widgets/search_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: AppBarCard(),),
      body: SafeArea(
          child:CustomScrollView(
            slivers: [
              //TODO: add Search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [SearchCard()],
                  ),
                ),
              ),
              //TODO: add List Brand

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: BrandList(),
                ),
              ),

              //TODO: add popular shoes title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popular Shoes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        child: Text('See all', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),

              //TODO: add popular shoes element
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,),
                  child: PopularProduct(),
                ),
              ),
              //TODO: add new arrivals
            ],
          ),
      ),
    );
  }
}
