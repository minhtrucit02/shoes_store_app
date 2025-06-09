import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/screeen/home_screen.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    analytics.logEvent(name: 'app_started');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoes Store App',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      home: HomeScreen(),
    );
  }
}
