import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_store_app/screeen/home_screen.dart';
import '../widgets/onboarding_template.dart';

class WaitingScreen2 extends StatelessWidget {
  const WaitingScreen2({super.key});

  void _finish(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      image: 'assets/image/screen2.png',
      title: 'Follow Latest\nStyle Shoes',
      description: 'There Are Many Beautiful And\nAttractive Plants To Your Room',
      index: 1,
      onNext: () => _finish(context),
    );
  }
}
