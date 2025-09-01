import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'features_page.dart';
import 'crops_page.dart';
import 'dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getNextPage(User? user) async {
    if (user == null) return const LoginPage();

    final prefs = await SharedPreferences.getInstance();
    final seenFeatures = prefs.getBool("seenFeatures") ?? false;
    final selectedCrop = prefs.getString("selectedCrop");

    if (!seenFeatures) return const FeaturesPage();
    if (selectedCrop == null) return const CropSelectionPage();

    return DashboardPage(crop: selectedCrop);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farm Flow",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return FutureBuilder<Widget>(
            future: _getNextPage(snapshot.data),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              if (snap.hasError) {
                return const Scaffold(
                  body: Center(child: Text("❌ Error loading app")),
                );
              }
              return snap.data ?? const LoginPage();
            },
          );
        },
      ),
      routes: {
        "/login": (context) => const LoginPage(),
        "/features": (context) => const FeaturesPage(),
        "/crops": (context) => const CropSelectionPage(),
        "/dashboard": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          final crop = args?["crop"];
          if (crop == null) return const CropSelectionPage();
          return DashboardPage(crop: crop);
        },
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
