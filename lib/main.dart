import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'login_page.dart';
import 'features_page.dart';
import 'crops_page.dart';
import 'welcome_page.dart'; // ✅ Import the new WelcomePage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FarmFlowApp());
}

class FarmFlowApp extends StatelessWidget {
  const FarmFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Farm Flow",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthGate(),

      // ✅ Define routes here ONLY ONCE
      routes: {
        '/login': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(), // ✅ added
        '/features': (context) => const FeaturesPage(),
        '/crops': (context) => const CropsPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // ✅ After login → go to WelcomePage instead of FeaturesPage
          return const WelcomePage();
        } else {
          // ❌ Not logged in → show LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
