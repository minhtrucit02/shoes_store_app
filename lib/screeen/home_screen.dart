import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/home_provider.dart';
import 'package:shoes_store_app/screeen/profile_screen.dart';
import 'package:shoes_store_app/widgets/app_bar_card.dart';

import '../widgets/brand_list.dart';
import '../widgets/popular_product.dart';
import '../widgets/search_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _onItemTapped(int index){
    ref.read(homeIndexProvider.notifier).state = index;
    switch (index) {
      case 0: // Home
        break;
      case 1: // Favorite
      // TODO: Navigate to Favorite screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Favorites...')),
        );
        break;
      case 2: // Shopping bag
      // TODO: Navigate to Cart screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Shopping Bag...')),
        );
        break;
      case 3: // Notifications
      // TODO: Navigate to Notifications screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening Notifications...')),
        );
        break;
      case 4: // Profile
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Profile()));
        break;
    }
  }
@override
  Widget build(BuildContext context) {
  final selectedIndex = ref.watch(homeIndexProvider);

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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('New Arrivals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: (){},
                        child: Text('See all', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap:_onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
