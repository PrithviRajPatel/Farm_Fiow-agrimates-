import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'welcome_page.dart';
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

  /// 🔄 Decides the next page based on user & app state
  Future<Widget> _getNextPage(User? user) async {
    if (user == null) {
      return const LoginPage(); // 👉 Not logged in
    }

    final prefs = await SharedPreferences.getInstance();
    bool seenFeatures = prefs.getBool("seenFeatures") ?? false;
    String? selectedCrop = prefs.getString("selectedCrop");

    if (!seenFeatures) {
      return const FeaturesPage(); // 👉 First-time users
    } else if (selectedCrop == null) {
      return const CropSelectionPage(); // 👉 After features, pick crop
    } else {
      return DashboardPage(crop: selectedCrop); // 👉 Existing users
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farm Flow",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // ✅ Modern Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return FutureBuilder<Widget>(
            future: _getNextPage(snapshot.data),
            builder: (context, futureSnap) {
              if (futureSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (futureSnap.hasError) {
                return const Scaffold(
                  body: Center(child: Text("❌ Error loading app")),
                );
              }
              return futureSnap.data ?? const LoginPage();
            },
          );
        },
      ),
      routes: {
        "/login": (context) => const LoginPage(),
        "/welcome": (context) => const WelcomePage(),
        "/features": (context) => const FeaturesPage(),
        "/crops": (context) => const CropSelectionPage(),
        "/dashboard": (context) {
          return FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final crop = snapshot.data!.getString("selectedCrop");
              if (crop == null) {
                return const CropSelectionPage(); // 👉 fallback if crop missing
              }
              return DashboardPage(crop: crop);
            },
          );
        },
      },
    );
  }
}
