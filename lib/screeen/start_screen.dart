import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_store_app/screeen/start_journey_screen.dart';
import 'home_screen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  Future<Widget> _loadNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('has_seen_onboarding') ?? false;
    return seen ? const HomeScreen() : const StartJourneyScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/image/anhnen.png', fit: BoxFit.cover),
                const Center(
                  child: Text(
                    'Welcome to Shoes Store!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black45)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Scaffold(
            body: Center(child: Text("Something went wrong!")),
          );
        }
      },
    );
  }
}
