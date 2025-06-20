import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/home_provider.dart';
import 'package:shoes_store_app/screeen/product_detail_screen.dart';
import 'package:shoes_store_app/screeen/profile_screen.dart';
import 'package:shoes_store_app/screeen/shopping_cart_screen.dart';
import 'package:shoes_store_app/widgets/app_bar_card.dart';

import '../widgets/brand_list.dart';
import '../widgets/popular_product.dart';
import '../widgets/product_new_arrival.dart';
import '../widgets/search_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  // Extract navigation logic to separate method for better readability
  void _onItemTapped(int index) {
    ref.read(homeIndexProvider.notifier).state = index;

    switch (index) {
      case 0: // Home
      // Already on home, no action needed
        break;

      // case 1: // Favorite
      //   _navigateToFavorites();
      //   break;

      case 2: // Shopping bag
        _navigateToCart();
        break;

      // case 3: // Notifications
      //   _navigateToNotifications();
      //   break;

      case 4: // Profile
        _navigateToProfile();
        break;
    }
  }

  // void _navigateToFavorites() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     _showLoginRequiredSnackBar();
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const FavoritesScreen()),
  //     );
  //   }
  // }

  void _navigateToCart() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showLoginRequiredSnackBar();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
      );
    }
  }

  // void _navigateToNotifications() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     _showLoginRequiredSnackBar();
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const NotificationsScreen()),
  //     );
  //   }
  // }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
    );
  }

  void _showLoginRequiredSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login to access this feature'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSeeAllPopular() {
    // Navigate to all popular products screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const AllPopularProductsScreen()));
  }

  void _onSeeAllNewArrivals() {
    // Navigate to all new arrivals screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const AllNewArrivalsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(homeIndexProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const AppBarCard(),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //TODO: Search Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SearchCard(),
                  ],
                ),
              ),
            ),

            //TODO: Brand List Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const BrandList(),
              ),
            ),

            //TODO: Popular Shoes Title
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
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: _onSeeAllPopular,
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //TODO: Popular Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: PopularProduct(
                  onProductTap: (String productId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(productId),
                      ),
                    );
                  },
                ),
              ),
            ),

            //TODO: New Arrivals Title
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
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: _onSeeAllNewArrivals,
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //TODO: New Arrivals Section
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 8),
            //     child: const NewArrivals(),
            //   ),
            // ),

            // Add some bottom padding for better scrolling experience
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
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
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
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}