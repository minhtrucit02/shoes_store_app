import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/screeen/product_detail_screen.dart';
import 'package:shoes_store_app/screeen/profile_screen.dart';
import 'package:shoes_store_app/screeen/see_all_product_screen.dart';
import 'package:shoes_store_app/screeen/shopping_cart_screen.dart';

import '../providers/home_provider.dart';
import '../widgets/app_bar_card.dart';
import '../widgets/brand_list.dart';
import '../widgets/popular_product.dart';
import '../widgets/search_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _onItemTapped(int index) {
    try {
      ref.read(homeIndexProvider.notifier).state = index;

      switch (index) {
        case 0: // Home
          break;
        case 1: // Favorite
          _handleFavoriteNavigation();
          break;
        case 2: // Shopping bag
          _handleCartNavigation();
          break;
        case 3: // Notifications
          _handleNotificationNavigation();
          break;
        case 4: // Profile
          _handleProfileNavigation();
          break;
      }
    } catch (e) {
      _showErrorSnackBar('Navigation error occurred');
    }
  }

  void _handleFavoriteNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favorites feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleCartNavigation() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showLoginSnackBar();
    } else {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShoppingCartScreen(),
          ),
        );
      } catch (e) {
        _showErrorSnackBar('Could not open shopping cart');
      }
    }
  }

  void _handleNotificationNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleProfileNavigation() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Profile(),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Could not open profile');
    }
  }

  void _showLoginSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login to continue'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSeeAllProduct(){
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeeAllProduct(
                (String productId) {
              // Handle product tap from SeeAllProduct screen
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(productId),
                  ),
                );
              } catch (e) {
                _showErrorSnackBar('Could not open product details');
              }
            },
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Could not open products page');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(homeIndexProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const AppBarCard(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SearchCard(),
              ),
            ),

            // Brand List Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: BrandList(),
              ),
            ),

            // Popular Shoes Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Shoes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _showSeeAllProduct,
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: PopularProduct(
                onProductTap: (String productId) {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(productId),
                      ),
                    );
                  } catch (e) {
                    _showErrorSnackBar('Could not open product details');
                  }
                },
              ),
            ),

            // New Arrivals Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle see all new arrivals
                      },
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            // SliverToBoxAdapter(
            //   child: NewArrivals(
            //     onProductTap: (String productId) {
            //       try {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ProductDetailScreen(productId),
            //           ),
            //         );
            //       } catch (e) {
            //         _showErrorSnackBar('Could not open product details');
            //       }
            //     },
            //   ),
            // ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}