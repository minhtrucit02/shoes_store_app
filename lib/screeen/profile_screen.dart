import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/providers/cart_provider.dart';
import 'package:shoes_store_app/providers/user_provider.dart';
import 'package:shoes_store_app/screeen/history_payments.dart';
import 'package:shoes_store_app/screeen/home_screen.dart';
import 'package:shoes_store_app/screeen/sign_up_screen.dart';

import '../providers/auth_provider.dart';
import '../widgets/history_payment_card.dart';
import 'login_screen.dart';


class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.currentUser;
    final isLoggedIn = currentUser != null;
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon and Title
                Icon(
                  Icons.account_circle_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 24),
                Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Please login to access your profile and manage your account settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 32),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 16),

                //TODO: Create account
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to create account
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));

                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    //TODO: Login successfully
    final userData = ref.watch(getUserProvider(currentUser.uid));
    final getHistoryCard = ref.watch(getHistoryCartItemProvider(currentUser.uid));
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userData.when(
        data: (user) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Profile Image
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: currentUser.photoURL != null
                                ? NetworkImage(currentUser.photoURL!)
                                : AssetImage('assets/images/default_avatar.png') as ImageProvider,                      ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        user!.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Account Settings
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.payment,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.security,
                        title: 'Security',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Orders & Wishlist
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders & Wishlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      _SettingsItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryPaymentScreen(),
                            ),
                          );
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.favorite_border,
                        title: 'My Wishlist',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.local_shipping_outlined,
                        title: 'Shipping Details',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Other Settings
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      _SettingsItem(
                        icon: Icons.language,
                        title: 'Language',
                        trailing: Text('English'),
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                //TODO: Sign Out Button
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      final authNotifier = ref.read(authProvider.notifier);

                      await authNotifier.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );

        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}